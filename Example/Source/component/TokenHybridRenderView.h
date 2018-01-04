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

/**
 根据URL构建原生视图

 @param url 远程URL
 @param controller 当前view所在的视图
 @param childClass 推送到下一个试图控制器，必须是TokenHybridRenderController的子类
 */
-(void)buildViewWithSourceURL:(NSString *)url
      containerViewController:(UIViewController *)controller
  childRenderControlllerClass:(__unsafe_unretained Class)childClass;
@end
