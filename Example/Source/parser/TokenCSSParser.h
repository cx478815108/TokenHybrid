//
//  TokenCSSParser.h
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/19.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class TokenXMLNode;
@interface TokenCSSParser : NSObject
+(NSDictionary *)converAttrStringToDictionary:(NSString *)attrString
                           containerViewWidth:(CGFloat)containerViewWidth
                          containerViewHeight:(CGFloat)containerViewHeight;

+(NSDictionary *)parserCSSWithString:(NSString *)cssString
                  containerViewWidth:(CGFloat)containerViewWidth
                 containerViewHeight:(CGFloat)containerViewHeight;

//将CSS 选择器和 node进行匹配
+(NSSet <TokenXMLNode *> *)matchNodesWithRootNode:(TokenXMLNode *)node selector:(NSString *)selector;
@end
