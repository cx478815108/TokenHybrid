//
//  NSUserDefaults+Token.h
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/25.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSUserDefaults *(^TokenUserDefaultsInitBlock)(NSString *suiteName);
typedef NSUserDefaults *(^TokenUserDefaultsRemoveBlock)(NSString *domainName);
typedef NSUserDefaults *(^TokenUserDefaultsSetObjectBlock)(NSString *key,id object);
typedef NSUserDefaults *(^TokenUserDefaultsSetLimitTimeTypeObjectBlock)(NSString *key,id object,NSTimeInterval limitTime);
typedef id (^TokenUserDefaultsGetObjectBlock)(NSString *key);
typedef id (^TokenUserDefaultsGetTimeLimitTypeObjectBlock)(NSString *key);

@interface NSUserDefaults (Token)
@property(nonatomic ,copy,class,readonly) TokenUserDefaultsInitBlock token_initWithSuiteName;
@property(nonatomic ,copy,readonly) TokenUserDefaultsSetObjectBlock  token_setObjectForKey;
@property(nonatomic ,copy,readonly) TokenUserDefaultsRemoveBlock     token_removePersistentDomainForName;
@property(nonatomic ,copy,readonly) TokenUserDefaultsGetObjectBlock  token_objectForKey;
@property(nonatomic ,copy,readonly) TokenUserDefaultsSetLimitTimeTypeObjectBlock token_setTimeLimitTypeObjectForKey;
@property(nonatomic ,copy,readonly) TokenUserDefaultsGetObjectBlock  token_timeLimitTypeObjectForKey;
@end
