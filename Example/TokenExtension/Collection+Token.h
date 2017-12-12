//
//  NSArray+Token.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSArray *(^TokenArrayInitOperationBlock)(NSArray *array);
typedef NSMutableArray *(^TokenMutableArrayInitOperationBlock)(NSArray *array);
typedef NSMutableArray *(^TokenArrayOperationBlock)(id obj);
typedef NSMutableArray *(^TokenArrayIndexOperationBlock)(NSInteger index);
typedef NSMutableArray *(^TokenArrayAppendOperationBlock)(NSArray* array);
typedef void (^TokenArrayVoidBlock)(void);

@interface NSArray (Token)
@property(nonatomic ,copy ,readonly ,class) TokenArrayInitOperationBlock token_arrayWithArray;
@end

@interface NSMutableArray (Token)
@property(nonatomic ,copy ,readonly ,class) TokenMutableArrayInitOperationBlock token_arrayWithArray;
@property(nonatomic ,copy ,readonly ) TokenArrayOperationBlock                  token_addObject;
@property(nonatomic ,copy ,readonly ) TokenArrayIndexOperationBlock             token_removeObjectAtIndex;
@property(nonatomic ,copy ,readonly ) TokenArrayVoidBlock                       token_removeAllObjects;
@property(nonatomic ,copy ,readonly ) TokenArrayAppendOperationBlock            token_addObjectsFromArray;
@end

typedef NSDictionary *(^TokenDictionaryInitBlock)(NSDictionary *dictionary);
typedef NSMutableDictionary *(^TokenMutableDictionaryInitBlock)(NSDictionary *dictionary);
typedef NSMutableDictionary *(^TokenDictionaryVoidBlock)(void);
typedef NSMutableDictionary *(^TokenDictionaryRemoveBlock)(NSString *key);
typedef NSMutableDictionary *(^TokenDictionaryRemove2Block)(NSArray *array);
typedef NSMutableDictionary *(^TokenDictionarySetBlock)(id<NSCopying> key,id object);

@interface NSDictionary (Token)
@property(nonatomic ,copy ,readonly ,class) TokenDictionaryInitBlock token_dictionaryWithdictionary;
@end

@interface NSMutableDictionary (Token)
@property(nonatomic ,copy ,readonly) TokenDictionaryVoidBlock       token_removeAllObjects;
@property(nonatomic ,copy ,readonly) TokenDictionaryRemoveBlock     token_removeObjectForKey;
@property(nonatomic ,copy ,readonly) TokenDictionaryRemove2Block    token_removeObjectsForKeys;
@property(nonatomic ,copy ,readonly) TokenDictionarySetBlock        token_setObjectForKey;
@end


