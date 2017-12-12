//
//  TokenSearchBarComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/30.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenSearchBarNode;
@interface TokenSearchBarComponent : UISearchBar
@property(nonatomic ,weak) TokenSearchBarNode *associatedNode;
@end
