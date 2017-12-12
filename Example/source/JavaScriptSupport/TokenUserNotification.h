//
//  TokenUserNotification.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/12/7.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@import JavaScriptCore;
@import UIKit;
@protocol TokenUserNotificationExport <JSExport>
@optional
JSExportAs(addNotification, -(void)addNotification:(JSValue *)value);
-(void)removeAllPendingNotification;
-(void)removePendingNotifications:(JSValue *)values;
-(void)requestNotificationAuthorization;

@end
@interface TokenUserNotification : NSObject<TokenUserNotificationExport>

@end
