//
//  TokenJSContext.h
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/24.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@class TokenXMLNode,TokenEvent,TokenJSContext,TokenAssociateContext;
@import UIKit;
@protocol TokenJSContextDelegate<NSObject>
@optional
-(void)context:(TokenJSContext *)context didReceiveLogInfo:(NSString *)info;
-(void)context:(TokenJSContext *)context setPriviousExtension:(NSDictionary *)extension;
-(TokenAssociateContext *)contextGetAssociateContext;
@end

@interface TokenJSContext : JSContext
@property(nonatomic ,weak) id <TokenJSContextDelegate> delegate;
-(UIViewController *)getContainerController;
-(NSUserDefaults *)getCurrentPageUserDefaults;
-(Class)getViewPushedControllerClass;
-(void)keepEventValueAlive:(JSValue *)value;
-(void)pageShow;
-(void)pageClose;
-(void)pageRefresh;
@end
