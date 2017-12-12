//
//  TokenHybridStack.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TokenHybridStack: NSObject
@property(nonatomic ,assign,readonly) NSInteger count;
-(void)push:(id)obj;
-(id)pop;
-(id)top;
@end
