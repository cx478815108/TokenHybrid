//
//  TokenTableCell.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenXMLNode,TokenDataItem;
@interface TokenTableCell : UITableViewCell
@property(nonatomic ,strong) NSIndexPath *indexPath;
@property(nonatomic ,strong) TokenDataItem *dataItem;
+(NSString *)reuseIdentifier;
-(void)configHierarchyWithNode:(TokenXMLNode *)node;
@end
