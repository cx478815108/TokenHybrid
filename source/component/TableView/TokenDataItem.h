//
//  TokenDataItem.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenDataItem : NSObject
@property(nonatomic ,copy) NSString *identify;
@property(nonatomic ,strong) NSDictionary *dataObj;
@property(nonatomic ,strong) NSDictionary *customForLoop;
+(instancetype)itemWithDataObj:(NSDictionary *)obj
                 customForLoop:(NSDictionary *)customForLoop;
@end
