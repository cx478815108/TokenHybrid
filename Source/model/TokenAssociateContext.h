//
//  TokenAssociateContext.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/12/19.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenHybridRenderController,TokenHybridRenderView,TokenJSContext,TokenViewBuilder;
@interface TokenAssociateContext : NSObject
@property(nonatomic ,weak  ) TokenHybridRenderController *currentAssociateController;
@property(nonatomic ,weak  ) TokenHybridRenderView       *currentAssociateView;
@property(nonatomic ,weak  ) TokenViewBuilder            *currentAssociateViewBuilder;
@property(nonatomic ,assign) Class                       associateViewPushControllerClass;
@end
