//
//  TokenConsoleView.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenConsoleView.h"
#import "TokenConsoleCell.h"

@interface TokenConsoleView()<UITableViewDataSource,UITableViewDelegate>
@end

@implementation TokenConsoleView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        [self registerClass:[TokenConsoleCell class] forCellReuseIdentifier:@"TokenConsoleCell"];
        self.tableFooterView = [[UIView alloc] init];
        self.delegate        = self;
        self.dataSource      = self;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataObjs.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TokenConsoleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TokenConsoleCell" forIndexPath:indexPath];
    NSString *logInfo      = [NSString stringWithFormat:@"%@",self.dataObjs[indexPath.row]];
    cell.textLabel.text    = logInfo;
    if([logInfo containsString:@"\n"]) {
        cell.textLabel.text = @"点击查看详情";
    }
    if ([logInfo hasPrefix:@"错误"]) {
        cell.textLabel.textColor = [UIColor redColor];
    }
    else{
        cell.textLabel.textColor = [UIColor darkGrayColor];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.clickDelegate respondsToSelector:@selector(consoleView:didSelectedRow:)]) {
        [self.clickDelegate consoleView:self didSelectedRow:indexPath.row];
    }
}

@end

