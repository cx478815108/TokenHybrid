//
//  UIViewController+Token.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef __kindof NSObject *(^TokenObjectInitBlock)(void);

@interface NSObject (Token)
@property (nonatomic ,copy ,readonly ,class) TokenObjectInitBlock token_init;
@end

typedef void(^TokenVoidBlock)(void);

typedef __kindof UIViewController *(^TokenControllerVoidOperationBlock)(void);
typedef __kindof UIViewController *(^TokenControllerOperationBlock)(UIViewController *viewController);
typedef __kindof UIViewController *(^TokenControllerPresentBlock)(UIViewController *controller,BOOL animated,TokenVoidBlock completion);
typedef __kindof UIViewController *(^TokenControllerDismissBlock)(BOOL animated,TokenVoidBlock completion);

@interface UIViewController (Token)
@property (nonatomic ,copy ,readonly) TokenControllerPresentBlock       token_presentViewController;
@property (nonatomic ,copy ,readonly) TokenControllerDismissBlock       token_dismissViewController;
@property (nonatomic ,copy ,readonly) TokenControllerOperationBlock     token_addChildViewController;
@property (nonatomic ,copy ,readonly) TokenControllerVoidOperationBlock token_removeFromParentViewController;
@end


typedef __kindof UINavigationController *(^TokenControllerPushOperationBlock)(UIViewController *controller,BOOL animated);
typedef __kindof UINavigationController *(^TokenControllerBOOLOperationBlock)(BOOL value);

@interface UINavigationController (Token)

@property (nonatomic ,copy ,readonly ,class) TokenControllerOperationBlock  token_initWithRootViewController;
@property (nonatomic ,copy ,readonly) TokenControllerPushOperationBlock     token_pushViewController;
@property (nonatomic ,copy ,readonly) TokenControllerBOOLOperationBlock     token_popViewController;
@end

