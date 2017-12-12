//
//  TokenScrollComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/10.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenScrollComponent.h"
#import "UIView+Attributes.h"
#import "TokenHybridConstant.h"
#import "NSString+Token.h"
#import "TokenXMLNode.h"

@interface TokenScrollComponent()<UIScrollViewDelegate>
@end

@implementation TokenScrollComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveRootComponentApplyLayoutNitification) name:TokenHybridComponentDidApplyLayoutNotification
                                                   object:nil];
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.delegate = self;
        if (@available(iOS 11, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

-(void)didReceiveRootComponentApplyLayoutNitification{
    [self updateContentSize];
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    [super token_updateAppearanceWithNormalDictionary:dictionary];
    NSDictionary *d = dictionary;
    NSString *showHBar = d[@"showHBar"];
    if (showHBar)    {
        self.showsHorizontalScrollIndicator = showHBar.token_turnBoolStringToBoolValue();
    }

    NSString *showVBar = d[@"showVBar"];
    if (showVBar)    {
        self.showsVerticalScrollIndicator = showVBar.token_turnBoolStringToBoolValue();
    }

    NSString *allowScroll = d[@"allowScroll"];
    if (allowScroll) {
        self.scrollEnabled = allowScroll.token_turnBoolStringToBoolValue();
    }

    NSString *pageEnable = d[@"pageEnable"];
    if (pageEnable) {
        self.pagingEnabled = pageEnable.token_turnBoolStringToBoolValue();
    }
}

-(void)updateContentSize{
    __block CGFloat maxY = 0;
    __block CGFloat maxX = 0;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y = CGRectGetMaxY(obj.frame);
        CGFloat x = CGRectGetMaxX(obj.frame);
        if ( y > maxY) { maxY = y;}
        if (x > maxX)  { maxX = x;}
    }];
    self.contentSize = CGSizeMake(maxX, maxY);
}

#pragma mark -scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.associatedNode.didScroll) {
       [self.associatedNode.didScroll.value callWithArguments:nil];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.associatedNode.didEndDecelerating) {
        [self.associatedNode.didEndDecelerating.value callWithArguments:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
