//
//  TokenTableSectionView.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenXMLNode,TokenPureNode,TokenDataItem;
@interface TokenTableSectionView : UITableViewHeaderFooterView
@property(nonatomic ,assign) NSInteger section;
@property(nonatomic ,strong) TokenDataItem *dataItem;
@property(nonatomic ,weak  ) TokenPureNode *associatedNode;
+(NSString *)reuseIdentifier;
-(void)configHierarchyWithNode:(TokenXMLNode *)node;
@end
