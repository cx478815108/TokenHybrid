//
//  Token.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/18.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenTool.h"
#import "TokenNetworking.h"
#import "TokenHybridConstant.h"
#import "TokenHybridDefine.h"
#import "TokenPickerComponent.h"
#import "TokenJSContext.h"

#import "NSUserDefaults+Token.h"
#import "NSString+Token.h"
#import "NSString+Token.h"
#import "JSValue+Token.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <CoreLocation/CoreLocation.h>
#import <LocalAuthentication/LocalAuthentication.h>

@interface TokenTool()<CLLocationManagerDelegate>
@end

@implementation TokenTool
{
    CLLocationManager *_locationManager;
    JSManagedValue    *_locationCallBackJSValue;
    NSUserDefaults    *_globleDefaultes;
    NSString          *_globleSuiteName;
    UIImageView       *_saveImageView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _globleSuiteName = @"com.token.globleDefaultes";
        _globleDefaultes = NSUserDefaults.token_initWithSuiteName(_globleSuiteName);
    }
    return self;
}


-(void)saveImageWithJSValue:(JSValue *)imageValue{
    JSValue *urlValue = imageValue[@"url"];
    if (urlValue == nil && [urlValue isUndefined]) return;
    JSValue *successCallBack = imageValue[@"success"];
    JSValue *failureCallBack = imageValue[@"failure"];
    dispatch_async(dispatch_get_main_queue(), ^{
        _saveImageView = [[UIImageView alloc] init];
        NSURL *url = [NSURL URLWithString:[urlValue toString]];
        [_saveImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (@available(iOS 10, *)) {
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    if (status == PHAuthorizationStatusAuthorized) {
                        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                            [PHAssetChangeRequest creationRequestForAssetFromImage:image];
                        } completionHandler:^(BOOL success, NSError * _Nullable error) {
                            if (success) {
                                [successCallBack callWithArguments:@[@"图片保存成功"]];
                            }
                            else {
                                [failureCallBack callWithArguments:@[@0,error.localizedDescription]];
                            }
                        }];
                    }
                    else {
                        [failureCallBack callWithArguments:@[@"用户关闭了相册操作权限"]];
                    }
                }];
            }
            else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
                __block ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
                [lib writeImageToSavedPhotosAlbum:image.CGImage metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
                    if (error) {
                        [failureCallBack callWithArguments:@[error.localizedDescription]];
                    }
                    else {
                        [successCallBack callWithArguments:@[@"图片保存成功"]];
                    }
                }];
#pragma clang diagnostic pop
            }
        }];
    });
}

-(void)getLocation:(JSValue *)callBack{
    if (callBack == nil || [callBack isUndefined]) return;
    _locationCallBackJSValue = [JSManagedValue managedValueWithValue:callBack];
    [self startLocation];
}

-(void)startLocation{
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    if (@available(iOS 8, *)) {
        [locationManager requestWhenInUseAuthorization];
    }
    locationManager.distanceFilter = 100.0;
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
    _locationManager = locationManager;
}

#pragma mark -
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    [manager stopUpdatingLocation];
    if (locations.count) {
        CLLocation *location = locations[0];
        NSNumber *longitude = @(location.coordinate.longitude);
        NSNumber *latitude = @(location.coordinate.latitude);
        NSDictionary *info = @{
                               @"longitude":longitude,
                               @"latitude":latitude
                               };
        [_locationCallBackJSValue.value callWithArguments:@[info]];
    }
    _locationCallBackJSValue = nil;
}

-(void)makePhoneCall:(NSString *)number{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",number];
        if (@available(iOS 10, *)) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
        }
        else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    });
}

#pragma mark - http request

-(void)requestWithValue:(JSValue *)requestValue{
    JSValue *url        = requestValue[@"url"];
    JSValue *failure    = requestValue[@"failure"];
    JSValue *success    = requestValue[@"success"];
    NSString *urlString = [[url toString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    if (url && ![url isUndefined] && urlString) {
        TokenNetworking.networking().sendRequest(^NSURLRequest *(TokenNetworking *netWorking) {
            
            NSMutableURLRequest *request = NSMutableURLRequest.token_requestWithURL(urlString);
            JSValue *method              = requestValue[@"method"];
            JSValue *UA                  = requestValue[@"UA"];
            JSValue *timeout             = requestValue[@"timeout"];
            JSValue *header              = requestValue[@"header"];
            JSValue *httpParameter       = requestValue[@"httpParameter"];
            JSValue *jsonParameter       = requestValue[@"jsonParameter"];
            
            if (UA && ![UA isUndefined]) {
                request.token_setUA([UA toString]);
            }
            
            if (timeout && ![timeout isUndefined]) {
                request.token_setTimeout([[timeout toNumber] floatValue]);
            }
            
            if (method && ![method isUndefined]) {
                request.token_setMethod([method toString]);
            }
            
            if (![header token_isNilObject]) {
                request.token_addHeaderValues([header toDictionary]);
            }
            
            if (![httpParameter token_isNilObject]) {
                NSDictionary *dic = [httpParameter toDictionary];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    request.token_setHTTPParameter([httpParameter toDictionary]);
                }
            }
            else if (![jsonParameter token_isNilObject]) {
                NSDictionary *dic = [httpParameter toDictionary];
                if ([dic isKindOfClass:[NSDictionary class]]) {
                    request.token_setJSONParameter([httpParameter toDictionary],nil);
                }
            }
            return request;
        })
        .transform(^id(TokenNetworking *netWorking, id responsedObj) {
            JSValue *resultType = requestValue[@"resultType"];
            if (resultType && ![resultType isUndefined]) {
                NSString *resultString = [resultType toString];
                if ([resultString isEqualToString:@"text"]) {
                    return [netWorking HTMLTextSerializeWithData:responsedObj];
                }
            }
            return [netWorking JSONSerializeWithData:responsedObj failure:^(NSError *error) {
                [netWorking stopWorking];
                if (failure && ![failure isUndefined]) {
                    [failure callWithArguments:@[error.localizedDescription]];
                }
            }];
        })
        .finish(^(TokenNetworking *netWorkingObj, NSURLSessionTask *task, id responsedObj) {
            if (success && ![success isUndefined]) {
                [success callWithArguments:@[responsedObj]];
            }
        }, ^(TokenNetworking *netWorkingObj, NSError *error) {
            if (failure && ![failure isUndefined]) {
                [failure callWithArguments:@[error.localizedDescription]];
            }
        });
    }
    else {
        if (failure && ![failure isUndefined]) {
            [failure callWithArguments:@[@"加载失败，URL不合法"]];
        }
    }
}

#pragma mark - UI

-(void)pickData:(JSValue *)pickValue{
    if (pickValue == nil || [pickValue isUndefined]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *data = [pickValue toDictionary];
        UIView *view = [UIApplication sharedApplication].keyWindow;
        [TokenPickerComponent showInView:view data:data sureBlock:^(NSDictionary *result) {
            JSValue *finish = pickValue[@"finish"];
            if (finish == nil || [finish  isUndefined]) return ;
            [finish callWithArguments:@[result]];
        }];
    });
}

-(void)showSheetViewWithJSValue:(JSValue *)sheetValue{
    JSValue *titleValue       = sheetValue[@"title"];
    JSValue *msg              = sheetValue[@"msg"];
    JSValue *actionTitles     = sheetValue[@"actionTitles"];
    JSValue *feedback         = sheetValue[@"feedBack"];
    JSValue *cancleButton     = sheetValue[@"cancleButton"];
    NSArray *actionTitleArray = [actionTitles toArray];
    
    if (actionTitles == nil || [actionTitles isUndefined] || actionTitleArray == nil) {
        return;
    }
    
    BOOL showCancleButton = YES;
    NSString *cancleButtonString = [cancleButton toString];
    if ([cancleButtonString isEqualToString:@"false"]) {
        showCancleButton = NO;
    }
    else if ([cancleButtonString isEqualToString:@"true"]) {
        showCancleButton = YES;
    }
    
    [self showAlertControllerWithStyle: UIAlertControllerStyleActionSheet
                                 title: [titleValue toString]
                                   msg: [msg toString]
                          actionTitles: actionTitleArray
                              callBack: feedback
                          cancleButton: showCancleButton];
}

-(void)alertWithWithJSValue:(JSValue *)alertValue
{
    JSValue *titleValue       = alertValue[@"title"];
    JSValue *msg              = alertValue[@"msg"];
    JSValue *actionTitles     = alertValue[@"actionTitles"];
    JSValue *feedback         = alertValue[@"feedBack"];
    JSValue *cancleButton     = alertValue[@"cancleButton"];
    NSArray *actionTitleArray = [actionTitles toArray];
    
    if (actionTitles == nil || [actionTitles isUndefined] || actionTitleArray == nil) {
        return;
    }
    
    BOOL showCancleButton = YES;
    NSString *cancleButtonString = [cancleButton toString];
    if ([cancleButtonString isEqualToString:@"false"]) {
        showCancleButton = NO;
    }
    else if ([cancleButtonString isEqualToString:@"true"]) {
        showCancleButton = YES;
    }
    
    [self showAlertControllerWithStyle: UIAlertControllerStyleAlert
                                 title: [titleValue toString]
                                   msg: [msg toString]
                          actionTitles: actionTitleArray
                              callBack: feedback
                          cancleButton: showCancleButton];
    
}

-(void)showAlertControllerWithStyle:(UIAlertControllerStyle)style title:(NSString *)title
                                msg:(NSString *)msg
                       actionTitles:(NSArray *)actionTitles
                           callBack:(JSValue *)callBack
                       cancleButton:(BOOL)cancleButton
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:style];
        
        for (NSString *title in actionTitles) {
            [alertController addAction:[UIAlertAction actionWithTitle:title style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                if (![callBack isUndefined]) {
                    NSInteger index = [actionTitles indexOfObject:action.title];
                    [callBack callWithArguments:@[@(index)]];
                }
            }]];
        }
        if (cancleButton) {
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
                if (![callBack isUndefined]) {
                    [callBack callWithArguments:@[@(-1)]];
                }
            }]];
        }
        [[self.jsContext getContainerController] presentViewController:alertController animated:YES completion:nil];
    });
}

-(void)alertWithTitle:(NSString *)title
                  msg:(NSString *)msg
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title
                                                                       message:msg?msg:@""
                                                                preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           __strong typeof(weakAlert) strongAlert = weakAlert;
                                                           [strongAlert dismissViewControllerAnimated:YES completion:nil];
                                                       }];
        [alert addAction:action];
        [[self.jsContext getContainerController] presentViewController:alert animated:YES completion:nil];
    });
}

-(void)alertInput:(JSValue *)alertValue{
    JSValue *titleValue       = alertValue[@"title"];
    JSValue *msg              = alertValue[@"msg"];
    JSValue *textFiledValues  = alertValue[@"textFields"];
    JSValue *feedback         = alertValue[@"feedBack"];
    if ([textFiledValues token_isNilObject]) return;
    NSArray *textFiledConfigs = [textFiledValues toArray];
    if (![textFiledConfigs isKindOfClass:[NSArray class]]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[titleValue toString] message:[msg toString]  preferredStyle:UIAlertControllerStyleAlert];
        
        [textFiledConfigs enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                    NSString *placeholder      = obj[@"placeholder"];
                    NSString *defaultText      = obj[@"defaultText"];
                    NSString *secureText       = obj[@"secureText"];
                    textField.placeholder = placeholder;
                    if (defaultText) {
                        textField.text = defaultText;
                    }
                    if (secureText) {
                        textField.secureTextEntry = secureText.token_turnBoolStringToBoolValue();
                    }
                }];
            }
        }];
        
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }])];
        
        __weak UIAlertController *weakController = alertController;
        [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __weak typeof(weakController) strongController = weakController;
            if (![feedback token_isNilObject]) {
                NSMutableArray *texts = @[].mutableCopy;
                [strongController.textFields enumerateObjectsUsingBlock:^(UITextField * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if (obj.text && obj.text.length) {
                        [texts addObject:obj.text];
                    }
                }];
                [feedback callWithArguments:texts];
            }
        }])];
        [[self.jsContext getContainerController] presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - debug

-(void)log:(NSString *)msg
{
    HybridLog(@"%@",msg);
}

#pragma mark - device
-(NSNumber *)screenWidth{
    return @([UIScreen mainScreen].bounds.size.width);
}

-(NSNumber *)screenHeight{
    return @([UIScreen mainScreen].bounds.size.height);
}

#pragma mark - touchID
-(void)requestTouchIDWithTitle:(JSValue *)title callBack:(JSValue *)callBack{
    NSString *desc= [title token_isNilObject]?@"请通过Home键验证已有指纹":[title toString];
    LAContext *context = [[LAContext alloc] init];
    context.localizedFallbackTitle = desc;
    NSError *error = nil;
    
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        if (![callBack token_isNilObject]) {
            [callBack callWithArguments:@[@0,@"当前设备不支持TouchID"]];
        }
        return ;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:desc reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                if (![callBack token_isNilObject]) {
                    [callBack callWithArguments:@[@1,@"TouchID 验证成功"]];
                }
            }
            else if(error){
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        if (![callBack token_isNilObject]) {
                            [callBack callWithArguments:@[@0,@"TouchID 验证失败"]];
                        }
                        break;
                    case LAErrorUserCancel:
                        if (![callBack token_isNilObject]) {
                            [callBack callWithArguments:@[@0,@"TouchID 被用户取消"]];
                        }
                        break;
                    case LAErrorUserFallback:
                        if (![callBack token_isNilObject]) {
                            [callBack callWithArguments:@[@0,@"TouchID 用户使用密码输入"]];
                        }
                        break;
                    case LAErrorSystemCancel:
                        if (![callBack token_isNilObject]) {
                            [callBack callWithArguments:@[@0,@"TouchID 被系统取消"]];
                        }
                        break;
                    case LAErrorPasscodeNotSet:
                        if (![callBack token_isNilObject]) {
                            [callBack callWithArguments:@[@0,@"TouchID 未启用，用户没有设置密码"]];
                        }
                        break;
                    default:
                        if (![callBack token_isNilObject]) {
                            [callBack callWithArguments:@[@0,@"TouchID 验证失败"]];
                        }
                        break;
                }
            }
        }];
    });
}

#pragma mark - storage
-(id)getStorage:(JSValue *)key{
    return [[self currentPageDefaultes] objectForKey:[key toString]];
}

-(id)getGlobleStorage:(JSValue *)key{
    return _globleDefaultes.token_objectForKey([key toString]);
}

-(void)setStorage:(JSValue *)dicValue{
    [self setStorageWithJSValue:dicValue defaultes:[self currentPageDefaultes]];
}
-(void)setGlobleStorage:(JSValue *)dicValue{
    [self setStorageWithJSValue:dicValue defaultes:_globleDefaultes];
}

-(void)clearAllStorage{
    if ([self currentPageDefaultes]) {
        [self currentPageDefaultes].token_removePersistentDomainForName(NSString.token_md5(_globleSuiteName));
    }
}

-(void)clearGlobleStorage{
    _globleDefaultes.token_removePersistentDomainForName(_globleSuiteName);
}

-(void)setStorageWithJSValue:(JSValue *)dicValue
                   defaultes:(NSUserDefaults *)defaultes{
    if (defaultes == nil) return;
    NSDictionary *dicData = [dicValue toDictionary];
    id data               = dicData[@"value"];
    NSString *key         = dicData[@"key"];
    if (defaultes == nil                              ||
        dicData == nil                                ||
        ![dicData isKindOfClass:[NSDictionary class]] ||
        key == nil                                    ||
        ![key isKindOfClass:[NSString class]]
        ) {
        return ;
    }
    defaultes.token_setObjectForKey(key,data);
}

-(void)setTimeOutWithCallBack:(JSValue *)callBack interval:(JSValue *)interval{
    if ([callBack token_isNilObject] || [interval token_isNilObject]) {
        return;
    }
    CGFloat timeInterval = [[interval toNumber] floatValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        [callBack callWithArguments:nil];
    });
}

-(void)setMainTimeOutWithCallBack:(JSValue *)callBack interval:(JSValue *)interval{
    if ([callBack token_isNilObject] || [interval token_isNilObject]) {
        return;
    }
    CGFloat timeInterval = [[interval toNumber] floatValue];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeInterval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [callBack callWithArguments:nil];
    });
}

#pragma mark - getter
-(NSUserDefaults *)currentPageDefaultes{
    return [self.jsContext getCurrentPageUserDefaults];
}

@end
