//
//  TokenTableComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenXMLNode,TokenTableNode;
@interface TokenTableComponent : UIView
@property(nonatomic ,strong) TokenTableNode *associatedNode;
@property(nonatomic ,strong) UITableView *tableView;
-(instancetype)initWithConfigNode:(TokenXMLNode *)configNode;
-(void)reloadData:(NSArray *)dataArray;
-(void)scrollToTop:(BOOL)animate;
@end
