//
//  TokenHybridRenderView.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/12/12.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenPureComponent.h"
#import "TokenViewBuilder.h"
#import "TokenJSContext.h"

@interface TokenHybridRenderView : TokenPureComponent <TokenViewBuilderDelegate,TokenJSContextDelegate>
@property(nonatomic ,weak) UIViewController *associatedController;
@property(nonatomic, copy) NSString         *sourceURL;
-(void)buildViewWithSourceURL:(NSString *)url
      containerViewController:(UIViewController *)controller
  childRenderControlllerClass:(__unsafe_unretained Class)childClass;
@end
