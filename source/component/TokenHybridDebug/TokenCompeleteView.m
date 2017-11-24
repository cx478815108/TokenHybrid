//
//  TokenCompeleteView.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenCompeleteView.h"

@implementation TokenCompeleteView
- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [titles enumerateObjectsUsingBlock:^(NSString  * obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
            [button setTitle:obj forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
            button.backgroundColor = [UIColor groupTableViewBackgroundColor];
            button.layer.cornerRadius = 4.0f;
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [button setTitleColor:[UIColor darkTextColor] forState:(UIControlStateNormal)];
            [button setTitleColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
            [button setTitleColor:[UIColor redColor] forState:(UIControlStateSelected)];
            [self addSubview:button];
        }];
        self.showsHorizontalScrollIndicator = NO;
    }
    return self;
}

-(void)buttonClick:(UIButton *)button{
    if ([self.clickDelegate respondsToSelector:@selector(compeleteView:didPressedButton:)]) {
        [self.clickDelegate compeleteView:self didPressedButton:button];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    __block CGFloat originX = 6;
    __block CGFloat contentWith = 0;
    [self.subviews enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat btnWidth = obj.intrinsicContentSize.width+4;
        obj.frame = CGRectMake(originX, 5, btnWidth, obj.intrinsicContentSize.height);
        originX += btnWidth+3;
        contentWith = CGRectGetMaxX(obj.frame)+3;
    }];
    self.contentSize = CGSizeMake(contentWith, 0);
}

@end

