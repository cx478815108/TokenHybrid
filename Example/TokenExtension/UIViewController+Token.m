//
//  UIViewController+Token.m
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "UIViewController+Token.h"

@implementation NSObject (Token)
+(TokenObjectInitBlock)token_init{
    return ^NSObject*(void){
        return [[self alloc] init];
    };
}
@end

@implementation UIViewController (Token)
-(TokenControllerDismissBlock)token_dismissViewController{
    return ^UIViewController *(BOOL animated,TokenVoidBlock completion){
        [self dismissViewControllerAnimated:animated completion:completion];
        return self;
    };
}

-(TokenControllerPresentBlock)token_presentViewController{
    return ^UIViewController *(UIViewController *controller, BOOL animated, TokenVoidBlock completion) {
        [self presentViewController:controller animated:animated completion:completion];
        return self;
    };
}
-(TokenControllerOperationBlock)token_addChildViewController{
    return ^UIViewController *(UIViewController *viewController) {
        [self addChildViewController:viewController];
        return self;
    };
}

-(TokenControllerVoidOperationBlock)token_removeFromParentViewController{
    return ^UIViewController *() {
        [self removeFromParentViewController];
        return self;
    };
}

@end


@implementation UINavigationController (Token)

+(TokenControllerOperationBlock)token_initWithRootViewController{
    return ^UIViewController *(UIViewController *viewController) {
        return [[self alloc] initWithRootViewController:viewController];
    };
}

-(TokenControllerPushOperationBlock)token_pushViewController{
    return ^UINavigationController *(UIViewController *controller, BOOL animated) {
        [self pushViewController:controller animated:animated];
        return self;
    };
}

-(TokenControllerBOOLOperationBlock)token_popViewController{
    return ^UINavigationController *(BOOL animated) {
        [self popViewControllerAnimated:animated];
        return self;
    };
}

@end
