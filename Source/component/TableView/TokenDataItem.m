//
//  TokenDataItem.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenDataItem.h"

@implementation TokenDataItem
+(instancetype)itemWithDataObj:(NSDictionary *)obj
                 customForLoop:(NSDictionary *)customForLoop{
    TokenDataItem *item = [[TokenDataItem alloc] init];
    item.dataObj = obj;
    item.customForLoop = customForLoop;
    return item;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TokenDataItem - [\n%@\n%@\n%@]", self.dataObj,self.customForLoop,self.identify];
}
@end
