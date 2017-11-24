//
//  NSMutableURLRequest+TokenNetworking.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/11.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSObject *(^NSDictionaryUnpackBlock)(NSString *key);
@interface NSObject(TokenNetworking)
@property(nonatomic ,copy ,readonly) NSDictionaryUnpackBlock token_dicUnpackValue;
@end

@interface NSDictionary (TokenNetworking)
+(NSString *)token_dictionaryToJSONString:(NSDictionary *)dic;
@end

typedef NSMutableURLRequest *(^NSURLRequestInstanceBlock)(NSString *url);
typedef NSMutableURLRequest *(^NSURLRequestPolicySetBlock)(NSURLRequestCachePolicy policy);
typedef NSMutableURLRequest *(^NSURLRequestTimeoutBlock)(NSTimeInterval timeout);
typedef NSMutableURLRequest *(^NSURLRequestStringSetBlock)(NSString *value);
typedef NSMutableURLRequest *(^NSURLRequestBOOLSetBlock)(BOOL value);
typedef NSMutableURLRequest *(^NSURLRequestDictionarySetBlock)(NSDictionary *dic);
typedef NSMutableURLRequest *(^NSURLRequestJSONSetBlock)(NSDictionary *dic,NSError *error);
typedef NSString *(^TokenNetworkingPostHTTPParameterBlock)(NSDictionary *parameter);

@interface NSMutableURLRequest (TokenNetworking)
@property(nonatomic ,copy,readonly ,class) TokenNetworkingPostHTTPParameterBlock token_paramterTransformToString;
@property(nonatomic ,copy,readonly ,class) NSURLRequestInstanceBlock      token_requestWithURL;
@property(nonatomic ,copy,readonly)        NSURLRequestStringSetBlock     token_setUA;
@property(nonatomic ,copy,readonly)        NSURLRequestPolicySetBlock     token_setPolicy;
@property(nonatomic ,copy,readonly)        NSURLRequestTimeoutBlock       token_setTimeout;
@property(nonatomic ,copy,readonly)        NSURLRequestStringSetBlock     token_setMethod;
@property(nonatomic ,copy,readonly)        NSURLRequestBOOLSetBlock       token_handleCookie;
@property(nonatomic ,copy,readonly)        NSURLRequestDictionarySetBlock token_addHeaderValues;
@property(nonatomic ,copy,readonly)        NSURLRequestDictionarySetBlock token_setHTTPParameter;
@property(nonatomic ,copy,readonly)        NSURLRequestJSONSetBlock       token_setJSONParameter;
+(NSMutableURLRequest *)token_requestWithURLString:(NSString *)string;
@end

typedef NSError *(^TokenNetworkingErrorInstacnceBlock)(NSInteger code ,NSString *errorDescription);
@interface NSError (TokenNetworking)
@property(nonatomic ,copy ,readonly ,class) TokenNetworkingErrorInstacnceBlock token_errorWithInfo;
+(NSError *)token_errorWithCode:(NSInteger)code
                    description:(NSString *)description;
+(NSError *)token_netError;
@end

typedef NSUserDefaults *(^UserDefaultsGetInstanceBlock)(void);
typedef id   (^UserDefaultsGetBlock)(NSString *key);
typedef void (^UserDefaultsSetBlock)(NSString *key,id obj);
typedef void (^UserDefaultsSetWithLimitBlock)(NSString *key,id obj ,NSTimeInterval limit);

@interface NSUserDefaults (TokenNetworking)
@property(nonatomic, copy ,readonly ,class) UserDefaultsGetInstanceBlock token_sharedDefaults;
@property(nonatomic, copy ,readonly ,class) UserDefaultsGetBlock token_get;
@property(nonatomic, copy ,readonly ,class) UserDefaultsSetBlock token_set;
@property(nonatomic, copy ,readonly ,class) UserDefaultsSetWithLimitBlock token_setWithLimit;
@end


