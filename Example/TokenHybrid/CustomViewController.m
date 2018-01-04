//
//  CustomViewController.m
//  TokenHybrid
//
//  Created by 陈雄 on 2018/1/4.
//  Copyright © 2018年 com.feelings. All rights reserved.
//

#import "CustomViewController.h"
#import "TokenHybridRenderView.h"
@interface CustomViewController ()
@property(nonatomic,strong) TokenHybridRenderView *renderView;
@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"校园卡";
    self.view.backgroundColor = [UIColor whiteColor];
    CGRect newRect = CGRectInset(self.view.bounds, 20, 80);
    newRect.origin = CGPointMake(20, 40);
    self.renderView = [[TokenHybridRenderView alloc] initWithFrame:newRect];
    self.renderView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.renderView];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"开始" style:(UIBarButtonItemStylePlain) target:self action:@selector(start)];
}


-(void)start{
    NSString *url = @"https://raw.githubusercontent.com/cx478815108/TokenHybridHTML/master/tokenapp/card/card.html";
    [self.renderView buildViewWithSourceURL:url containerViewController:self childRenderControlllerClass:nil];
}

@end
