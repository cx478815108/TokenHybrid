//
//  TokenHybridDebugView.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenHybridDebugView;
@protocol TokenHybridDebugViewDelegate<NSObject>
-(void)debugView:(TokenHybridDebugView *)debugView didPressExcuseButtonWithScript:(NSString *)script;
@end

@interface TokenHybridDebugView : UIView
@property(nonatomic ,strong) UITextField *filed;
@property(nonatomic ,weak  ) id <TokenHybridDebugViewDelegate> delegate;
-(void)reloadData:(NSArray *)data;
-(void)addLog:(NSString *)log;
-(void)clear;
-(void)scrollToBottom;
@end
