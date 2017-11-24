//
//  TokenConsoleView.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenConsoleView;
@protocol TokenConsoleViewClickDelagate <NSObject>
@optional
-(void)consoleView:(TokenConsoleView *)consoleView didSelectedRow:(NSInteger)row;
@end
@interface TokenConsoleView : UITableView
@property(nonatomic ,strong) NSArray *dataObjs;
@property(nonatomic, weak  ) id<TokenConsoleViewClickDelagate> clickDelegate;
@end
