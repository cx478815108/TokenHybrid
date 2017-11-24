//
//  TokenSegmentedComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/29.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenSegmentedComponent.h"
#import "TokenXMLNode.h"
#import "UIColor+SSRender.h"
#import "UIView+Attributes.h"

@implementation TokenSegmentedComponent

-(instancetype)initWithItems:(NSArray *)items{
    if (self = [super initWithItems:items]) {
        [self addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)segmentValueChanged{
    [self.associatedNode.onClick.value callWithArguments:@[@(self.selectedSegmentIndex)]];
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    NSString *color = attributes[@"color"];
    if (color) {
        self.tintColor = [UIColor ss_colorWithString:color];
    }
    [super token_updateAppearanceWithCSSAttributes:attributes shouldLayout:shouldLayout];
}


-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    NSString *color = dictionary[@"color"];
    if (color) {
        self.tintColor = [UIColor ss_colorWithString:color];
    }
    [super token_updateAppearanceWithNormalDictionary:dictionary];
}
@end
