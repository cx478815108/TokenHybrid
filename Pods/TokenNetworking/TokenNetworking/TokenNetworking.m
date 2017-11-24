//
//  TokenNetworking.m
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenNetworking.h"

@import UIKit;

NS_INLINE dispatch_queue_t tokenNetworkingSendQueue(){
    static dispatch_once_t onceToken;
    static dispatch_queue_t _obj;
    dispatch_once(&onceToken, ^{
        _obj = dispatch_queue_create("com.tokenNetworking.queue", DISPATCH_QUEUE_SERIAL);
    });
    return _obj;
}

typedef void(^tokenNetworkingExcuseBlock)(void);
NS_INLINE void tokenNetworkingQueueAsync(tokenNetworkingExcuseBlock code){
    if (code) {
        dispatch_async(tokenNetworkingSendQueue(), ^{
            code();
        });
    }
}

NS_INLINE void tokenNetworkingMainAsync(tokenNetworkingExcuseBlock code){
    if ([NSThread isMainThread]) {
        !code?:code();
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            !code?:code();
        });
    }
}

@interface TokenStack:NSObject
-(NSInteger)count;
-(id)pop;
-(void)push:(id)obj;
-(id)topObject;
-(void)popItme:(id)item;
-(void)clear;
-(id)getObjectAtIndex:(NSInteger)index;
@end

@interface TokenNetworkingHandler : NSObject
@property(nonatomic ,assign) NSInteger taskID;
@property(nonatomic ,copy) TokenChainRedirectParameterBlock redirectBlock;
@property(nonatomic ,copy) TokenNetSuccessBlock successBlock;
@property(nonatomic ,copy) TokenNetFailureBlock failureBlock;
@property(nonatomic ,copy) TokenChainTransformParameterBlock transformGetBlock;
@property(nonatomic ,strong) NSMutableData *data;
@property(nonatomic ,weak  ) NSURLSessionTask *task;
@property(nonatomic ,assign) BOOL shouldAfter;
@end

@interface TokenNetworking()<NSURLSessionTaskDelegate>
@property(nonatomic ,strong) NSMutableData    *data;
@property(nonatomic ,strong) NSURLSession     *session;
@property(nonatomic ,strong) NSOperationQueue *operationQueue;
@property(nonatomic ,strong) TokenStack       *stack;
@end

@implementation TokenNetworking{
    dispatch_semaphore_t _sendSemaphore;
    dispatch_semaphore_t _lockSemaphore;
    NSInteger            _taskCountIncludeAfterThan;
    BOOL                 _stopWorking;
}

+(NSOperationQueue *)processQueue{
    static dispatch_once_t onceToken;
    static NSOperationQueue *processQueue;
    dispatch_once(&onceToken, ^{
        processQueue = [[NSOperationQueue alloc] init];
        processQueue.maxConcurrentOperationCount = 4;
    });
    return processQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableData data];
        self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                     delegate:self
                                                delegateQueue:[TokenNetworking processQueue]];
        self.stack = [[TokenStack alloc] init];
        _taskCountIncludeAfterThan = 0;
        _sendSemaphore = dispatch_semaphore_create(1);
        _lockSemaphore = dispatch_semaphore_create(1);
        _stopWorking = NO;
    }
    return self;
}

#pragma mark - action
-(void)lock{
    dispatch_semaphore_wait(_lockSemaphore, DISPATCH_TIME_FOREVER);
}

-(void)unlock{
    dispatch_semaphore_signal(_lockSemaphore);
}

-(void)stopWorking
{
    _stopWorking = YES;
}

#pragma mark - NSURLSessionTaskDelegate

-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
       newRequest:(NSURLRequest *)request
completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler
{
    if (_stopWorking) {
        return completionHandler(nil);
    }
    
    TokenNetworkingHandler *handle = nil;
    for (NSInteger i = 0; i <self.stack.count; i++) {
        handle = [self.stack getObjectAtIndex:i];
        if (handle.taskID == task.taskIdentifier) {
            break;
        }
    }
    
    if (handle == nil) {
        completionHandler(request);
    }
    else {
        if (handle.redirectBlock) {
            NSURLRequest *newRequest = handle.redirectBlock(request ,response);
            completionHandler(newRequest);
        }
        else {
            completionHandler(request);
        }
    }
}

-(void)URLSession:(NSURLSession *)session
         dataTask:(NSURLSessionDataTask *)dataTask
   didReceiveData:(NSData *)data
{
    TokenNetworkingHandler *handle = nil;
    for (NSInteger i = 0; i <self.stack.count; i++) {
        handle = [self.stack getObjectAtIndex:i];
        if (handle.taskID == dataTask.taskIdentifier) {
            [handle.data appendData:data];
            break;
        }
    }
}

-(void)URLSession:(NSURLSession *)session
             task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{
    [self lock];
    TokenNetworkingHandler *handler = nil;
    for (NSInteger i = 0; i <self.stack.count; i++) {
        handler = [self.stack getObjectAtIndex:i];
        if (handler.taskID == task.taskIdentifier) {
            break;
        }
    }
    [self.stack popItme:handler];
    _taskCountIncludeAfterThan -= 1;
    
    if (_taskCountIncludeAfterThan == 0 || _stopWorking) {
        [session finishTasksAndInvalidate];
    }
    
    [self unlock];
    
    if (error == nil) {
        NSData *transformedData = handler.data;
        //data transform
        if (handler.transformGetBlock && !_stopWorking) {
            transformedData = handler.transformGetBlock(self,transformedData);
        }
        tokenNetworkingMainAsync(^{
            if (!_stopWorking) {
                !handler.successBlock?:handler.successBlock(self,task,transformedData);
            }
            if (handler.shouldAfter) { //任务执行完成后发送信号
                dispatch_semaphore_signal(_sendSemaphore);
            }
        });
    }
    else {
        tokenNetworkingMainAsync(^{
            if (!_stopWorking) {
                !handler.failureBlock?:handler.failureBlock(self,error);
            }
            if (handler.shouldAfter) { //任务执行完成后发送信号
                dispatch_semaphore_signal(_sendSemaphore);
            }
        });
    }
}

#pragma mark - block getter

+(TokenNetworkingInstanceBlock)networking{
    return ^TokenNetworking *{
        return [[TokenNetworking alloc] init];
    };
}

-(TokenSendRequestBlock)sendRequest{
    return ^TokenNetworking *(TokenRequestMakeBlock make) {
        tokenNetworkingQueueAsync(^{
            if (make) {
                NSURLRequest *request = make(self);
                if (request != nil) {
                    _taskCountIncludeAfterThan += 1;
                    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
                    TokenNetworkingHandler *handle = [[TokenNetworkingHandler alloc] init];
                    handle.taskID = task.taskIdentifier;
                    handle.task = task;
                    [self.stack push:handle];
                    [task resume];
                }
            }
        });
        return self;
    };
}

-(TokenSendRequestBlock)afterSendRequest{
    return  ^TokenNetworking *(TokenRequestMakeBlock make) {
        tokenNetworkingQueueAsync(^{
            if (make) {
                _taskCountIncludeAfterThan += 1;
                dispatch_semaphore_wait(_sendSemaphore, DISPATCH_TIME_FOREVER);
                NSURLRequest *request = make(self);
                if (request != nil) {
                    NSURLSessionTask *task = [self.session dataTaskWithRequest:request];
                    TokenNetworkingHandler *handle = [[TokenNetworkingHandler alloc] init];
                    handle.taskID = task.taskIdentifier;
                    handle.shouldAfter = YES;
                    handle.task = task;
                    [self.stack push:handle];
                    [task resume];
                }
            }
        });
        return self;
    };
}

-(TokenSendURLBlock)sendURL{
    return  ^TokenNetworking *(TokenURLMakeBlock make) {
        tokenNetworkingQueueAsync(^{
            if (make) {
                NSURL *url = make(self);
                if (url != nil) {
                    _taskCountIncludeAfterThan += 1;
                    NSURLSessionTask *task = [self.session dataTaskWithURL:url];
                    TokenNetworkingHandler *handle = [[TokenNetworkingHandler alloc] init];
                    handle.taskID = task.taskIdentifier;
                    handle.task = task;
                    [self.stack push:handle];
                    [task resume];
                }
            }
        });
        return self;
    };
}

-(TokenSendURLBlock)afterSendURL{
    return  ^TokenNetworking *(TokenURLMakeBlock make) {
        tokenNetworkingQueueAsync(^{
            if (make) {
                _taskCountIncludeAfterThan += 1;
                dispatch_semaphore_wait(_sendSemaphore, DISPATCH_TIME_FOREVER);
                NSURL *url = make(self);
                if (url != nil ) {
                    NSURLSessionTask *task = [self.session dataTaskWithURL:url];
                    TokenNetworkingHandler *handle = [[TokenNetworkingHandler alloc] init];
                    handle.taskID = task.taskIdentifier;
                    handle.shouldAfter = YES;
                    handle.task = task;
                    [self.stack push:handle];
                    [task resume];
                }
            }
        });
        return self;
    };
}

-(TokenChainRedirectBlock)willRedict{
    return ^TokenNetworking *(TokenChainRedirectParameterBlock redirectParameter) {
        tokenNetworkingQueueAsync(^{
            [self lock];
            TokenNetworkingHandler *handle = [self.stack topObject];
            handle.redirectBlock = redirectParameter;
            [self unlock];
        });
        return  self;
    };
}

-(TokenDataTransformBlock)transform{
    return ^TokenNetworking *(TokenChainTransformParameterBlock passResponseBlock) {
        tokenNetworkingQueueAsync(^{
            [self lock];
            TokenNetworkingHandler *handle = [self.stack topObject];
            handle.transformGetBlock = passResponseBlock;
            [self unlock];
        });
        return self;
    };
}

-(TokenFinishBlock)finish{
    return ^TokenNetworking *(TokenNetSuccessBlock success, TokenNetFailureBlock failure) {
        tokenNetworkingQueueAsync(^{
            [self lock];
            TokenNetworkingHandler *handle = [self.stack topObject];
            handle.successBlock = success;
            handle.failureBlock = failure;
            [self unlock];
        });
        return self;
    };
}

-(TokenThenBlock)thenAfter{
    return  ^TokenNetworking *(NSTimeInterval time) {
        tokenNetworkingQueueAsync(^{
            NSCondition *waitCondition = [[NSCondition alloc] init];
            [waitCondition lock];
            _taskCountIncludeAfterThan += 1;
            [waitCondition waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:time]];
            _taskCountIncludeAfterThan -= 1;
            [waitCondition unlock];
        });
        return self;
    };
}

-(TokenNetworking *)then{
    return self;
}

#pragma mark -class getter
+(TokenNetworkingGetStringBlock)randomUA{
    return ^NSString *{
        return [self getRandomUA];
    };
}

+(TokenNetworkingGetStringBlock)defaultUA{
    return ^NSString *{
        return [self getDefaultUA];
    };
}

#pragma mark - getter

-(NSString *)HTMLTextSerializeWithData:(NSData *)data
{
    if (data == nil) { return nil;}
    NSString *textString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return textString;
}

-(id)JSONSerializeWithData:(NSData *)data failure:(TokenResponseSerializeFailureBlock)failure{
    if (data == nil) return nil;
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        !failure?:failure(error);
        return nil;
    }
    else {
        return obj;
    }
}

+(NSString *)getDefaultUA{
    NSString *userAgent = [NSString stringWithFormat:@"%@/%@ (%@; iOS %@; Scale/%0.2f)", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleIdentifierKey], [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] ?: [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleVersionKey], [[UIDevice currentDevice] model], [[UIDevice currentDevice] systemVersion], [[UIScreen mainScreen] scale]];
    
    if (![userAgent canBeConvertedToEncoding:NSASCIIStringEncoding]) {
        NSMutableString *mutableUserAgent = [userAgent mutableCopy];
        if (CFStringTransform((__bridge CFMutableStringRef)(mutableUserAgent), NULL, (__bridge CFStringRef)@"Any-Latin; Latin-ASCII; [:^ASCII:] Remove", false)) {
            userAgent = mutableUserAgent;
        }
    }
    return  userAgent;
}

+(NSString *)getRandomUA{
    
    //获取1到x之间的整数的代码如下:
    NSInteger smallNumber = (arc4random() % 10) + 1;
    
    CGFloat version = [self randomFloatBetweenLowerNum:603 upperNum:620];
    NSInteger interVersion = ceil(version);
    NSString *safariUA = [NSString stringWithFormat:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_%@) AppleWebKit/%@.3.8 (KHTML, like Gecko) Version/10.1.2 Safari/%@.3.8",@(smallNumber),@(interVersion),@(interVersion)];
    version = [self randomFloatBetweenLowerNum:520 upperNum:600];
    
    
    NSString *chromeUA = [NSString stringWithFormat:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_%@) AppleWebKit/%@.36 (KHTML, like Gecko) Chrome/%@.0.3112.101 Safari/%@.36",@(smallNumber),@(interVersion),@(smallNumber+58),@(interVersion)];
    NSString *firefox = [NSString stringWithFormat:@"Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101 Firefox/%@.0",@(smallNumber+40)];
    NSString *opera = [NSString stringWithFormat:@"Opera/9.80 (Windows NT 6.1; U; en) Presto/2.8.131 Version/%@.11",@(smallNumber+8)];
    NSArray *usSet = @[safariUA,chromeUA,firefox,opera];
    return usSet[smallNumber%4];
}

+(CGFloat)randomFloatBetweenLowerNum:(CGFloat)num1 upperNum:(CGFloat)num2
{
    NSInteger startVal = num1*10000;
    NSInteger endVal = num2*10000;
    
    NSInteger randomValue = startVal +(arc4random()%(endVal - startVal));
    CGFloat a = randomValue;
    
    return(a /10000.0);
}

@end

#pragma mark - TokenNetworkingHandler implementation

@implementation TokenNetworkingHandler
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableData data];
    }
    return self;
}
@end

#pragma mark - TokenStack implementation

@interface TokenStack()
@property(nonatomic ,strong) NSMutableArray *array;
@end

@implementation TokenStack
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.array = @[].mutableCopy;
    }
    return self;
}

-(void)push:(id)obj{
    [self.array addObject:obj];
}

-(id)pop{
    NSInteger index = self.array.count-1;
    if (index>=0) {
        id obj = [self.array objectAtIndex:index];
        [self.array removeObjectAtIndex:index];
        return obj;
    }
    
    return nil;
}

-(id)topObject{
    NSInteger index = self.array.count-1;
    if (index>=0) {
        id obj = [self.array objectAtIndex:index];
        return obj;
    }
    return nil;
}

-(NSInteger)count{
    return self.array.count;
}

-(id)getObjectAtIndex:(NSInteger)index{
    return self.array[index];
}

-(void)popItme:(id)item{
    [self.array removeObject:item];
}

-(void)clear{
    [self.array removeAllObjects];
}
@end


