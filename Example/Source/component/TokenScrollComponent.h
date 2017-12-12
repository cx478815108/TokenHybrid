//
//  TokenScrollComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/10.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenScrollNode;
@interface TokenScrollComponent : UIScrollView
@property(nonatomic ,weak) TokenScrollNode *associatedNode;
-(void)updateContentSize;
@end
