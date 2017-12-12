//
//  TokenImageView.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/10.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenLabelNode;
@interface TokenImageComponent : UIImageView
@property(nonatomic ,strong) NSString       *componentID;
@property(nonatomic ,strong) NSIndexPath    *indexPath;
@property(nonatomic ,weak  ) TokenLabelNode *associatedNode;
-(void)addTapGestureRecognizer;
@end
