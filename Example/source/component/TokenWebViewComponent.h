//
//  TokenWebViewComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/5.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;
@class TokenWebViewNode;
@interface TokenWebViewComponent : UIView
@property(nonatomic ,weak  ) TokenWebViewNode *associatedNode;
@property(nonatomic ,strong) WKWebView        *webView;
-(void)loadURL:(NSString *)url;
-(void)goBack;
-(void)goForward;
-(void)reload;
-(void)stopLoading;
-(void)setUA:(NSString *)UA;
@end
