//
//  TokenHybridRenderView.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/12/12.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenHybridRenderView.h"
#import "TokenHybridDefine.h"
#import "TokenHybridConstant.h"
#import "TokenAssociateContext.h"
#import "NSString+Token.h"

@interface TokenHybridRenderView() 
@property(nonatomic ,strong) TokenViewBuilder      *viewBuilder;
@property(nonatomic ,strong) TokenAssociateContext *associateContext;
@property(nonatomic ,assign) Class                  cachedClass;
@end

@implementation TokenHybridRenderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cachedClass = NSClassFromString(@"TokenHybridRenderController");
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cachedClass = NSClassFromString(@"TokenHybridRenderController");
    }
    return self;
}

#pragma mark - TokenJSContextDelegate
-(TokenAssociateContext *)contextGetAssociateContext{
    if (_associateContext == nil) {
        _associateContext = [[TokenAssociateContext alloc] init];
    }
    _associateContext.currentAssociateView             = self;
    _associateContext.currentAssociateViewBuilder      = self.viewBuilder;
    _associateContext.associateViewPushControllerClass = self.cachedClass;
    return _associateContext;
}

#pragma mark - TokenViewBuilderDelegate
-(void)buildViewWithSourceURL:(NSString *)url
      containerViewController:(UIViewController *)controller
  childRenderControlllerClass:(__unsafe_unretained Class)childClass{
    self.associatedController = controller;
    [self.viewBuilder buildViewWithSourceURL:url];
    if ([childClass isSubclassOfClass:NSClassFromString(@"TokenHybridRenderController")]) {
        self.cachedClass = childClass;
    }
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didFetchTitle:(NSString *)title{
    self.associatedController.title = title;
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder parserErrorOccurred:(NSError *)error{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *clsString = NSStringFromClass([obj class]);
        if ([clsString hasPrefix:@"Token"]) { [obj removeFromSuperview];}
    }];
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didCreatBodyView:(TokenPureComponent *)view{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *clsString = NSStringFromClass([obj class]);
        if ([clsString hasPrefix:@"Token"]) { [obj removeFromSuperview];}
    }];
    view.frame = self.bounds;
    [self addSubview:view];
}

#pragma mark - getter
-(TokenViewBuilder *)viewBuilder{
    if (_viewBuilder == nil) {
        _viewBuilder = [[TokenViewBuilder alloc] initWithBodyViewFrame:self.bounds];
        _viewBuilder.delegate = self;
        _viewBuilder.jsContext.delegate = self;
    }
    return _viewBuilder;
}

@end
