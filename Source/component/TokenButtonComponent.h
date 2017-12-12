//
//  TokenButtonComponent.h
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/24.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenButtonNode;
@interface TokenButtonComponent : UIButton
@property(nonatomic ,weak  ) TokenButtonNode *associatedNode;
@property(nonatomic ,strong) NSString        *componentID;
@property(nonatomic ,strong) NSIndexPath     *indexPath;
@property(nonatomic ,strong) UIColor         *selectedBackgroundColor;
+(instancetype)buttonWithTypeString:(NSString *)type
                              title:(NSString *)title;
@end
