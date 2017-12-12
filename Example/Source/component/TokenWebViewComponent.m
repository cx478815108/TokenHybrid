//
//  TokenWebViewComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/5.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenWebViewComponent.h"
#import "UIView+Attributes.h"
#import "TokenXMLNode.h"
#import "TokenHybridOrganizer.h"
#import "TokenHybridConstant.h"
#import <WebKit/WebKit.h>

@interface TokenWebViewComponent()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>
@end

@implementation TokenWebViewComponent
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(releaseWebView)
                                                     name:TokenHybridPageDisappearNotification
                                                   object:nil];
    }
    return self;
}

-(void)releaseWebView{
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"token"];
    _webView = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)loadURL:(NSString *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
}

-(void)goBack{
    [self.webView goBack];
}

-(void)goForward{
    [self.webView goForward];
}

-(void)reload{
    [self.webView reload];
}

-(void)stopLoading{
    [self.webView stopLoading];
}

-(void)setUA:(NSString *)UA{
    self.webView.customUserAgent = UA;
}

-(void)layoutSubviews{
    self.webView.frame                      = self.bounds;
    self.webView.backgroundColor            = self.backgroundColor;
    self.webView.scrollView.backgroundColor = self.backgroundColor;
}

#pragma mark - WKScriptMessageHandler
-(void)userContentController:(WKUserContentController *)userContentController
     didReceiveScriptMessage:(WKScriptMessage *)message{
    NSMutableDictionary *args = @{}.mutableCopy;
    if (message.name) {
        [args setObject:message.name forKey:@"name"];
    }
    if (message.body) {
        [args setObject:message.body forKey:@"body"];
    }
    if (self.associatedNode.onReceiveJSMessage) {
        [self.associatedNode.onReceiveJSMessage.value callWithArguments:@[message]];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *url = navigationAction.request.URL;
    NSString *scheme = [url scheme];
    if ([scheme isEqualToString:@"tel"] || [url.absoluteString containsString:@"ituns.apple.com"]) {
        if (@available(iOS 10, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
        else {
            [[UIApplication sharedApplication] openURL:url];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.associatedNode.onStartLoad) {
        [self.associatedNode.onStartLoad.value callWithArguments:nil];
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.associatedNode.onReceiveContent) {
        [self.associatedNode.onReceiveContent.value callWithArguments:nil];
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    if (self.associatedNode.onFinish) {
        [self.associatedNode.onFinish.value callWithArguments:nil];
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    if (self.associatedNode.onFailLoad) {
        [self.associatedNode.onFailLoad.value callWithArguments:nil];
    }
}

#pragma WKUIDelegate

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    
    UIViewController *controller = (UIViewController *)[TokenHybridOrganizer sharedOrganizer].currentViewController;
    [controller presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }])];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }])];
    UIViewController *controller = (UIViewController *)[TokenHybridOrganizer sharedOrganizer].currentViewController;
    [controller presentViewController:alertController animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = defaultText;
    }];
    
    __weak UIAlertController *weakController = alertController;
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        __weak typeof(weakController) strongController = weakController;
        completionHandler(strongController.textFields[0].text?:@"");
    }])];
    
    UIViewController *controller = (UIViewController *)[TokenHybridOrganizer sharedOrganizer].currentViewController;
    [controller presentViewController:alertController animated:YES completion:nil];
}

-(WKWebView *)webView{
    if (_webView == nil) {
        WKWebViewConfiguration *config               = [[WKWebViewConfiguration alloc] init];
        _webView                                     = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.navigationDelegate                  = self;
        _webView.UIDelegate                          = self;
        _webView.allowsBackForwardNavigationGestures = YES;
        [self addSubview:_webView];
        _webView.backgroundColor            = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        [_webView.configuration.userContentController addScriptMessageHandler:self name:@"token"];
        [_webView evaluateJavaScript:@"var token = window.webkit.messageHandlers.token" completionHandler:nil];
        if (@available(iOS 11, *)) {
            _webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _webView;
}
@end
