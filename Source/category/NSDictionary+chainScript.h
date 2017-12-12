//
//  NSDictionary+chainScript.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/14.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (chainScript)
-(id)token_chainScript:(NSString *)chainScript
               itemKey:(NSString *)itemKey
                idxKey:(NSString *)idxKey
          forLoopIndex:(NSInteger)loopIndex;

-(id)token_chainScript:(NSString *)chainScript
               itemKey:(NSString *)itemKey
                idxKey:(NSString *)idxKey
            sectionKey:(NSString *)sectionKey
             indexPath:(NSIndexPath *)indexPath;
@end
