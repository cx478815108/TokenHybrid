//
//  TokenHybridStack.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenHybridStack.h"

@interface TokenHybridStack()
@property(nonatomic ,strong) NSMutableArray *array;
@end

@implementation TokenHybridStack
- (instancetype)init
{
    self = [super init];
    if (self) {
        _array = @[].mutableCopy;
    }
    return self;
}

-(void)push:(id)obj{
    [_array addObject:obj];
}

-(id)pop{
    id obj;
    if (_array.count) {
        obj = [_array lastObject];
        [_array removeLastObject];
    }
    return obj;
}

-(id)top{
    return [_array lastObject];
}

-(NSInteger)count{
    return _array.count;
}
@end
