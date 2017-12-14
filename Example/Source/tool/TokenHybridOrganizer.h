//
//  TokenHybridOrganizer.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TokenNodeComponentRegister,TokenViewBuilder,TokenHybridRenderController,TokenHybridRenderView;
@import UIKit;
@interface TokenHybridOrganizer : NSObject
@property(nonatomic ,strong) TokenNodeComponentRegister  *nodeComponentRegister;
@property(nonatomic ,weak  ) TokenViewBuilder            *currentViewBuilder;
@property(nonatomic ,weak  ) TokenHybridRenderController *currentViewController;
@property(nonatomic ,weak  ) TokenHybridRenderView       *currentView;
@property(nonatomic ,assign) BOOL                        renderInView;
+(TokenHybridOrganizer *)sharedOrganizer;
-(void)addPageDefaultWithSuiteName:(NSString *)name;
-(void)clearAllPageDefaultsData;
@end
