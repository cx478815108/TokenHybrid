//
//  TokenPureComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/9.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenPureComponent.h"
#import "TokenHybridConstant.h"
#import <YogaKit/UIView+Yoga.h>

typedef void(^TokenComponentEnumerateBlock)(__kindof UIView *view);

@implementation TokenPureComponent

-(void)didApplyAllAttributs{
    [[NSNotificationCenter defaultCenter] postNotificationName:TokenHybridComponentDidApplyLayoutNotification object:nil];
}

-(void)applyFlexLayout{
    self.yoga.isEnabled = YES;
    [self.yoga applyLayoutPreservingOrigin:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:TokenHybridComponentDidApplyLayoutNotification object:nil];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:TokenHybridEndEditingNotification object:nil];
}

@end

@implementation TokenTableHeaderComponent
@end

@implementation TokenTableFooterComponent
@end


