//
//  TokenCSSParser.m
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/19.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenCSSParser.h"
#import "TokenXMLNode.h"
#import "TokenExtensionHeader.h"
#import "UIView+Attributes.h"

@import UIKit;
@implementation TokenCSSParser

+(NSDictionary *)converAttrStringToDictionary:(NSString *)attrString
{
    NSMutableArray <NSString *> *ruleStringArray = [NSMutableArray arrayWithArray:attrString.token_replace(@"\t",@"").token_replace(@"px",@"").token_separator(@";")];
    if ([ruleStringArray containsObject:@""]) {
        [ruleStringArray removeObject:@""];
    }
    
    NSMutableDictionary *rules = @{}.mutableCopy;
    [ruleStringArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //取出两端的空格
        if ([obj hasPrefix:@" "] || [obj hasSuffix:@" "]) {
            obj = [obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        }
        NSArray *oneRule = obj.token_separator(@":");
        if (oneRule.count == 2) {
            NSString *key = oneRule[0];
            if ([key hasPrefix:@" "] || [key hasSuffix:@" "]) {
                key = [key stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            NSString *value = oneRule[1];
            if ([value hasPrefix:@" "] || [value hasSuffix:@" "]) {
                value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            //支持calc函数
            if ([value containsString:@"calc"]) {
                // NSString *value = @"(calc(30%H-60),20),(100,200))";
                if ([value containsString:@"%H"]) {
                    value = value.token_replaceWithRegExpHigh(@"[\\d.]+%H", ^NSString *(NSString *matchString) {
                        CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
                        NSString *newString = [NSString stringWithFormat:@"%@/100.000*%@",
                                                       matchString.token_replace(@"%H",@""),
                                                       @(screenW)];
                        return NSString.token_mathCalculate(newString);
                    });
                }
                if ([value containsString:@"%V"]) {
                    value = value.token_replaceWithRegExpHigh(@"[\\d.]+%V", ^NSString *(NSString *matchString) {
                        CGFloat screenH = [UIView token_screenVisibleHeight];
                        NSString *newString = [NSString stringWithFormat:@"%@/100.000*%@",
                                               matchString.token_replace(@"%V",@""),
                                               @(screenH)];
                        return NSString.token_mathCalculate(newString);
                    });
                }
                value = value.token_replaceWithRegExpHigh(@"calc(\\(.*?\\))", ^NSString *(NSString *matchString) {
                    NSString *trimString = matchString.token_replace(@"calc(",@"").token_replace(@")",@"");
                    return NSString.token_mathCalculate(trimString);
                });
            }

            [rules setObject:value forKey:key];
        }
    }];
    return rules;
}

+(NSDictionary *)parserCSSWithString:(NSString *)cssString{
    if (cssString == nil) return @{};
    NSMutableDictionary *styleSheets = @{}.mutableCopy;
    NSString *commentRegExp = @"(?<!:)\\/\\/.*|\\/\\*(\\s|.)*?\\*\\/";
    //去掉CSS里面的评论
    NSString *css = cssString.token_replaceWithRegExp(commentRegExp,@"")
                             .token_replace(@"\n",@"")
                             .token_replace(@"\r",@"")
                             .token_replace(@"\t",@"");
    int braceMarker = 0;
    NSString *selector;
    NSString *rule;
    for (int i = 0; i < css.length; i ++) {
        unichar c = [css characterAtIndex:i];
        if (c == '{') {
            selector = [css substringWithRange:NSMakeRange(braceMarker, i-braceMarker)];
            braceMarker = i + 1;
        }
        if (c == '}') {
            rule = [css substringWithRange:NSMakeRange(braceMarker, i-braceMarker)];
            braceMarker = i + 1;
            if (selector.length && rule.length) {
                NSDictionary *dic = [self converAttrStringToDictionary:rule];
                if ([selector hasPrefix:@" "] || [selector hasSuffix:@" "]) {
                    selector = [selector stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                [styleSheets setObject:dic forKey:selector];
            }
        }
    }
    return styleSheets;
}

#pragma mark -
+(NSSet <TokenXMLNode *> *)matchNodesWithRootNode:(TokenXMLNode *)node selector:(NSString *)selector{
    //去掉两端空格
    if ([selector hasPrefix:@" "]) {
        selector = [selector stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
    //用空格分割
    NSMutableArray *selectors = NSMutableArray.token_arrayWithArray(selector.token_separator(@" "));
    if ([selectors containsObject:@""]) {
        [selectors removeObject:@""];
    }
    
    NSMutableSet <TokenXMLNode *> *matchNodeSet = [NSMutableSet set];
    //先产生一个基本集合
    [TokenXMLNode enumerateTreeFromRootToChildWithNode:node block:^(TokenXMLNode *node ,BOOL *stop) {
        [matchNodeSet addObject:node];
    }];
    //对selector 从右往左开始匹配
    for (NSInteger i = selectors.count - 1 ; i>= 0; i--) {
        NSString *selector = selectors[i];
        NSMutableSet *matchNodeSetCopy = [NSMutableSet setWithSet:matchNodeSet];
        [matchNodeSet enumerateObjectsUsingBlock:^(TokenXMLNode * node, BOOL * _Nonnull stop) {
            //id 选择器
            if ([selector hasPrefix:@"#"]) {
                if (![node.innerAttributes[@"id"] isEqualToString:[selector substringWithRange:NSMakeRange(1, selector.length-1)]]) {
                    [matchNodeSetCopy removeObject:node];
                }
            }
            else if ([selector hasPrefix:@"."]) {
                NSString *nodeClass = node.innerAttributes[@"class"];
                NSString *selectorToBeMatched = [selector substringWithRange:NSMakeRange(1, selector.length-1)];
                if ([nodeClass containsString:@" "]) {//包含多个类
                    NSArray *nodeClassArray = [nodeClass componentsSeparatedByString:@" "];
                    if (![nodeClassArray containsObject:selectorToBeMatched]) {
                        [matchNodeSetCopy removeObject:node];
                    }
                }
                else {
                    //不包含多个类
                    if (![nodeClass isEqualToString:[selector substringWithRange:NSMakeRange(1, selector.length-1)]]) {
                        [matchNodeSetCopy removeObject:node];
                    }
                }
            }
            
            else {
                if (i == selectors.count-1) {
                    if (![node.name isEqualToString:selector]) {
                        [matchNodeSetCopy removeObject:node];
                    }
                }
                else {
                    BOOL nodeMatchd = NO;
                    //开始向上匹配父节点
                    TokenXMLNode *currentNode = node;
                    while (currentNode.parentNode) {
                        //匹配到父节点
                        if ([currentNode.name isEqualToString:selector]) {
                            nodeMatchd = YES;
                            break;
                        }
                        currentNode = currentNode.parentNode;
                    }
                    if (!nodeMatchd) {
                        [matchNodeSetCopy removeObject:node];
                    }
                }
            }
        }];
        matchNodeSet = matchNodeSetCopy;
    }
    return matchNodeSet;
}
@end
