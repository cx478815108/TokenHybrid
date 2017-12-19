//
//  TokenSSRenderController.m
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenHybridRenderController.h"
#import "TokenHybridDefine.h"
#import "TokenViewBuilder.h"
#import "TokenJSContext.h"
#import "TokenXMLNode.h"
#import "TokenDocument.h"
#import "TokenPureComponent.h"
#import "TokenButtonComponent.h"
#import "TokenHybridConstant.h"
#import "TokenHybridOrganizer.h"
#import "TokenAssociateContext.h"

#import "NSString+Token.h"
#import "UIView+Attributes.h"

@interface TokenHybridRenderController () <TokenViewBuilderDelegate,TokenJSContextDelegate>
@property(nonatomic ,strong) UILabel               *reloadLabel;
@property(nonatomic ,strong) TokenViewBuilder      *viewBuilder;
@property(nonatomic ,strong) TokenAssociateContext *associateContext;
@end

@implementation TokenHybridRenderController{
    NSMutableArray *_navItems;
}

-(instancetype)initWithHTMLURL:(NSString *)htmlURL{
    if (self = [super init]) {
        self.htmlURL              = htmlURL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.hiddenTitle) {
        self.title = @"加载中...";
    }
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //当导航栏透明时候，在viewWillAppear 里面才能正确拿到self.view.bounds
    self.viewBuilder          = [[TokenViewBuilder alloc] initWithBodyViewFrame:self.view.bounds];
    self.viewBuilder.delegate = self;
    [self.viewBuilder buildViewWithSourceURL:self.htmlURL];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self viewBuilderWillRunScript];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.viewBuilder.jsContext pageClose];
    [[NSNotificationCenter defaultCenter] postNotificationName:TokenHybridPageDisappearNotification object:nil];
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = NO;
}

-(void)reloadData{
    if (!self.hiddenTitle) { self.title = @"加载中...";}
    self.viewBuilder = [[TokenViewBuilder alloc] initWithBodyViewFrame:self.view.frame];
    self.viewBuilder.delegate = self;
    [self.viewBuilder buildViewWithSourceURL:_htmlURL];
}

#pragma mark - TokenHierarchyAnalystDelegate
-(void)viewBuilderWillRunScript{
    if (self.extension) {
        JSValue *windowValue = [self.viewBuilder.jsContext evaluateScript:@"setExtension"];
        NSDictionary *newObj = [self.extension copy];
        [windowValue callWithArguments:newObj?@[newObj]:nil];
    }
    self.viewBuilder.jsContext.delegate = self;
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didFetchTitle:(NSString *)title{
    self.title = title;
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder parserErrorOccurred:(NSError *)error{
    if (!self.hiddenTitle) {
        self.title = @"加载错误";
    }
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *clsString = NSStringFromClass([obj class]);
        if ([clsString hasPrefix:@"Token"]) { [obj removeFromSuperview];}
    }];
    self.reloadLabel.hidden = NO;
    NSString *desc = @"页面存在语法错误:\n".token_append(error.description).token_append(@"\n点击重新加载!");
    self.reloadLabel.text = desc;
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didCreatNavigationBarNode:(TokenXMLNode *)node{
    //navItems
    NSMutableArray *_navigationBarItems = @[].mutableCopy;
    [node.childNodes enumerateObjectsUsingBlock:^(__kindof TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj.name isEqualToString:@"navItem"]) return ;
        TokenButtonComponent *buttonItem = [UIView token_produceViewWithNode:obj];
        buttonItem.associatedNode = obj;
        obj.associatedView = buttonItem;
        [buttonItem token_updateAppearanceWithNormalDictionary:obj.innerAttributes];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:buttonItem];
        [_navigationBarItems addObject:item];
    }];
    self.navigationItem.rightBarButtonItems = _navigationBarItems;
}

-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didCreatBodyView:(TokenPureComponent *)view{
    _reloadLabel.hidden = YES;
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *clsString = NSStringFromClass([obj class]);
        if ([clsString hasPrefix:@"Token"]) { [obj removeFromSuperview];}
    }];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
}

#pragma mark - TokenJSContextDelegate
-(void)context:(TokenJSContext *)context setPriviousExtension:(NSDictionary *)extension{
    if ([extension isKindOfClass:[NSDictionary class]] && self.previousController) {
        NSDictionary *previousExt         = self.previousController.extension;
        NSMutableDictionary *ext          = [NSMutableDictionary dictionaryWithDictionary:previousExt?previousExt:@{}];
        [ext addEntriesFromDictionary:extension];
        self.previousController.extension = ext;
    }
}

-(TokenAssociateContext *)contextGetAssociateContext{
    if (_associateContext == nil) {
        _associateContext = [[TokenAssociateContext alloc] init];
    }
    _associateContext.currentAssociateController = self;
    _associateContext.currentAssociateViewBuilder = self.viewBuilder;
    return _associateContext;
}

#pragma mark - getter

-(UILabel *)reloadLabel{
    if (_reloadLabel == nil) {
        _reloadLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, CGRectGetWidth(self.view.frame)-20, 200)];
        _reloadLabel.userInteractionEnabled = YES;
        _reloadLabel.numberOfLines = 0;
        _reloadLabel.textAlignment = NSTextAlignmentLeft;
        _reloadLabel.textColor     = [UIColor darkTextColor];
        [_reloadLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadData)]];
        [self.view addSubview:_reloadLabel];
    }
    return _reloadLabel;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    HybridLog(@"TokenHybridRenderController dead");
}

@end
