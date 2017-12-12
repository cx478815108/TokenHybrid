//
//  NSString+Token.m
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/14.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSString+Token.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Token)

+(TokenMathCalculateBlock)token_mathCalculate{
    return ^NSString *(NSString *mathExp){
        NSExpression *expression = [NSExpression expressionWithFormat:mathExp];
        id value = [expression expressionValueWithObject:nil context:nil];
        return [NSString stringWithFormat:@"%@",value];
    };
}

+(TokenMD5Block)token_md5{
    return ^NSString *(NSString *originalString){
        if (originalString == nil || originalString.length == 0) {
            return nil;
        }
        const char *cStr = [originalString UTF8String];
        unsigned char digest[CC_MD5_DIGEST_LENGTH];
        CC_MD5(cStr, (CC_LONG)strlen(cStr), digest); // This is the md5 call
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
        for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
            [output appendFormat:@"%02x", digest[i]];
        }
        return output;
    };
}

-(TokenStringReplaceBlock)token_replace{
    return ^NSString *(NSString *originString, NSString *newString) {
        NSString *temp = [self copy];
        return [temp stringByReplacingOccurrencesOfString:originString withString:newString];
    };
}

-(TokenStringReplaceWithRegExpBlock)token_replaceWithRegExp{
    return ^NSString *(NSString *regExp,NSString *newString) {
        __block NSString *temp = [self copy];
        NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regExp options:0 error:nil];
        NSArray<NSTextCheckingResult *>  *result =  [exp matchesInString:temp options:0 range:NSMakeRange(0, temp.length)];
        [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *stringWillBeReplaced = [self substringWithRange:obj.range];
            temp = [temp stringByReplacingOccurrencesOfString:stringWillBeReplaced withString:newString];
        }];
        return temp;
    };
}

-(TokenStringReplaceWithRegExpCustomStringBlock)token_replaceWithRegExpHigh{
    return ^NSString *(NSString *regExp,TokenStringReplaceWithRegExpMatchBlock newStringGetBlock) {
        __block NSString *temp = [self copy];
        NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:regExp options:0 error:nil];
        NSArray<NSTextCheckingResult *>  *result =  [exp matchesInString:temp options:0 range:NSMakeRange(0, temp.length)];
        [result enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *stringWillBeReplaced = [self substringWithRange:obj.range];
            NSString *newString;
            if (newStringGetBlock) {
                newString = [NSString stringWithFormat:@"%@",newStringGetBlock(stringWillBeReplaced)];
                if (newString) {
                    temp = [temp stringByReplacingOccurrencesOfString:stringWillBeReplaced withString:newString];
                }
            }
        }];
        return temp;
    };
}

+(TokenStringBlock)token_stringfy{
    return  ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@",obj];
    };
}

-(TokenStringParameterBlock)token_append{
    return  ^NSString *(id obj) {
        return [NSString stringWithFormat:@"%@%@",self,obj];
    };
}

-(TokenStringRangeBlock)token_rangeOfString{
    return ^NSRange(NSString *sting) {
        return [self rangeOfString:sting];
    };
}

-(TokenStringBOOLBlock)token_hasPrefix{
    return ^BOOL(NSString *string) {
        return [self hasPrefix:string];
    };
}

-(TokenStringBOOLBlock)token_hasSuffix{
    return ^BOOL(NSString *string) {
        return [self hasSuffix:string];
    };
}

-(TokenStringBOOLBlock)token_containsString{
    return ^BOOL(NSString *string) {
        return [self containsString:string];
    };
}

-(TokenStringBOOL2Block)token_turnBoolStringToBoolValue{
    return ^BOOL() {
        return [self token_stringBoolValue:self];
    };
}

-(BOOL)token_stringBoolValue:(NSString *)string{
    if ([string isEqualToString:@"false"] || [string isEqualToString:@"0"]) { return NO;}
    else if ([string isEqualToString:@"true"] || [string isEqualToString:@"1"]){ return YES;}
    return NO;
}

-(TokenStringDataBlock)token_dataUsingEncoding{
    return ^NSData *(NSStringEncoding encodingType) {
        return [self dataUsingEncoding:encodingType];
    };
}

-(TokenStringSeparatorBlock)token_separator{
    return ^NSArray *(NSString *separator) {
        return [self componentsSeparatedByString:separator];
    };
}

-(TokenStringSeparator2Block)token_separatorUsingSet{
    return ^NSArray *(NSCharacterSet *separatorSet) {
        return [self componentsSeparatedByCharactersInSet:separatorSet];
    };
}

@end
