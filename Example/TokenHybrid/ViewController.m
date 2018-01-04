//
//  ViewController.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "ViewController.h"
#import "TokenHybridRenderController.h"
#import "TokenHybridOrganizer.h"
#import "CustomViewController.h"
#import "UIColor+Token.h"

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        NSString *url = @"https://raw.githubusercontent.com/cx478815108/TokenHybridHTML/master/examsEnter/examples.html";
        TokenHybridRenderController *obj = [[TokenHybridRenderController alloc] initWithHTMLURL:url];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (indexPath.row == 1) {
        CustomViewController *obj = [[CustomViewController alloc] init];
        [self.navigationController pushViewController:obj animated:YES];
    }
    else if (indexPath.row == 2) {
        [[TokenHybridOrganizer sharedOrganizer] clearAllPageDefaultsData];
    }
}

@end
