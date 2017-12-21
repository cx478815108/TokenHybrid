//
//  TokenJSContext.m
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/24.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenJSContext.h"
#import "TokenHybridConstant.h"
#import "TokenTool.h"
#import "JSValue+Token.h"
#import "TokenHybridDefine.h"
#import "TokenAssociateContext.h"
#import "TokenHybridRenderView.h"
#import "TokenHybridRenderController.h"
#import "TokenViewBuilder.h"

@interface TokenJSContext()
@end

@implementation TokenJSContext{
    NSInteger _eventValueAliveCount;
}

+(NSDictionary <NSString *,NSDictionary *>*)privateScript{
    static NSMutableDictionary *scriptStore;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scriptStore = @{}.mutableCopy;
        NSString *scriptName = @"TokenBase";
        NSString *baseScriptPath = [[NSBundle bundleForClass:self] pathForResource:scriptName ofType:@"js"];
        NSString *baseScript     = [NSString stringWithContentsOfFile:baseScriptPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *baseScriptURL     = [NSURL URLWithString:baseScriptPath];
        if (baseScript && baseScriptURL) {
            [scriptStore setObject:@{@"text":baseScript,@"url":baseScriptURL} forKey:scriptName];
        }
    });
    return scriptStore;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self injectSupprotNativeObj];
        _eventValueAliveCount = 0;
        __weak typeof(self) weakSelf = self;
        self.exceptionHandler = ^(JSContext *context, JSValue *exception) {
            context.exception = exception;
            __strong typeof(weakSelf) sSelf = weakSelf;
            if ([sSelf.delegate respondsToSelector:@selector(context:didReceiveLogInfo:)]) {
                NSString *info = [NSString stringWithFormat:@"错误：%@",[exception toString]];
                [sSelf.delegate context:sSelf didReceiveLogInfo:info];
            }
            HybridLog(@"JSContext exception : %@", exception);
        };
    }
    return self;
}

-(void)injectSupprotNativeObj{
    
    TokenTool *token = [[TokenTool alloc] init];
    token.jsContext  = self;
    self[@"token"]   = token;
    
    [[TokenJSContext privateScript] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *text = obj[@"text"];
        NSURL    *url  = obj[@"url"];
        [self evaluateScript:text withSourceURL:url];
    }];
    
    __weak typeof(self) weakSelf = self;
    self[@"receiveLog"] = ^void(JSValue *info){
        __strong typeof(weakSelf) sSelf = weakSelf;
        if ([sSelf.delegate respondsToSelector:@selector(context:didReceiveLogInfo:)]) {
            [sSelf.delegate context:sSelf didReceiveLogInfo:[info toString]];
        }
    };
    
    self[@"setPriviousPageExtension"] = ^void(JSValue *info){
        __strong typeof(weakSelf) sSelf = weakSelf;
        if ([sSelf.delegate respondsToSelector:@selector(context:setPriviousExtension:)]) {
            [sSelf.delegate context:sSelf setPriviousExtension:[info toDictionary]];
        }
    };
}

-(void)pageShow{
    NSString *script = @"if (window.pageShow != undefined){ window.pageShow();}";
    [self evaluateScript:script];
}

-(void)pageClose{
    NSString *script = @"if (window.pageClose != undefined){ window.pageClose();}";
    [self evaluateScript:script];
}

-(void)pageRefresh{
    NSString *script = @"if (window.pageRefresh != undefined){ window.pageRefresh();}";
    [self evaluateScript:script];
}

-(void)keepEventValueAlive:(JSValue *)value{
    _eventValueAliveCount += 1;
    JSValue *function = [self evaluateScript:@"window.keepEventValueAlive"];
    [function callWithArguments:@[@(_eventValueAliveCount),value]];
}

#pragma mark - getter

-(UIViewController *)getContainerController{
    UIViewController *viewController;
    if ([self.delegate respondsToSelector:@selector(contextGetAssociateContext)]) {
        viewController = [self.delegate contextGetAssociateContext].currentAssociateView.associatedController;
        if (viewController == nil) {
            viewController = [self.delegate contextGetAssociateContext].currentAssociateController;
        }
    }
    return viewController;
}

-(Class)getViewPushedControllerClass{
    if ([self.delegate respondsToSelector:@selector(contextGetAssociateContext)]) {
        TokenAssociateContext *context = [self.delegate contextGetAssociateContext];
        if (context.currentAssociateView) {
            return context.associateViewPushControllerClass;
        }
        else {
            UIViewController *controller = [self.delegate contextGetAssociateContext].currentAssociateController;
            if ([controller isKindOfClass:[TokenHybridRenderController class]]) {
                return [controller class];
            }
            return [TokenHybridRenderController class];
        }
    }
    return [TokenHybridRenderController class];
}

-(NSUserDefaults *)getCurrentPageUserDefaults;{
    if ([self.delegate respondsToSelector:@selector(contextGetAssociateContext)]) {
        return [self.delegate contextGetAssociateContext].currentAssociateViewBuilder.currentPageDefaults;
    }
    return nil;
}

- (void)dealloc
{
    HybridLog(@"TokenJSContext dead");
}

@end
