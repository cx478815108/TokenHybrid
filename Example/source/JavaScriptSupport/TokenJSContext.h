//
//  TokenJSContext.h
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/24.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <JavaScriptCore/JavaScriptCore.h>

@class TokenXMLNode,TokenEvent,TokenJSContext;

@protocol TokenJSContextDelegate<NSObject>
@optional
-(void)context:(TokenJSContext *)context didReceiveLogInfo:(NSString *)info;
-(void)context:(TokenJSContext *)context setPriviousExtension:(NSDictionary *)extension;

@end

@interface TokenJSContext : JSContext
@property(nonatomic ,weak) id <TokenJSContextDelegate> delegate;
-(void)keepEventValueAlive:(JSValue *)value;
-(void)pageShow;
-(void)pageClose;
-(void)pageRefresh;
@end
