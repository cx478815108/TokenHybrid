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
    BOOL              _pageRefresh;
    BOOL              _existCache;
    NSSet            *_nodeContainInnerCSSStyleSet;
}

+(void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kTokenCSSProcessQueue = dispatch_queue_create("com.tokenCSSProcess.queue", DISPATCH_QUEUE_SERIAL);
    });
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.document  = [[TokenDocument alloc] init];
        self.jsContext = [[TokenJSContext alloc] init];
        self.useCache  = YES;
    }
    return self;
}

-(void)buildViewWithSourceURL:(NSString *)url{
    HybridLog(@"buildViewWithSourceURL");
    if (url==nil || url.length == 0) {
        return;
    }
    
//    self.useCache = NO;
    _existCache = NO;
    self.document.sourceURL    = url;
    NSString *cacheKey         = NSString.token_md5(url);
    [[TokenHybridOrganizer sharedOrganizer] addPageDefaultWithSuiteName:cacheKey];
    if (self.useCache) {
        self.currentPageDefaults   = NSUserDefaults.token_initWithSuiteName(cacheKey);
        NSData *documentCachedData = [self.currentPageDefaults objectForKey:cacheKey];
        
        if (documentCachedData) {
            _existCache = YES;
            self.document = [NSKeyedUnarchiver unarchiveObjectWithData:documentCachedData];
            [self recoverFromDocument:self.document];
        }
    }
}
-(void)refreshView{
    [self refreshViewExistCache:_existCache];
}

-(void)refreshViewExistCache:(BOOL)existCache{
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
        if (responsedObj == nil || responsedObj.length == 0) return ;
        if (!self.useCache) {
            [self buildViewWithHTML:responsedObj];
            return ;
        }
        
        NSString *html = responsedObj;
        NSString *newFinger = NSString.token_md5(html);
        NSString *oldFinger;
        if (self.document.html) {
            oldFinger = NSString.token_md5(self.document.html);
        }
        if (oldFinger == nil || ![oldFinger isEqualToString:newFinger]) {
            HybridLog(@"缓存不存在或者指纹不一样，开始解析HTML");
            if (existCache) {
                _pageRefresh = YES;
            }
            [self buildViewWithHTML:responsedObj];
        }
        else {
            HybridLog(@"指纹一样，从缓存恢复");
        }
    }, ^(TokenNetworking *netWorkingObj, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(parserErrorOccurred:)]) {
            [self.delegate viewBuilder:self parserErrorOccurred:error];
        }
        HybridLog(@"网页加载错误");
    });
}

-(void)buildViewWithHTML:(NSString *)html{
    HybridLog(@"buildViewWithHTML");
    if (html == nil || html.length == 0) {
        return;
    }
    self.document.html     = html;
    TokenXMLParser *parser = [[TokenXMLParser alloc] init];
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
    _bodyView = [self recoverViewFromNode:document.bodyNode];
    [_bodyView didApplyAllAttributs];
    if ([self.delegate respondsToSelector:@selector(viewBuilder:didCreatBodyView:)]) {
        [self.delegate viewBuilder:self didCreatBodyView:_bodyView];
    }

    self.jsContext[@"document"] = self.document;
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
    
    [view token_updateAppearanceWithCSSAttributes:node.cssAttributes shouldLayout:NO];
    [view token_updateAppearanceWithCSSAttributes:node.innerStyleAttributes shouldLayout:NO];
    [view token_updateAppearanceWithNormalDictionary:node.innerAttributes];
    if (node.cachedFrame) {
        view.frame = CGRectFromString(node.cachedFrame);
    }
    [node.childNodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subview = [self recoverViewFromNode:obj];
        [view addSubview:subview];
    }];
    return view;
}

#pragma mark - TokenXMLParserDelegate
-(void)parserDidStart{
    HybridLog(@"parserDidStart");
    _viewStack = [[TokenHybridStack alloc] init];
    if (_jsContext) {
        _jsContext[@"document"] = nil;
        _jsContext = [[TokenJSContext alloc] init];
    }
}

-(void)parser:(TokenXMLParser *)parser didStartNodeWithinBodyNode:(TokenXMLNode *)node{
    TokenPureComponent *view = [UIView token_produceViewWithNode:node];
    if (view == nil) {
        view = [[TokenPureComponent alloc] init];
    }
    view.associatedNode = node;
    node.associatedView = view;
    [_viewStack push:view];
    
    if ([node.name isEqualToString:@"body"]) {
        _bodyView = view;
    }
}

-(void)parser:(TokenXMLParser *)parser didEndNodeWithinBodyNode:(TokenXMLNode *)node{
    //在End调整UIView层次结构
    UIView *currentView = [_viewStack pop];
    UIView *parentView  = [_viewStack top];
    [parentView addSubview:currentView];
}

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

-(void)parser:(TokenXMLParser *)parser didCreatHeadNode:(TokenXMLNode *)node{    
    dispatch_async(kTokenCSSProcessQueue, ^{
        self.document.scripts = @[];
        self.document.cssRules = @[];
        NSArray <TokenXMLNode *>* linkNodes    = [node getElementsByTagName:@"link"];
        NSArray <TokenXMLNode *>* styleNodes   = [node getElementsByTagName:@"style"];
        NSArray <TokenXMLNode *>* scriptsNodes = [node getElementsByTagName:@"script"];
        self.styleAndLinkNodeCount             = linkNodes.count + styleNodes.count;
        self.scriptNodeCount                   = scriptsNodes.count;
        [self addObserver:self forKeyPath:@"styleAndLinkNodeCount" options:(NSKeyValueObservingOptionNew) context:nil];
        [self addObserver:self forKeyPath:@"scriptNodeCount" options:(NSKeyValueObservingOptionNew) context:nil];
        [self handleLinkNodes:linkNodes];
        [self handleStyleNodes:styleNodes];
        [self handleScriptNodes:scriptsNodes];
    });
}

-(void)parser:(TokenXMLParser *)parser didCreatRootNode:(TokenXMLNode *)node{
    _document.rootNode = node;
}

-(void)parser:(TokenXMLParser *)parser nodeContainInnerCSSStyle:(NSSet *)nodes{
    _nodeContainInnerCSSStyleSet = nodes;
}

-(void)parserErrorOccurred:(NSError *)error{
    HybridLog(@"parserErrorOccurred %@",error);
    if ([self.delegate respondsToSelector:@selector(viewBuilder:parserErrorOccurred:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate viewBuilder:self parserErrorOccurred:error];
        });
    }
    _document = nil;
    _jsContext = nil;
    [self releaseObj];
}

-(void)parserDidEnd{
    HybridLog(@"parserDidEnd");
    _parserEnd = YES;
    [self startApplyCSSToView];
    [self startRunScript];
    [self releaseObj];
}

#pragma mark - handle
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
        }).transform(^id(TokenNetworking *netWorking, id responsedObj) {
            HybridLog(@"CSS文件下载完成");
            NSString     *cssText = [netWorking HTMLTextSerializeWithData:responsedObj];
            NSDictionary *rules   = [TokenCSSParser parserCSSWithString:cssText];
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
        NSDictionary *rules = [TokenCSSParser parserCSSWithString:obj.innerText];
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
                return js;
            })
            .finish(nil, ^(TokenNetworking *netWorkingObj, NSError *error) {
                self.scriptNodeCount -= 1;
                HybridLog(@"javaScript脚本下载错误 %@",error);
                [_document addFailedScriptURL:absoluteURL];
            });
        }
        else {
            if (obj.innerText && obj.innerText.length) {
                [_document addJavaScript:obj.innerText];
            }
            self.scriptNodeCount -= 1;
        }
    }];
}

#pragma mark - kvo
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"styleAndLinkNodeCount"]) {
        if (self.styleAndLinkNodeCount == 0) {
            [self startApplyCSSToView];
            [self removeObserver:self forKeyPath:@"styleAndLinkNodeCount"];
        }
    }
    else if ([keyPath isEqualToString:@"scriptNodeCount"]) {
        if (self.scriptNodeCount == 0) {
            [self startRunScript];
            [self removeObserver:self forKeyPath:@"scriptNodeCount"];
        }
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
    [_bodyView token_updateAppearanceWithCSSAttributes:_document.bodyNode.cssAttributes];
    [_bodyView applyFlexLayout];
    if ([self.delegate respondsToSelector:@selector(viewBuilder:didCreatBodyView:)]) {
        [self.delegate viewBuilder:self didCreatBodyView:self.bodyView];
    }
    [self execuseSaveAction];
}

-(void)startRunScript{
    if (self.scriptNodeCount || _parserEnd == NO) {
        return;
    }
    self.jsContext[@"document"] = self.document;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(viewBuilderWillRunScript)]) {
            [self.delegate viewBuilderWillRunScript];
        }
        if (_pageRefresh) {
            [self.jsContext pageRefresh];
        }
        
        [_document.scripts enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_jsContext evaluateScript:obj];
        }];
        [self execuseSaveAction];
    });
}

-(void)execuseSaveAction{
    //缓存坐标信息
    if (self.document.sourceURL == nil) {
        return ;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [TokenXMLNode enumerateTreeFromRootToChildWithNode:self.document.bodyNode block:^(TokenXMLNode *node, BOOL *stop) {
            UIView *view         = node.associatedView;
            if (view) {
                NSValue  *frameValue   = [view valueForKeyPath:@"frame"];
                NSString *frameString  = NSStringFromCGRect([frameValue CGRectValue]);
                node.cachedFrame = frameString;
            }
        }];
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.document];
        NSString *cacheKey         = NSString.token_md5(self.document.sourceURL);
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
