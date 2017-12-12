//
//  NSDictionary+chainScript.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/14.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSDictionary+chainScript.h"
#import <UIKit/UIKit.h>

@implementation NSDictionary (chainScript)

-(id)token_chainScript:(NSString *)chainScript
               itemKey:(NSString *)itemKey
                idxKey:(NSString *)idxKey
          forLoopIndex:(NSInteger)loopIndex{
    
    id returnObj;
    //带脚本访问
    if ([chainScript containsString:@"["]) {
        NSMutableArray *chainArray = [chainScript componentsSeparatedByString:@"."].mutableCopy;
        if ([chainScript hasPrefix:itemKey]) { [chainArray removeObjectAtIndex:0];}
         NSInteger i = 0;
        returnObj = self;
        while (i < chainArray.count) {
            NSString *currentKey = chainArray[i];
            //是否带下标
            if ([currentKey hasSuffix:@"]"] && [currentKey containsString:@"["]) {
                //取出数组对应的key
                NSRange leftRange = [currentKey rangeOfString:@"["];
                NSRange rightRange = [currentKey rangeOfString:@"]"];
                NSString *newsingleKeyScript = [currentKey substringToIndex:leftRange.location];
                //取出数组对应的下标
                NSString *indexString = [currentKey substringWithRange:NSMakeRange(leftRange.location+1, rightRange.location-leftRange.location-1)];
                //将returnObj 设置为数组
                returnObj = [returnObj valueForKey:newsingleKeyScript];
                if (![returnObj isKindOfClass:[NSArray class]]) {
                    returnObj = nil;
                    break;
                }
                else {
                    NSInteger realIndex;
                    if ([indexString isEqualToString:idxKey]) {
                        realIndex = loopIndex;
                    }
                    else {
                        realIndex = [indexString integerValue];
                    }
                    NSArray *array = returnObj;
                    if (realIndex > array.count -1 || realIndex < 0) {
                        returnObj = nil;
                        break;
                    }
                    else {
                        //将returnObj 设置为数组第realIndex个坐标
                        returnObj = array[realIndex];
                    }
                }
            }
            else {
                //直接取值
                returnObj = [returnObj valueForKey:currentKey];
            }
            i++;
        }
    }
    else {
        NSString *prefix = [NSString stringWithFormat:@"%@.",itemKey];
        if ([chainScript hasPrefix:prefix]) {
            chainScript = [chainScript stringByReplacingOccurrencesOfString:prefix withString:@""];
        }
        returnObj = [self valueForKeyPath:chainScript];
    }
    return returnObj;
}

-(id)token_chainScript:(NSString *)chainScript
               itemKey:(NSString *)itemKey
                idxKey:(NSString *)idxKey
            sectionKey:(NSString *)sectionKey
             indexPath:(NSIndexPath *)indexPath{
    
    id returnObj;
    //带脚本访问
    if ([chainScript containsString:@"["]) {
        NSMutableArray *chainArray = [chainScript componentsSeparatedByString:@"."].mutableCopy;
        if ([chainScript hasPrefix:itemKey]) { [chainArray removeObjectAtIndex:0];}
        NSInteger i = 0;
        returnObj = self;
        while (i < chainArray.count) {
            NSString *currentKey = chainArray[i];
            //是否带下标
            if ([currentKey hasSuffix:@"]"] && [currentKey containsString:@"["]) {
                //取出数组对应的key
                NSRange leftRange = [currentKey rangeOfString:@"["];
                NSRange rightRange = [currentKey rangeOfString:@"]"];
                NSString *newsingleKeyScript = [currentKey substringToIndex:leftRange.location];
                //取出数组对应的下标
                NSString *indexString = [currentKey substringWithRange:NSMakeRange(leftRange.location+1, rightRange.location-leftRange.location-1)];
                //将returnObj 设置为数组
                returnObj = [returnObj valueForKey:newsingleKeyScript];
                if (![returnObj isKindOfClass:[NSArray class]]) {
                    returnObj = nil;
                    break;
                }
                else {
                    NSInteger realIndex;
                    if ([indexString isEqualToString:idxKey]) {
                        realIndex = indexPath.row;
                    }
                    else if ([indexString isEqualToString:sectionKey]){
                        realIndex = indexPath.section;
                    }
                    else {
                        realIndex = [indexString integerValue];
                    }
                    NSArray *array = returnObj;
                    if (realIndex > array.count -1 || realIndex < 0) {
                        returnObj = nil;
                        break;
                    }
                    else {
                        //将returnObj 设置为数组第realIndex个坐标
                        returnObj = array[realIndex];
                    }
                }
            }
            else {
                //直接取值
                returnObj = [returnObj valueForKey:currentKey];
            }
            i++;
        }
    }
    else {
        NSString *prefix = [NSString stringWithFormat:@"%@.",itemKey];
        if ([chainScript hasPrefix:prefix]) {
            chainScript = [chainScript stringByReplacingOccurrencesOfString:prefix withString:@""];
        }
        returnObj = [self valueForKeyPath:chainScript];
    }
    return returnObj;
}


@end
