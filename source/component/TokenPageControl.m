//
//  TokenPageControl.m
//  MyWHUT
//
//  Created by 陈雄 on 2017/11/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenPageControl.h"
#import "UIColor+SSRender.h"
#import "NSString+Token.h"
#import "TokenHybridConstant.h"
#import "UIView+Attributes.h"
#import "TokenXMLNode.h"

@import JavaScriptCore;
@implementation TokenPageControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(dotValueChanged) forControlEvents:(UIControlEventValueChanged)];
    }
    return self;
}

-(void)dotValueChanged{
    if (self.associatedNode) {
        [self.associatedNode.onClick.value callWithArguments:@[@(self.currentPage)]];
    }
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    [super token_updateAppearanceWithNormalDictionary:dictionary];
    NSDictionary *d = dictionary;
    if (d[@"dotColor"]) {
        self.pageIndicatorTintColor = [UIColor ss_colorWithString:d[@"dotColor"]];
    }
    if (d[@"onDotColor"]) {
        self.currentPageIndicatorTintColor = [UIColor ss_colorWithString:d[@"onDotColor"]];
    }
    if (d[@"number"]) {
        self.numberOfPages = [d[@"number"] integerValue];
    }
}

@end
