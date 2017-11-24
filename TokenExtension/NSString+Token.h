//
//  NSString+Token.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/14.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString *(^TokenStringAppendBlock)(NSString *appendString);
typedef NSString *(^TokenStringReplaceBlock)(NSString *originString,NSString *newString);
typedef NSString * (^TokenStringReplaceWithRegExpMatchBlock)(NSString *matchString);
typedef NSString *(^TokenStringReplaceWithRegExpBlock)(NSString *regExp,NSString *newString);
typedef NSString *(^TokenStringReplaceWithRegExpCustomStringBlock)(NSString *regExp,TokenStringReplaceWithRegExpMatchBlock newStringGetBlock);
typedef NSString *(^TokenStringBlock)(id obj);
typedef NSString *(^TokenStringParameterBlock)(id obj);
typedef NSRange   (^TokenStringRangeBlock)(NSString *sting);
typedef NSData   *(^TokenStringDataBlock)(NSStringEncoding encodingType);
typedef NSArray  *(^TokenStringSeparatorBlock)(NSString *separator);
typedef NSArray  *(^TokenStringSeparator2Block)(NSCharacterSet *separatorSet);
typedef BOOL      (^TokenStringBOOLBlock)(NSString *sting);
typedef BOOL      (^TokenStringBOOL2Block)(void);
typedef NSString *(^TokenMathCalculateBlock)(NSString *mathExp);
typedef NSString *(^TokenMD5Block)(NSString *originalString);


@interface NSString (Token)
@property(nonatomic ,copy ,readonly ,class) TokenMathCalculateBlock token_mathCalculate;
@property(nonatomic ,copy ,readonly ,class) TokenMD5Block token_md5;
@property(nonatomic ,copy ,readonly ,class) TokenStringBlock    token_stringfy;
@property(nonatomic ,copy ,readonly) TokenStringParameterBlock  token_append;
@property(nonatomic ,copy ,readonly) TokenStringReplaceBlock    token_replace;
@property(nonatomic ,copy ,readonly) TokenStringRangeBlock      token_rangeOfString;
@property(nonatomic ,copy ,readonly) TokenStringBOOLBlock       token_hasPrefix;
@property(nonatomic ,copy ,readonly) TokenStringBOOLBlock       token_hasSuffix;
@property(nonatomic ,copy ,readonly) TokenStringBOOLBlock       token_containsString;
@property(nonatomic ,copy ,readonly) TokenStringBOOL2Block      token_turnBoolStringToBoolValue;
@property(nonatomic ,copy ,readonly) TokenStringDataBlock       token_dataUsingEncoding;
@property(nonatomic ,copy ,readonly) TokenStringSeparatorBlock  token_separator;
@property(nonatomic ,copy ,readonly) TokenStringSeparator2Block token_separatorUsingSet;
@property(nonatomic ,copy ,readonly) TokenStringReplaceWithRegExpBlock token_replaceWithRegExp;
@property(nonatomic ,copy ,readonly) TokenStringReplaceWithRegExpCustomStringBlock token_replaceWithRegExpHigh;
@end
