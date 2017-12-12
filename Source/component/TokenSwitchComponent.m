//
//  TokenSwitchComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/29.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenSwitchComponent.h"
#import "TokenXMLNode.h"
#import "UIColor+SSRender.h"
#import "UIView+Attributes.h"

@implementation TokenSwitchComponent

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(onValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)onValueChanged{
    [self.associatedNode.onClick.value callWithArguments:@[@(self.isOn)]];
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    NSDictionary *d = attributes;
    NSString *color = d[@"color"];
    if (color) { self.tintColor = [UIColor ss_colorWithString:color];}
    [super token_updateAppearanceWithCSSAttributes:d shouldLayout:shouldLayout];
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    NSDictionary *d = dictionary;
    NSString *color = d[@"color"];
    if (color) { self.tintColor = [UIColor ss_colorWithString:color];}
    NSString *onColor = d[@"onColor"];
    if (onColor) { self.onTintColor = [UIColor ss_colorWithString:onColor];}
    [super token_updateAppearanceWithNormalDictionary:dictionary];
}
@end
