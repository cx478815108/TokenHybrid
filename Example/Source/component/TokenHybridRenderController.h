//
//  TokenSSRenderController.h
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TokenViewBuilder.h"
#import "TokenJSContext.h"

@interface TokenHybridRenderController : UIViewController <TokenViewBuilderDelegate,TokenJSContextDelegate>
@property(nonatomic ,assign) BOOL         hiddenTitle;
@property(nonatomic ,assign) BOOL         allowDebug;
@property(nonatomic, copy  ) NSString     *htmlURL;
@property(nonatomic, copy  ) NSString     *htmlPath;
@property(nonatomic ,strong) NSDictionary *extension;
@property(nonatomic ,strong) TokenViewBuilder            *viewBuilder;
@property(nonatomic ,weak  ) TokenHybridRenderController *previousController;

-(instancetype)initWithHTMLURL:(NSString *)htmlURL;
@end
