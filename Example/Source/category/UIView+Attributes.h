//
//  UIView+Attributes.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/9.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TokenXMLNode;
typedef void(^UIViewEnumerateBlock)(__kindof UIView *view,BOOL *stop);
@interface UIView (Attributes)
-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes;
-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary;
-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes
                                  shouldLayout:(BOOL)shouldLayout;
+(void)token_enumerateViewFromRootToChildWithRootView:(UIView *)rootView
                                                block:(UIViewEnumerateBlock)block;
+(__kindof UIView *)token_produceViewWithNode:(TokenXMLNode *)node;
@end
