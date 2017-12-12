//
//  JSValue+Token.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/3.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "JSValue+Token.h"

@implementation JSValue (Token)
- (BOOL)token_isNilObject {
    return self.isNull || self.isUndefined;
}
@end
