//
//  TokenConsolePushView.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenConsolePushView.h"
@interface TokenConsolePushView()
@end

@implementation TokenConsolePushView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textView                 = [[UITextView alloc] init];
        self.textView.editable        = NO;
        self.textView.selectable      = YES;
        self.textView.font            = [UIFont systemFontOfSize:14.0f];
        self.textView.textColor       = [UIColor darkTextColor];
        self.textView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backButton               = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.backButton setTitle:@"返回" forState:(UIControlStateNormal)];
        [self.backButton setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
        self.backButton.backgroundColor    = [UIColor groupTableViewBackgroundColor];
        self.backButton.layer.cornerRadius = 4;
        [self addSubview:self.textView];
        [self addSubview:self.backButton];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backButton.frame = CGRectMake(8, 6, 40, 30);
    self.textView.frame   = CGRectMake(0, 40, self.frame.size.width, self.frame.size.height-40);
}
@end

