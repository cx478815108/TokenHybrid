//
//  TokenCompeleteView.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenCompeleteView;
@protocol TokenCompeleteViewDelegate<NSObject>
@optional
-(void)compeleteView:(TokenCompeleteView *)view didPressedButton:(UIButton *)button;
@end

@interface TokenCompeleteView : UIScrollView
@property(nonatomic ,weak) id <TokenCompeleteViewDelegate > clickDelegate;
-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;
@end
