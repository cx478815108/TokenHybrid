//
//  TokenHybridRenderView.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/12/12.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenPureComponent.h"

@interface TokenHybridRenderView : TokenPureComponent
@property(nonatomic ,weak) UIViewController *associatedController;
@property(nonatomic, copy) NSString         *sourceURL;
-(void)buildViewWithSourceURL:(NSString *)url
      containerViewController:(UIViewController *)controller
  childRenderControlllerClass:(__unsafe_unretained Class)childClass;
@end
