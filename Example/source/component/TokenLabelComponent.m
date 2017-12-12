//
//  TokenLabelComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/10.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenLabelComponent.h"
#import "TokenXMLNode.h"
#import "TokenHybridConstant.h"
#import "UIColor+SSRender.h"
#import "UIView+Attributes.h"
#import "NSString+Token.h"

@implementation TokenLabelComponent{
    UITapGestureRecognizer *_tapGestureRecognizer;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)addTapGestureRecognizer{
    if (_tapGestureRecognizer == nil) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didPressedSelf:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
}

-(void)didPressedSelf:(UITapGestureRecognizer *)gesture{
    [self.associatedNode.onClick.value callWithArguments:@[]];
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    [super token_updateAppearanceWithCSSAttributes:attributes shouldLayout:shouldLayout];
    NSDictionary *d = attributes;
    if (d[@"font-size"]) { self.font = [UIFont systemFontOfSize:[d[@"font-size"] floatValue]];}
    NSString *font = d[@"font"];
    if (font) {
        NSMutableArray *fontDescs = font.token_replace(@"px",@"").token_separator(@" ").mutableCopy;
        [fontDescs.mutableCopy removeObject:@""];
        if (fontDescs.count == 2) {
            self.font = [UIFont fontWithName:fontDescs[0] size:[fontDescs[1] floatValue]];
        }
    }
    if (d[@"color"]) { self.textColor = [UIColor ss_colorWithString:d[@"color"]];}
    NSString *align = d[@"text-align"];
    if (align) {
        NSDictionary *aligns = @{
                                 @"left"  : @(NSTextAlignmentLeft),
                                 @"right" : @(NSTextAlignmentRight),
                                 @"center": @(NSTextAlignmentCenter)
                                 };
        if ([aligns.allKeys containsObject:align]) { self.textAlignment = [aligns[align] integerValue];}
    }
}


-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)appearanceDictionary{
    [super token_updateAppearanceWithNormalDictionary:appearanceDictionary];
    NSDictionary *d = appearanceDictionary;
    NSString *fontSize = d[@"fontSize"];
    if (fontSize)        { self.font          = [UIFont systemFontOfSize:[fontSize.token_replace(@"px",@"") floatValue]];}
    if (d[@"innerText"]) { self.text          = d[@"innerText"];}
    if (d[@"lines"])     { self.numberOfLines = [d[@"lines"] integerValue];}
    if (d[@"textColor"]) { self.textColor     = [UIColor ss_colorWithString:d[@"textColor"]];}
    NSString *font = d[@"font"];
    if (font) {
        NSMutableArray *fontDescs = font.token_replace(@"px",@"").token_separator(@" ").mutableCopy;
        [fontDescs.mutableCopy removeObject:@""];
        if (fontDescs.count == 2) {
            self.font = [UIFont fontWithName:fontDescs[0] size:[fontDescs[1] floatValue]];
        }
    }

    NSString *align = d[@"textAlign"];
    if (align) {
        NSDictionary *aligns = @{
                                 @"left"  : @(NSTextAlignmentLeft),
                                 @"right" : @(NSTextAlignmentRight),
                                 @"center": @(NSTextAlignmentCenter)
                                 };
        if ([aligns.allKeys containsObject:align]) { self.textAlignment = [aligns[align] integerValue];}
    }
}
@end
