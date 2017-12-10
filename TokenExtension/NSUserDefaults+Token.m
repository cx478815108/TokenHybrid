//
//  NSUserDefaults+Token.m
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/25.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSUserDefaults+Token.h"

@implementation NSUserDefaults (Token)

+(TokenUserDefaultsInitBlock)token_initWithSuiteName{
    return ^NSUserDefaults *(NSString *suiteName) {
        return [[NSUserDefaults alloc] initWithSuiteName:suiteName];
    };
}

-(TokenUserDefaultsSetObjectBlock)token_setObjectForKey{
    return  ^NSUserDefaults *(NSString *key, id object) {
        if (object == nil) { return self;}
        if (object) { [self setObject:object forKey:key];}
        return self;
    };
}

-(TokenUserDefaultsSetLimitTimeTypeObjectBlock)token_setTimeLimitTypeObjectForKey{
    return ^NSUserDefaults *(NSString *key, id object, NSTimeInterval limitTime) {
        if (object == nil) { return self;}
        NSDictionary *dic = @{
                              @"obj":object,
                              @"time":@([[NSDate date] timeIntervalSince1970]),
                              @"limitTime":@(limitTime)
                              };
        id data = [NSKeyedArchiver archivedDataWithRootObject:dic];
        if (data) { [self setObject:data forKey:key];}
        return self;
    };
}

-(TokenUserDefaultsGetObjectBlock)token_objectForKey {
    return ^id(id JSValueKey) {
        NSString *key = [NSString stringWithFormat:@"%@", JSValueKey];
        id obj = [self objectForKey:key];
        if (![obj isKindOfClass:[NSNull class]] && obj != nil) {
            return obj;
        }else {
            return @"";
        }
    };
}

-(TokenUserDefaultsGetObjectBlock)token_timeLimitTypeObjectForKey{
    return  ^id(NSString *key) {
        NSData *data = [self objectForKey:key];
        if (data == nil || ![data isKindOfClass:[NSData class]]) return nil;
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (![dic isKindOfClass:[NSDictionary class]]) return nil;
        
        NSTimeInterval limit = [dic[@"limitTime"] doubleValue];
        NSTimeInterval old   = [dic[@"time"] doubleValue];
        NSTimeInterval now   = [[NSDate date] timeIntervalSince1970];
        if ((now - old) <= limit) {
            return dic[@"obj"];
        }
        [self removeObjectForKey:key];
        return nil;
    };
}

-(TokenUserDefaultsRemoveBlock)token_removePersistentDomainForName{
    return ^NSUserDefaults *(NSString *domainName) {
        [self removePersistentDomainForName:domainName];
        return self;
    };
}

@end
