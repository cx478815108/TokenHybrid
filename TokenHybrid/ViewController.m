//
//  ViewController.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "ViewController.h"
#import "TokenHybridRenderController.h"
#import "UIColor+Token.h"

@import JavaScriptCore;
@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Funny";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = UIColor.token_RGB(70,200,220);
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.whiteColor}];
    [self.navigationController.navigationBar setTintColor:UIColor.whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)button1Pressed:(id)sender {
    NSString *url = @"https://coding.net/u/cx478815108/p/TokenDynamicApp-public/git/raw/master/examsEnter/examples.html";
    TokenHybridRenderController *obj = [[TokenHybridRenderController alloc] initWithHTMLURL:url];
    [self.navigationController pushViewController:obj animated:YES];
}

@end
