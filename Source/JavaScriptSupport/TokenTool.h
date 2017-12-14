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
JSExportAs(dispatchMainAfter, -(void)dospatchMainAfter:(JSValue *)numberValue callBack:(JSValue *)callBack);
JSExportAs(dispatchGlobleAfter, -(void)dospatchGlobleAfter:(JSValue *)numberValue callBack:(JSValue *)callBack);
JSExportAs(alert, -(void)alertWithTitle:(NSString *)title msg:(NSString *)msg);
JSExportAs(alertTitles, -(void)alertWithWithJSValue:(JSValue *)alertValue);
JSExportAs(alertInput, -(void)alertInput:(JSValue *)alertValue);
JSExportAs(showSheetView, -(void)showSheetViewWithJSValue:(JSValue *)sheetValue);
JSExportAs(pickData, -(void)pickData:(JSValue *)pickValue);
//(code ,desc)
JSExportAs(requestTouchID, -(void)requestTouchIDWithTitle:(JSValue *)title callBack:(JSValue *)callBack);

-(NSNumber *)screenWidth;
-(NSNumber *)screenHeight;
@end

@interface TokenTool : NSObject <TokenAPIExport>
@property(nonatomic ,strong) NSUserDefaults *globleDefaultes;
@property(nonatomic ,strong) NSUserDefaults *currentPageDefaultes;
@end
