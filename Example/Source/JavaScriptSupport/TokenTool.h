//
//  Token.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/18.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@import JavaScriptCore;
@import UIKit;
@class TokenJSContext;
@protocol TokenAPIExport <JSExport>
@optional
//storage
JSExportAs(request, -(void)requestWithValue:(JSValue *)requestValue);
JSExportAs(getLocation, -(void)getLocation:(JSValue *)callBack);
-(id)getStorage:(JSValue *)key;
-(void)setStorage:(JSValue *)dicValue;
-(void)clearAllStorage;
-(void)setGlobleStorage:(JSValue *)dicValue;
-(id)getGlobleStorage:(JSValue *)key;
-(void)clearGlobleStorage;
-(void)makePhoneCall:(NSString *)number;
//
JSExportAs(log, -(void)log:(NSString *)msg);
//imageValue {"url","success","failure"}
JSExportAs(saveImage, -(void)saveImageWithJSValue:(JSValue *)imageValue);
JSExportAs(alert, -(void)alertWithTitle:(NSString *)title msg:(NSString *)msg);
JSExportAs(alertTitles, -(void)alertWithWithJSValue:(JSValue *)alertValue);
JSExportAs(alertInput, -(void)alertInput:(JSValue *)alertValue);
JSExportAs(showSheetView, -(void)showSheetViewWithJSValue:(JSValue *)sheetValue);
JSExportAs(pickData, -(void)pickData:(JSValue *)pickValue);
//(code ,desc)
JSExportAs(requestTouchID, -(void)requestTouchIDWithTitle:(JSValue *)title callBack:(JSValue *)callBack);
JSExportAs(setMainTimeOut, -(void)setMainTimeOutWithCallBack:(JSValue *)callBack interval:(JSValue *)interval);
JSExportAs(setTimeOut, -(void)setTimeOutWithCallBack:(JSValue *)callBack interval:(JSValue *)interval);
-(NSNumber *)screenWidth;
-(NSNumber *)screenHeight;

JSExportAs(showToastWithText, - (void)showToastWithText:(NSString *)textString duration:(JSValue *)duration);
JSExportAs(getNetworkType, - (void)getNetworkType:(JSValue *)callBack);
JSExportAs(getSystemInfo, - (void)getSystemInfo:(JSValue *)callBack);
JSExportAs(setClipboardData, - (void)setClipboardData:(NSString *)string callBack:(JSValue *)callBack);
JSExportAs(getClipboardData, - (void)getClipboardData:(JSValue *)callBack);
JSExportAs(vibrate, - (void)vibrate:(JSValue *)callBack);
@end

@interface TokenTool : NSObject <TokenAPIExport>
@property(nonatomic ,strong) NSUserDefaults *globleDefaultes;
@property(nonatomic ,weak  ) TokenJSContext *jsContext;
@end
