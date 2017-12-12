//
//  TokenComponent+TokenHybrid.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/28.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenTableComponent.h"
#import "TokenScrollComponent.h"
#import "TokenWebViewComponent.h"

@protocol TokenPullRefreshProtocol <NSObject>
@optional
-(void)openHeaderRefresh;
-(void)stopHeaderRefresh;
-(void)hiddenHeaderRefresh;
-(void)openFooterRefresh;
-(void)stopFooterRefresh;
-(void)hiddenFooterRefresh;
@end

@interface TokenTableComponent (TokenHybrid) <TokenPullRefreshProtocol>

@end

@interface TokenScrollComponent (TokenHybrid) <TokenPullRefreshProtocol>

@end

@interface TokenWebViewComponent (TokenHybrid) <TokenPullRefreshProtocol>

@end







