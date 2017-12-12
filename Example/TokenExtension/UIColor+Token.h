//
//  UIColor+Token.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIColor *(^TokenRandomColorBlock)(void);
typedef UIColor *(^TokenStringColorBlock)(void);
typedef UIColor *(^TokenColorCGFloat3Block)(CGFloat value1 ,CGFloat value2 ,CGFloat value3);
typedef UIColor *(^TokenColorCGFloat4Block)(CGFloat value1 ,CGFloat value2 ,CGFloat value3 ,CGFloat value4);

@interface UIColor (Token)
@property(nonatomic ,copy ,readonly ,class) TokenColorCGFloat4Block token_RGBA;
@property(nonatomic ,copy ,readonly ,class) TokenColorCGFloat3Block token_RGB;
@property(nonatomic ,copy ,readonly ,class) TokenRandomColorBlock   token_randomColor;

@end
