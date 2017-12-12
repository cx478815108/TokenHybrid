//
//  TokenInputComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/17.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenInputNode;
@interface TokenInputComponent : UITextField
@property(nonatomic ,weak  ) TokenInputNode *associatedNode;
@end
