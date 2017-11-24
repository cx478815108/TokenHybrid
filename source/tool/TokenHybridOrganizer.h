//
//  TokenHybridOrganizer.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TokenNodeComponentRegister,TokenViewBuilder,TokenHybridRenderController;
@import UIKit;
@interface TokenHybridOrganizer : NSObject
@property(nonatomic ,strong) TokenNodeComponentRegister  *nodeComponentRegister;
@property(nonatomic ,weak  ) TokenViewBuilder            *currentViewBuilder;
@property(nonatomic ,weak  ) TokenHybridRenderController *currentViewController;
+(TokenHybridOrganizer *)sharedOrganizer;
-(void)addPageDefaultWithSuiteName:(NSString *)name;
-(void)clearAllPageDefaultsData;
@end
