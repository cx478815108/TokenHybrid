//
//  UIColor+FSAdd.m
//  JSONRenderKit
//  Created by 陈雄 on 16/4/4.
//  Copyright © 2016年 com.feelings. All rights reserved.

#import "UIColor+SSRender.h"
#import "TokenExtensionHeader.h"

@interface NSString(SSRender)
- (NSString *)ss_stringByTrim;
@end

@implementation NSString(SSRender)
- (NSString *)ss_stringByTrim
{
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}
@end

@implementation UIColor (SSRender)

// the color exchange code is from YYKit
static inline NSUInteger ss_hexStrToInt(NSString *str)
{
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

// the color exchange code is from YYKit
static BOOL ss_hexStrToRGBA(NSString *str,CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a)
{
    str = [[str ss_stringByTrim] uppercaseString];
    if ([str hasPrefix:@"#"]) { str = [str substringFromIndex:1];}
    else if ([str hasPrefix:@"0X"]) { str = [str substringFromIndex:2];}
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) { return NO;}
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = ss_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = ss_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = ss_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4)  *a = ss_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        else *a = 1;
    } else {
        *r = ss_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = ss_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = ss_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) *a = ss_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        else *a = 1;
    }
    return YES;
}

+(NSArray *)tokenThemColor{
    static NSArray *objs;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        objs = @[
            UIColor.token_RGB(69, 200, 220),  //主题色
            UIColor.token_RGB(167, 213, 154),  //50°灰青色
            UIColor.token_RGB(252, 171, 83),   //橘黄色
            UIColor.token_RGB(140, 136, 255),  //活泼的紫色
            UIColor.token_RGB(80, 210, 194),   //另外一种蓝青色
            UIColor.token_RGB(255, 51, 102),    //品红色
            UIColor.token_RGB(0, 185, 255),     //亮蓝色
            UIColor.token_RGB(248, 232, 28)];   //亮黄色
    });
    return objs;
}

+(instancetype)ss_colorWithString:(NSString *)string
{
    if ([string hasPrefix:@"rgb"]) { return [self ss_colorWithRGBString:string];}
    else if ([string isEqualToString:@"color.randomColor"]){
        return UIColor.token_randomColor();
    }
    else if ([string isEqualToString:@"color.randomThemColor"]){
        NSInteger idx = arc4random()%8;
        return [self tokenThemColor][idx];
    }
    else return [self ss_colorWithHexString:string];
}

+(instancetype)ss_colorWithHexString:(NSString *)hexStr
{
    CGFloat r, g, b, a;
    if (ss_hexStrToRGBA(hexStr, &r, &g, &b, &a)) { return [UIColor colorWithRed:r green:g blue:b alpha:a];}
    return nil;
}

+(instancetype)ss_colorWithRGBString:(NSString *)rgbString
{
    UIColor *color    = nil;
    NSString *testObj = [rgbString lowercaseString];
    if ([testObj hasPrefix:@"rgb("] && [testObj hasSuffix:@")"]) {
        NSString *newStr = [testObj stringByReplacingOccurrencesOfString:@"rgb(" withString:@""];
        newStr           = [newStr  stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *rgbs    = [newStr  componentsSeparatedByString:@","];
        if (rgbs && rgbs.count == 3) {  color = UIColor.token_RGB([rgbs[0] floatValue],
                                                                  [rgbs[1] floatValue],
                                                                  [rgbs[2] floatValue]);
        }
    }
    else if ([testObj hasPrefix:@"rgba("] && [testObj hasSuffix:@")"]) {
        NSString *newStr = [testObj stringByReplacingOccurrencesOfString:@"rgba(" withString:@""];
        newStr           = [newStr  stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *rgbas   = [newStr  componentsSeparatedByString:@","];
        if (rgbas && rgbas.count == 4) { color = UIColor.token_RGBA([rgbas[0] floatValue],
                                                                    [rgbas[1] floatValue],
                                                                    [rgbas[2] floatValue],
                                                                    [rgbas[3] floatValue]);
        }
    }
    return color;
}

@end

