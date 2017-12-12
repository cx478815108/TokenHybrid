//
//  UIColor+FSAdd.h
//  JSONRenderKit
//
//  Created by 陈雄 on 16/7/1.
//  Copyright © 2016年 com.feelings. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIColor (SSRender)
+(instancetype)ss_colorWithHexString:(NSString *)hexStr;
+(instancetype)ss_colorWithRGBString:(NSString *)rgbString;
+(instancetype)ss_colorWithString:(NSString *)string;
@end
