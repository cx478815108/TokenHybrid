//
//  TokenPickerComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/30.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TokenPickerComponentSureBlock)(NSDictionary *result);
@interface TokenPickerComponent : UIView
+(void)showInView:(UIView *)superView
             data:(NSDictionary *)data
        sureBlock:(TokenPickerComponentSureBlock)sureBlock;
@end
