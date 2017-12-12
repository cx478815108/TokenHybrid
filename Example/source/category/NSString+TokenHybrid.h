//
//  NSString+TokenHybrid.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TokenHybrid)
+(NSString *)token_completeRelativeURLString:(NSString *)relativeString
                       withAbsoluteURLString:(NSString *)absoluteString;
@end
