//
//  TokenUserNotification.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/12/7.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenUserNotification.h"
#import "JSValue+Token.h"
#import <UserNotifications/UserNotifications.h>

@implementation TokenUserNotification

-(void)requestNotificationAuthorization{
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (error == nil) {
            }
        }];
    }
}

-(void)addNotification:(JSValue *)value{
    if ([value token_isNilObject]) {
        return ;
    }
    if (@available(iOS 10.0, *)) {
        NSString *type         = [value[@"type"] toString];
        NSString *identifier   = [value[@"identifier"] toString];
        NSString *title        = [value[@"title"] toString];
        NSString *subtitle     = [value[@"subtitle"] toString];
        NSString *body         = [value[@"body"] toString];
        JSValue  *repeat       = value[@"repeat"];
        JSValue  *triggerValue = value[@"triggerValue"];
        NSString *repeatMode   = [triggerValue[@"repeatMode"] toString];
        
        UNNotificationTrigger *trigger;
        if (identifier == nil) { return;}
        if ([type isEqualToString:@"timeInterval"]) {
            NSNumber *time = [value[@"time"] toNumber];
            if (time == nil) return ;
            trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:[time floatValue] repeats:[repeat toBool]];
        }
        else if ([type isEqualToString:@"date"]) {
            NSDateComponents *components;
            NSDate *date     = [triggerValue[@"date"] toDate];
            if (![date isKindOfClass:[NSDate class]]) {
                return;
            }
            if (repeatMode) {
                if (date == nil || ![date isKindOfClass:[NSDate class]]) { return; }
                NSCalendar *calendar   = [NSCalendar currentCalendar];
                calendar.locale        = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
                NSInteger unitFlags;
                if ([repeatMode isEqualToString:@"year"]) {
                    unitFlags = NSCalendarUnitYear;
                }
                else if([repeatMode isEqualToString:@"month"]) {
                    unitFlags = NSCalendarUnitMonth;
                }
                else if([repeatMode isEqualToString:@"day"]) {
                    unitFlags = NSCalendarUnitDay;
                }
                else if([repeatMode isEqualToString:@"hour"]) {
                    unitFlags = NSCalendarUnitHour;
                }
                else if([repeatMode isEqualToString:@"weekDay"]) {
                    unitFlags = NSCalendarUnitWeekday;
                }
                else if([repeatMode isEqualToString:@"weekdayOrdinal"]) {
                    unitFlags = NSCalendarUnitWeekdayOrdinal;
                }
                else {
                    unitFlags = 0;
                }
                components = [calendar components:unitFlags fromDate:date];
            }
            else {
                components = [[NSDateComponents alloc] init];
                NSNumber *year              = [triggerValue[@"day"] toNumber];
                NSNumber *month             = [triggerValue[@"month"] toNumber];
                NSNumber *day               = [triggerValue[@"day"] toNumber];
                NSNumber *hour              = [triggerValue[@"hour"] toNumber];
                NSNumber *minute            = [triggerValue[@"minute"] toNumber];
                NSNumber *second            = [triggerValue[@"second"] toNumber];
                NSNumber *weekday           = [triggerValue[@"weekday"] toNumber];
                NSNumber *weekdayOrdinal    = [triggerValue[@"weekdayOrdinal"] toNumber];
                NSNumber *quarter           = [triggerValue[@"quarter"] toNumber];
                NSNumber *weekOfMonth       = [triggerValue[@"weekOfMonth"] toNumber];
                NSNumber *weekOfYear        = [triggerValue[@"weekOfYear"] toNumber];
                NSNumber *yearForWeekOfYear = [triggerValue[@"yearForWeekOfYear"] toNumber];
                if (year)               { components.year              = [year integerValue];}
                if (month)              { components.month             = [month integerValue];}
                if (day)                { components.day               = [day integerValue];}
                if (hour)               { components.hour              = [hour integerValue];}
                if (minute)             { components.minute            = [minute integerValue];}
                if (second)             { components.second            = [second integerValue];}
                if (weekday)            { components.weekday           = [weekday integerValue];}
                if (quarter)            { components.quarter           = [quarter integerValue];}
                if (weekdayOrdinal)     { components.weekdayOrdinal    = [weekdayOrdinal integerValue];}
                if (weekOfMonth)        { components.weekOfMonth       = [weekOfMonth integerValue];}
                if (weekOfYear)         { components.weekOfYear        = [weekOfYear integerValue];}
                if (yearForWeekOfYear)  { components.yearForWeekOfYear = [yearForWeekOfYear integerValue];}
            }
            
            trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:[repeat toBool]];
            return;
        }
        
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (title)    { content.title = title;}
        if (subtitle) { content.subtitle= subtitle;}
        if (body)     { content.body= body;}
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:identifier content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"%@",error);
            }
        }];
    }
}

-(void)removeAllPendingNotification{
    if (@available(iOS 10.0, *)) {
        [[UNUserNotificationCenter currentNotificationCenter] removeAllPendingNotificationRequests];
    }
}

-(void)removePendingNotifications:(JSValue *)values{
    if (@available(iOS 10.0, *)) {
        NSArray *ids = [values toArray];
        if (ids == nil || ![ids isKindOfClass:[NSArray class]]) {
            return;
        }
        [[UNUserNotificationCenter currentNotificationCenter] removePendingNotificationRequestsWithIdentifiers:ids];
    }
}



@end
