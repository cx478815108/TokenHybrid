//
//  TokenViewBuilder.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenViewBuilder.h"
#import "TokenDocument.h"
#import "TokenXMLNode.h"
#import "TokenXMLParser.h"
#import "TokenHybridStack.h"

#import "TokenPureComponent.h"
#import "TokenNodeComponentRegister.h"
#import "TokenHybridOrganizer.h"
#import "TokenHybridDefine.h"
#import "TokenCSSParser.h"
#import "TokenJSContext.h"

#import "NSString+TokenHybrid.h"
#import "UIView+Attributes.h"
#import "NSUserDefaults+Token.h"
#import "NSString+Token.h"
#import "TokenXMLNode+JSExport.h"
#import <TokenNetworking/TokenNetworking.h>

static dispatch_queue_t  kTokenCSSProcessQueue;

@interface TokenViewBuilder()<TokenXMLParserDelegate>
@property(nonatomic ,assign) NSInteger styleAndLinkNodeCount;
@property(nonatomic ,assign) NSInteger scriptNodeCount;
@end

@implementation TokenViewBuilder{
    TokenXMLParser   *_xmlParser;
    TokenHybridStack *_viewStack;
    TokenDocument    *_document;
    BOOL              _parserEnd;
    BOOL              _pageRefreshed;
    BOOL              _existCache;
    NSSet            *_nodeContainInnerCSSStyleSet;
    BOOL              _isWorking;
}

+(void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kTokenCSSProcessQueue = dispatch_queue_create("com.tokenCSSProcess.queue", DISPATCH_QUEUE_SERIAL);
    });
}

- (instancetype)initWithBodyViewFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.document      = [[TokenDocument alloc] init];
        self.jsContext     = [[TokenJSContext alloc] init];
        self.useCache      = YES;
        self.bodyViewFrame = frame;
    }
    return self;
}

-(void)buildViewWithSourceURL:(NSString *)url{
    HybridLog(@"buildViewWithSourceURL");
    if (url==nil || url.length == 0) { return;}
    
    self.document.sourceURL    = url;
    NSString *cacheKey         = NSString.token_md5(url);
    [[TokenHybridOrganizer sharedOrganizer] addPageDefaultWithSuiteName:cacheKey];
    self.currentPageDefaults   = NSUserDefaults.token_initWithSuiteName(cacheKey);
    NSData *documentCachedData = [self.currentPageDefaults objectForKey:cacheKey];
    if (documentCachedData && self.useCache) { //从缓存加载
        _existCache   = YES;
        self.document = [NSKeyedUnarchiver unarchiveObjectWithData:documentCachedData];
        [self recoverFromDocument:self.document];
        //再更新
        [self refreshViewExistCache:YES];
    }
    else { //从缓存不存在，直接更新
        [self refreshViewExistCache:NO];
    }
}

-(void)refreshView{
    if (_isWorking) return;
    [self refreshViewExistCache:YES];
}

-(void)refreshViewExistCache:(BOOL)existCache{
    _isWorking = YES;
    TokenNetworking.networking()
    .sendURL(^NSURL *(TokenNetworking *netWorking) {
        return [NSURL URLWithString:self.document.sourceURL];
    })
    .transform(^id(TokenNetworking *netWorking, id responsedObj) {
        NSString *html = [netWorking HTMLTextSerializeWithData:responsedObj];
        if (![html containsString:@"html-identify"] && ![html containsString:@"token"]) {
            NSError *error = [NSError errorWithDomain:@"com.token.xmlParser" code:999 userInfo:@{NSLocalizedDescriptionKey:@"不支持此HTML"}];
            if ([self.delegate respondsToSelector:@selector(viewBuilder:parserErrorOccurred:)]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate viewBuilder:self parserErrorOccurred:error];
                });
            }
            return nil;
        }
        return html;
    })
    .finish(^(TokenNetworking *netWorkingObj, NSURLSessionTask *task, NSString *responsedObj) {
        _isWorking = NO;
        if (responsedObj == nil || responsedObj.length == 0) return ;
        NSString *html = responsedObj;
        if (existCache) { //缓存存在，指纹对比
            NSString *newFinger = NSString.token_md5(html);
            NSString *oldFinger;
            if (self.document.html) {
                oldFinger = NSString.token_md5(self.document.html);
            }
            if (oldFinger == nil || ![oldFinger isEqualToString:newFinger]) {
                HybridLog(@"缓存存在并且指纹不一样，开始解析HTML，刷新UI");
                _pageRefreshed = YES;
                [self buildViewWithHTML:html];
            }
        }
        else {
            HybridLog(@"缓存不存开始解析HTML");
            [self buildViewWithHTML:responsedObj];
        }
    }, ^(TokenNetworking *netWorkingObj, NSError *error) {
        _isWorking = NO;
        if ([self.delegate respondsToSelector:@selector(parserErrorOccurred:)]) {
            [self.delegate viewBuilder:self parserErrorOccurred:error];
        }
        HybridLog(@"网页加载错误");
    });
}

-(void)buildViewWithHTML:(NSString *)html{
    HybridLog(@"buildViewWithHTML");
    if (html == nil || html.length == 0) { return;}
    self.document.html     = html;
    TokenXMLParser *parser = [[TokenXMLParser alloc] initWithBodyViewFrame:self.bodyViewFrame];
    parser.delegate        = self;
    [parser parserHTML:html];
    _xmlParser             = parser;
}

#pragma mark - recover
-(void)recoverFromDocument:(TokenDocument *)document{
    self.jsContext.name = document.titleNode.innerText;
    if ([self.delegate respondsToSelector:@selector(viewBuilder:didFetchTitle:)]) {
        [self.delegate viewBuilder:self didFetchTitle:document.titleNode.innerText];
    }
    if ([self.delegate respondsToSelector:@selector(viewBuilder:didCreatNavigationBarNode:)]) {
        [self.delegate viewBuilder:self didCreatNavigationBarNode:document.navigationBarNode];
    }
    _bodyView  = [self recoverViewFromNode:document.bodyNode];
    [_bodyView token_updateAppearanceWithCSSAttributes:document.bodyNode.cssAttributes shouldLayout:YES];
    [_bodyView token_updateAppearanceWithCSSAttributes:document.bodyNode.innerStyleAttributes shouldLayout:YES];
    [_bodyView token_updateAppearanceWithNormalDictionary:document.bodyNode.innerAttributes];
    [_bodyView applyFlexLayout];
    if ([self.delegate respondsToSelector:@selector(viewBuilder:didCreatBodyView:)]) {
        [self.delegate viewBuilder:self didCreatBodyView:_bodyView];
    }

    self.jsContext[@"document"] = self.document;
    self.document.jsContext     = self.jsContext;
    if ([self.delegate respondsToSelector:@selector(viewBuilderWillRunScript)]) {
        [self.delegate viewBuilderWillRunScript];
    }
    [self.document.scripts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.jsContext evaluateScript:obj];
    }];
}

-(__kindof UIView *)recoverViewFromNode:(TokenXMLNode *)node{
    TokenPureComponent *view = [UIView token_produceViewWithNode:node];
    view.associatedNode = node;
    node.associatedView = view;
    
    [view token_updateAppearanceWithCSSAttributes:node.cssAttributes shouldLayout:YES];
    [view token_updateAppearanceWithCSSAttributes:node.innerStyleAttributes shouldLayout:YES];
    [view token_updateAppearanceWithNormalDictionary:node.innerAttributes];
    [node.childNodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subview = [self recoverViewFromNode:obj];
        [view addSubview:subview];
    }];
    return view;
}

#pragma mark - TokenXMLParserDelegate

/**
 从此处开始解析HTML并构建View层级视图，NSXMLParser会渐进解析HTML，解析一个标签，会执行相应的动作
 */
-(void)parserDidStart{
    HybridLog(@"parserDidStart");
    _viewStack = [[TokenHybridStack alloc] init];
    if (_jsContext) {
        //缓存更新，新的HTML里面可能更新了JS，需要重置JSContext,再运行JS语句
        _jsContext[@"document"] = nil;
        id delegate = _jsContext.delegate;
        _jsContext = [[TokenJSContext alloc] init];
        _jsContext.delegate = delegate;
    }
}

/**
 1. 开始解析body标签内部了，只将UI部分限制在body内部
 2. body将会作为一个容器，并且被记录下来
 */
-(void)parser:(TokenXMLParser *)parser didStartNodeWithinBodyNode:(TokenXMLNode *)node{
    TokenPureComponent *view = [UIView token_produceViewWithNode:node];
    if (view == nil) {
        view = [[TokenPureComponent alloc] init];
    }
    //将node和view一一关联，方便js通过node 控制原生视图
    view.associatedNode = node;
    node.associatedView = view;
    [_viewStack push:view];
    
    if ([node.name isEqualToString:@"body"]) {
        //记录一
        _bodyView = view;
    }
}

/**
 当一个标签解析结束，可以调整UIView的层级结构
 */
-(void)parser:(TokenXMLParser *)parser didEndNodeWithinBodyNode:(TokenXMLNode *)node{
    //在End调整UIView层次结构
    UIView *currentView = [_viewStack pop];
    UIView *parentView  = [_viewStack top];
    [parentView addSubview:currentView];
}

/**
 解析到了标题
 */
-(void)parser:(TokenXMLParser *)parser didCreatTitleNode:(TokenXMLNode *)node{
    self.jsContext.name = node.innerText;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(viewBuilder:didFetchTitle:)]) {
            [self.delegate viewBuilder:self didFetchTitle:node.innerText];
        }
    });
}

-(void)parser:(TokenXMLParser *)parser didCreatNavigationBarNode:(TokenXMLNode *)node{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(viewBuilder:didCreatNavigationBarNode:)]) {
            [self.delegate viewBuilder:self didCreatNavigationBarNode:node];
        }
    });
}

/**
 整个head标签解析完毕，这时候应该分析里面的link，style，script标签，并且做相应的事
 */
-(void)parser:(TokenXMLParser *)parser didCreatHeadNode:(TokenXMLNode *)node{
    dispatch_async(kTokenCSSProcessQueue, ^{
        self.document.scripts  = @[];
        self.document.cssRules = @[];
        NSArray <TokenXMLNode *>* linkNodes    = [node getElementsByTagName:@"link"];
        NSArray <TokenXMLNode *>* styleNodes   = [node getElementsByTagName:@"style"];
        NSArray <TokenXMLNode *>* scriptsNodes = [node getElementsByTagName:@"script"];
        //记录一共有多少个这样的标签，方便统计，当下载完成后开始执行相应的动作
        self.styleAndLinkNodeCount             = linkNodes.count + styleNodes.count;
        self.scriptNodeCount                   = scriptsNodes.count;
        [self handleLinkNodes:linkNodes];
        [self handleStyleNodes:styleNodes];
        [self handleScriptNodes:scriptsNodes];
    });
}

-(void)parser:(TokenXMLParser *)parser didCreatRootNode:(TokenXMLNode *)node{
    _document.rootNode = node;
}

-(void)parser:(TokenXMLParser *)parser nodeContainInnerCSSStyle:(NSSet *)nodes{
    //这个方法返回HTML里面全部<style>写的CSS，单独拿出来记录
    _nodeContainInnerCSSStyleSet = nodes;
}

-(void)parserErrorOccurred:(NSError *)error{
    HybridLog(@"parserErrorOccurred %@",error);
    if ([self.delegate respondsToSelector:@selector(viewBuilder:parserErrorOccurred:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate viewBuilder:self parserErrorOccurred:error];
        });
    }
    _isWorking = NO;
    _document  = nil;
    _jsContext = nil;
    [self releaseObj];
}

-(void)parserDidEnd{
    HybridLog(@"parserDidEnd");
    _parserEnd = YES;
    [self startApplyCSSToView];
    [self startRunScript];
    [self releaseObj];
    _isWorking = NO;
}

#pragma mark - handle

/**
 处理link标签,下载CSS，并解析，匹配到相应的nodes上
 */
-(void)handleLinkNodes:(NSArray <TokenXMLNode *>*)nodes{
    [nodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *linkURL = obj.innerAttributes[@"href"];
        if (linkURL == nil || linkURL.length == 0) return;
        NSString *absoluteLinkURL = [NSString token_completeRelativeURLString:linkURL
                                                        withAbsoluteURLString:_document.sourceURL];
        HybridLog(@"开始下载CSS文件");
        TokenNetworking.networking()
        .sendRequest(^NSURLRequest *(TokenNetworking *netWorking) {
            return NSMutableURLRequest.token_requestWithURL(absoluteLinkURL)
                                      .token_setPolicy(NSURLRequestReloadIgnoringLocalCacheData);
        })
        .transform(^id(TokenNetworking *netWorking, id responsedObj) {
            HybridLog(@"CSS文件下载完成");
            NSString     *cssText = [netWorking HTMLTextSerializeWithData:responsedObj];
            CGFloat      width    = self.bodyViewFrame.size.width;
            CGFloat      height   = self.bodyViewFrame.size.height;
            NSDictionary *rules   = [TokenCSSParser parserCSSWithString:cssText
                                                     containerViewWidth:width
                                                    containerViewHeight:height];
            if (rules.allKeys.count) {
                [_document addCSSRuels:rules];
            }
            self.styleAndLinkNodeCount -= 1;
            return cssText;
        }).finish(nil, ^(TokenNetworking *netWorkingObj, NSError *error) {
            self.styleAndLinkNodeCount -= 1;
            HybridLog(@"CSS文件下载错误： %@",error);
            [_document addFailedCSSURL:absoluteLinkURL];
        });
    }];
}

-(void)handleStyleNodes:(NSArray <TokenXMLNode *>*)nodes{
    [nodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat      width   = self.bodyViewFrame.size.width;
        CGFloat      height  = self.bodyViewFrame.size.height;
        NSDictionary *rules = [TokenCSSParser parserCSSWithString:obj.innerText
                                               containerViewWidth:width
                                              containerViewHeight:height];
        if (rules.allKeys.count) {
            [_document addCSSRuels:rules];
        }
        self.styleAndLinkNodeCount -= 1;
    }];
}

-(void)handleScriptNodes:(NSArray <TokenXMLNode *>*)nodes{
    [nodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *scriptURL = obj.innerAttributes[@"src"];
        if (scriptURL && scriptURL.length) { //存在远程脚本
            NSString *absoluteURL = [NSString token_completeRelativeURLString:scriptURL
                                                        withAbsoluteURLString:_document.sourceURL];
            HybridLog(@"开始下载JS文件");
            TokenNetworking.networking()
            .sendRequest(^NSURLRequest *(TokenNetworking *netWorking) {
                return NSMutableURLRequest.token_requestWithURL(absoluteURL)
                                          .token_setPolicy(NSURLRequestReloadIgnoringLocalCacheData);
            })
            .transform(^id(TokenNetworking *netWorking, id responsedObj) {
                HybridLog(@"JS文件下载完成");
                NSString *js = [netWorking HTMLTextSerializeWithData:responsedObj];
                if (js && js.length) {
                    [_document addJavaScript:js];
                }
                self.scriptNodeCount -= 1;
                [self checkNodeCount];
                return js;
            })
            .finish(nil, ^(TokenNetworking *netWorkingObj, NSError *error) {
                self.scriptNodeCount -= 1;
                [self checkNodeCount];
                HybridLog(@"javaScript脚本下载错误 %@",error);
                [_document addFailedScriptURL:absoluteURL];
            });
        }
        else {
            if (obj.innerText && obj.innerText.length) {
                [_document addJavaScript:obj.innerText];
            }
            self.scriptNodeCount -= 1;
            [self checkNodeCount];
        }
    }];
}

#pragma mark -
-(void)checkNodeCount{
    if (self.styleAndLinkNodeCount == 0) {
        [self startApplyCSSToView];
    }
    if (self.scriptNodeCount == 0) {
        [self startRunScript];
    }
}

#pragma mark -

-(void)startApplyCSSToView{
    if (self.styleAndLinkNodeCount || _parserEnd == NO) {
        return;
    }
    dispatch_async(kTokenCSSProcessQueue, ^{
        TokenXMLNode *bodyNode = _document.bodyNode;
        //一个<style>里面的所有 称之为ruleStore
        
        NSMutableSet <TokenXMLNode *>*nodeSet = [NSMutableSet set];
        [_document.cssRules enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull ruleStore, NSUInteger idx, BOOL * _Nonnull stop) {
            //遍历每一个CSS选择器
            for (NSString *selector in ruleStore.allKeys) {
                //匹配选择器对应的node
                NSSet <TokenXMLNode *> *nodes = [TokenCSSParser matchNodesWithRootNode:bodyNode selector:selector];
                //将style应用到node
                for (TokenXMLNode *node in nodes) {
                    NSDictionary *styleAttributes = ruleStore[selector];
                    [node addCSSAttributesFromDictionary:styleAttributes];
                    [nodeSet addObject:node];
                }
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (nodeSet.count) {
                __block NSInteger nodeIndex = -1;
                [nodeSet enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull node, BOOL * _Nonnull stop) {
                    nodeIndex += 1;
                    [node.associatedView token_updateAppearanceWithCSSAttributes:node.cssAttributes];
                    [node.associatedView token_updateAppearanceWithCSSAttributes:node.innerStyleAttributes];
                    [node.associatedView token_updateAppearanceWithNormalDictionary:node.innerAttributes];
                    if (nodeIndex == nodeSet.count - 1) {
                        [self applyInnerCSSStyles];
                        [self CSSApplyFinish];
                    }
                }];
            }
            else {
                [self applyInnerCSSStyles];
                [self CSSApplyFinish];
            }
        });
    });
}

-(void)applyInnerCSSStyles{
    [_nodeContainInnerCSSStyleSet enumerateObjectsUsingBlock:^(TokenXMLNode *  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj.associatedView token_updateAppearanceWithCSSAttributes:obj.innerStyleAttributes];
        //保证优先级
        if (obj.innerAttributes.count) {
            [obj.associatedView token_updateAppearanceWithNormalDictionary:obj.innerAttributes];
        }
    }];
    _nodeContainInnerCSSStyleSet = nil;
}

-(void)CSSApplyFinish{
    [_bodyView token_updateAppearanceWithCSSAttributes:self.document.bodyNode.cssAttributes shouldLayout:YES];
    [_bodyView token_updateAppearanceWithCSSAttributes:self.document.bodyNode.innerStyleAttributes shouldLayout:YES];
    [_bodyView token_updateAppearanceWithNormalDictionary:self.document.bodyNode.innerAttributes];
    [_bodyView applyFlexLayout];
    if ([self.delegate respondsToSelector:@selector(viewBuilder:didCreatBodyView:)]) {
        [self.delegate viewBuilder:self didCreatBodyView:self.bodyView];
    }
    [self execuseSaveAction];
}

-(void)startRunScript{
    if (self.scriptNodeCount !=0 || _parserEnd == NO) {
        return;
    }
    self.jsContext[@"document"] = self.document;
    self.document.jsContext     = self.jsContext;
    
    dispatch_main_async_safe(^{
        if ([self.delegate respondsToSelector:@selector(viewBuilderWillRunScript)]) {
            [self.delegate viewBuilderWillRunScript];
        }
        if (_pageRefreshed) {
            [self.jsContext pageRefresh];
        }
        
        [_document.scripts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_jsContext evaluateScript:obj];
        }];
        [self execuseSaveAction];
    });
}

-(void)execuseSaveAction{
    if (self.document.sourceURL == nil) {
        return ;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData   *data     = [NSKeyedArchiver archivedDataWithRootObject:self.document];
        NSString *cacheKey = NSString.token_md5(self.document.sourceURL);
        [self.currentPageDefaults setObject:data forKey:cacheKey];
        [self.currentPageDefaults synchronize];
    });
}

#pragma mark -
-(void)releaseObj{
    _viewStack = nil;
    _xmlParser = nil;
}

-(void)dealloc{
    _jsContext[@"document"] = nil;
    _jsContext = nil;
    HybridLog(@"TokenViewBuilder dead");
}

@end
