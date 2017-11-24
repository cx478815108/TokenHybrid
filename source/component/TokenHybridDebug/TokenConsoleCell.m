//
//  TokenConsoleCell.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenConsoleCell.h"

@implementation TokenConsoleCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.textLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    return self;
}
@end
