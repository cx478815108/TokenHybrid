//
//  TokenNodeComponentRegister.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/5.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@class TokenXMLNode;

typedef __kindof UIView *(^TokenHybridComponentCreatBlock)(__kindof TokenXMLNode *node);

@interface TokenHybridRegisterModel : NSObject
@property(nonatomic ,copy  ) NSString *nodeTagName;
@property(nonatomic ,copy  ) NSString *nodeClassName;
@property(nonatomic ,assign) NSString *nativeComponentClassName;
@property(nonatomic ,assign) BOOL      customInit;
@property(nonatomic ,copy  ) TokenHybridComponentCreatBlock creatProcess;

-(instancetype)initWithNodeTagName:(NSString *)nodeTagName
                     nodeClassName:(NSString *)nodeClassName
          nativeComponentClassName:(NSString *)nativeComponentClassName
                      creatProcess:(TokenHybridComponentCreatBlock)creatProcess;
-(__kindof TokenXMLNode *)creatNode;
-(__kindof UIView *)creatNativeComponentWithNode:(__kindof TokenXMLNode *)node;
@end

@interface TokenNodeComponentRegister : NSObject
-(void)registDefault;
-(void)registComponentWithModel:(TokenHybridRegisterModel *)model;
-(TokenHybridRegisterModel *)getRegisterModelWithNodeTagName:(NSString *)nodeTagName;
@end
