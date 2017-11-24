//
//  NSString+TokenHybrid.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "NSString+TokenHybrid.h"

@implementation NSString (TokenHybrid)
+(NSString *)token_completeRelativeURLString:(NSString *)relativeString
                       withAbsoluteURLString:(NSString *)absoluteString
{
    if ([relativeString hasPrefix:@"http"]) { return relativeString;}
    NSURL *absoluteURL = [NSURL URLWithString:absoluteString];
    if (absoluteURL.scheme == nil) { return relativeString;}
    
    NSInteger backtrackingCount = 0;
    NSString *tempString = relativeString;
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:absoluteString.pathComponents];
    while ([tempString containsString:@"../"]) {
        backtrackingCount += 1;
        NSRange replaceRange = [tempString rangeOfString:@".." options:(NSBackwardsSearch)];
        NSInteger addPathIndex = (pathComponents.count - 1) - (backtrackingCount + 1);
        if (pathComponents.count - 1 > addPathIndex) {
            tempString = [tempString stringByReplacingCharactersInRange:replaceRange withString:pathComponents[addPathIndex]];
        }
    }
    
    NSInteger location = pathComponents.count-tempString.pathComponents.count;
    NSMutableString *finalURLString = [NSMutableString stringWithString:absoluteURL.scheme];
    if (location >= 0 && tempString.pathComponents.count <= pathComponents.count) {
        [pathComponents replaceObjectsInRange:NSMakeRange(pathComponents.count-tempString.pathComponents.count, tempString.pathComponents.count) withObjectsFromArray:tempString.pathComponents];
        [pathComponents removeObjectAtIndex:0];
        
        NSString *finalPathString = [NSString pathWithComponents:pathComponents];
        [finalURLString appendString:@"://"];
        if (absoluteURL.port) {
            [finalURLString appendFormat:@":%@",absoluteURL.port];
        }
        [finalURLString appendString:finalPathString];
        return finalURLString;
    }
    return finalURLString;
}
@end
