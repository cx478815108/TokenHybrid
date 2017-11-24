//
//  TokenNetworking.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TokenNetworkingCategories.h"

@class TokenNetworking;

typedef NSString *(^TokenNetworkingGetStringBlock)(void);


typedef void(^TokenNetSuccessBlock)(TokenNetworking *netWorkingObj,NSURLSessionTask *task,id responsedObj);
typedef void(^TokenNetFailureBlock)(TokenNetworking *netWorkingObj,NSError *error);

typedef void(^TokenResponseSerializeFailureBlock)(NSError *error);

typedef id (^TokenChainTransformParameterBlock)(TokenNetworking *netWorking,id responsedObj);
typedef NSURL *(^TokenURLMakeBlock)(TokenNetworking *netWorking);
typedef NSURLRequest *(^TokenRequestMakeBlock)(TokenNetworking *netWorking);
typedef NSURLRequest *(^TokenChainRedirectParameterBlock)(NSURLRequest *request,NSURLResponse *response);

typedef TokenNetworking *(^TokenNetworkingInstanceBlock)(void);
typedef TokenNetworking *(^TokenChainVoidParameterBlock)(void);
typedef TokenNetworking *(^TokenThenBlock)(NSTimeInterval time);
typedef TokenNetworking *(^TokenChainRedirectBlock)(TokenChainRedirectParameterBlock redirectParameter);
typedef TokenNetworking *(^TokenSendRequestBlock)(TokenRequestMakeBlock make);
typedef TokenNetworking *(^TokenSendURLBlock)(TokenURLMakeBlock make);
typedef TokenNetworking *(^TokenFinishBlock)(TokenNetSuccessBlock success,TokenNetFailureBlock failure);
typedef TokenNetworking *(^TokenDataTransformBlock)(TokenChainTransformParameterBlock passResponseBlock);

@interface TokenNetworking : NSObject
@property(nonatomic ,copy ,readonly) TokenSendRequestBlock   sendRequest;
@property(nonatomic ,copy ,readonly) TokenSendURLBlock       sendURL;
@property(nonatomic ,copy ,readonly) TokenSendRequestBlock   afterSendRequest;
@property(nonatomic ,copy ,readonly) TokenSendURLBlock       afterSendURL;
@property(nonatomic ,copy ,readonly) TokenChainRedirectBlock willRedict;
@property(nonatomic ,copy ,readonly) TokenDataTransformBlock transform;
@property(nonatomic ,copy ,readonly) TokenFinishBlock        finish;
@property(nonatomic ,copy ,readonly) TokenThenBlock          thenAfter;
@property(nonatomic ,copy ,readonly ,class) TokenNetworkingInstanceBlock networking;
@property(nonatomic ,copy ,readonly ,class) TokenNetworkingGetStringBlock randomUA;
@property(nonatomic ,copy ,readonly ,class) TokenNetworkingGetStringBlock defaultUA;

-(void)stopWorking;
-(TokenNetworking *)then;

-(id)JSONSerializeWithData:(NSData *)data failure:(TokenResponseSerializeFailureBlock)failure;
-(NSString *)HTMLTextSerializeWithData:(NSData *)data;
@end



