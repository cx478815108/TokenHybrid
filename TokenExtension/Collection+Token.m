//
//  NSArray+Token.m
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "Collection+Token.h"

@implementation NSArray (Token)
+(TokenArrayInitOperationBlock)token_arrayWithArray{
    return ^NSArray *(NSArray *array) {
        return [self arrayWithArray:array];
    };
}
@end

@implementation NSMutableArray (Token)
-(TokenArrayVoidBlock)token_removeAllObjects{
    return ^{
        [self removeAllObjects];
    };
}

-(TokenArrayOperationBlock)token_addObject{
    return ^NSMutableArray *(id obj) {
        [self addObject:obj];
        return self;
    };
}

-(TokenArrayIndexOperationBlock)token_removeObjectAtIndex{
    return ^NSMutableArray *(NSInteger index) {
        [self removeObjectAtIndex:index];
        return self;
    };
}

-(TokenArrayAppendOperationBlock)token_addObjectsFromArray{
    return ^NSMutableArray *(NSArray *array) {
        [self addObjectsFromArray:array];
        return self;
    };
}
@end

@implementation NSDictionary (Token)
+(TokenDictionaryInitBlock)token_dictionaryWithdictionary{
    return ^NSDictionary *(NSDictionary *array) {
        return [self dictionaryWithDictionary:array];
    };
}
@end

@implementation NSMutableDictionary (Token)
-(TokenDictionaryVoidBlock)token_removeAllObjects{
    return ^NSMutableDictionary *(void) {
        [self removeAllObjects];
        return self;
    };
}

-(TokenDictionaryRemoveBlock)token_removeObjectForKey{
    return  ^NSMutableDictionary *(NSString *key) {
        [self removeObjectForKey:key];
        return self;
    };
}

-(TokenDictionaryRemove2Block)token_removeObjectsForKeys{
    return ^NSMutableDictionary *(NSArray *array) {
        [self removeObjectsForKeys:array];
        return self;
    };
}

-(TokenDictionarySetBlock)token_setObjectForKey{
    return ^NSMutableDictionary *(id<NSCopying> key, id object) {
        [self setObject:object forKey:key];
        return self;
    };
}

@end


