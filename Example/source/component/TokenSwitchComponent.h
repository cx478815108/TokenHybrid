//
//  TokenSwitchComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/29.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenSwitchNode;
@interface TokenSwitchComponent : UISwitch
@property(nonatomic ,weak) TokenSwitchNode *associatedNode;
@end
