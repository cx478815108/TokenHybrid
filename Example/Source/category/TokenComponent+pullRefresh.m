//
//  TokenComponent+TokenHybrid.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/28.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenComponent+pullRefresh.h"
#import "TokenJSContext.h"
#import "MJRefresh.h"
#import "TokenXMLNode.h"

@implementation UIView (Refresh)
-(void)token_hiddenHeaderRefreshWithScrollView:(__kindof UIScrollView *)scrollView{
    scrollView.mj_header.hidden = YES;
    [scrollView.mj_header removeFromSuperview];
    scrollView.mj_header = nil;
}

-(void)token_hiddenFooterRefreshWithScrollView:(__kindof UIScrollView *)scrollView{
    scrollView.mj_footer.hidden = YES;
    [scrollView.mj_footer removeFromSuperview];
    scrollView.mj_footer = nil;
}

-(void)token_stopHeaderRefreshWithScrollView:(__kindof UIScrollView *)scrollView{
    [scrollView.mj_header endRefreshing];
}

-(void)token_stopFooterRefreshWithScrollView:(__kindof UIScrollView *)scrollView{
    [scrollView.mj_footer endRefreshing];
}

-(void)token_openHeaderRefreshWithScrollView:(__kindof UIScrollView *)scrollView{
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(token_didPullHeaderRefresh)];
    header.stateLabel.hidden = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    scrollView.mj_header = header;
}

-(void)token_openFooterRefreshWithScrollView:(__kindof UIScrollView *)scrollView{
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(token_didPullFooterRefresh)];
    footer.stateLabel.hidden = YES;
    scrollView.mj_footer = footer;
}

-(void)token_didPullFooterRefresh{}

-(void)token_didPullHeaderRefresh{}

@end

#pragma mark - pullRefresh
@implementation TokenTableComponent (TokenHybrid)
-(void)openHeaderRefresh{
    [self token_openHeaderRefreshWithScrollView:self.tableView];
}

-(void)stopHeaderRefresh{
    [self token_stopHeaderRefreshWithScrollView:self.tableView];
}

-(void)hiddenHeaderRefresh{
    [self token_hiddenHeaderRefreshWithScrollView:self.tableView];
}

-(void)openFooterRefresh{
    [self token_openFooterRefreshWithScrollView:self.tableView];
}

-(void)stopFooterRefresh{
    [self token_stopFooterRefreshWithScrollView:self.tableView];
}

-(void)hiddenFooterRefresh{
    [self token_hiddenFooterRefreshWithScrollView:self.tableView];
}

-(void)token_didPullFooterRefresh{
    if (self.associatedNode.onFooterRefresh) {
        [self.associatedNode.onFooterRefresh.value callWithArguments:nil];
    }
}

-(void)token_didPullHeaderRefresh{
    if (self.associatedNode.onHeaderRefresh) {
        [self.associatedNode.onHeaderRefresh.value callWithArguments:nil];
    }
}

@end

@implementation TokenScrollComponent (TokenHybrid)
-(void)openHeaderRefresh{
    [self token_openHeaderRefreshWithScrollView:self];
}

-(void)stopHeaderRefresh{
    [self token_stopHeaderRefreshWithScrollView:self];
}

-(void)hiddenHeaderRefresh{
    [self token_hiddenHeaderRefreshWithScrollView:self];
}

-(void)openFooterRefresh{
    [self token_openFooterRefreshWithScrollView:self];
}

-(void)stopFooterRefresh{
    [self token_stopFooterRefreshWithScrollView:self];
}

-(void)hiddenFooterRefresh{
    [self token_hiddenFooterRefreshWithScrollView:self];
}

-(void)token_didPullFooterRefresh{
    if (self.associatedNode.onFooterRefresh) {
        [self.associatedNode.onFooterRefresh.value callWithArguments:nil];
    }
}

-(void)token_didPullHeaderRefresh{
    if (self.associatedNode.onHeaderRefresh) {
        [self.associatedNode.onHeaderRefresh.value callWithArguments:nil];
    }
}
@end

@implementation TokenWebViewComponent (TokenHybrid)
-(void)openHeaderRefresh{
    [self token_openHeaderRefreshWithScrollView:self.webView.scrollView];
}

-(void)stopHeaderRefresh{
    [self token_stopHeaderRefreshWithScrollView:self.webView.scrollView];
}

-(void)hiddenHeaderRefresh{
    [self token_hiddenHeaderRefreshWithScrollView:self.webView.scrollView];
}

-(void)openFooterRefresh{
    [self token_openFooterRefreshWithScrollView:self.webView.scrollView];
}

-(void)stopFooterRefresh{
    [self token_stopFooterRefreshWithScrollView:self.webView.scrollView];
}

-(void)hiddenFooterRefresh{
    [self token_hiddenFooterRefreshWithScrollView:self.webView.scrollView];
}
-(void)token_didPullFooterRefresh{
    if (self.associatedNode.onFooterRefresh) {
        [self.associatedNode.onFooterRefresh.value callWithArguments:nil];
    }
}

-(void)token_didPullHeaderRefresh{
    if (self.associatedNode.onHeaderRefresh) {
        [self.associatedNode.onHeaderRefresh.value callWithArguments:nil];
    }
}
@end


