//
//  TokenPureComponent.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/9.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenXMLNode;
@interface TokenPureComponent : UIView
@property(nonatomic ,weak) TokenXMLNode *associatedNode;
-(void)applyFlexLayout;
-(void)didApplyAllAttributs;
@end

@interface TokenTableHeaderComponent : TokenPureComponent
@end

@interface TokenTableFooterComponent : TokenPureComponent
@end
