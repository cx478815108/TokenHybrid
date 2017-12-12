//
//  TokenPageControl.h
//  MyWHUT
//
//  Created by 陈雄 on 2017/11/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenDotsNode;
@interface TokenPageControl : UIPageControl
@property(nonatomic ,weak) TokenDotsNode *associatedNode;
@end
