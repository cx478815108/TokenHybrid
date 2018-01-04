//
//  TokenButtonComponent.m
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/24.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenButtonComponent.h"
#import "TokenXMLNode.h"
#import "UIColor+SSRender.h"
#import "TokenHybridConstant.h"
#import "UIView+Attributes.h"
#import "NSString+Token.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <SDWebImage/SDWebImageManager.h>

@import JavaScriptCore;

@implementation TokenButtonComponent{
    UIColor *_colorCache;
}

+(instancetype)buttonWithTypeString:(NSString *)type title:(NSString *)title{
    TokenButtonComponent *button;
    if ([type isEqualToString:@"system"]) {
        button = [TokenButtonComponent buttonWithType:UIButtonTypeSystem];
    }
    else if ([type isEqualToString:@"detailDisclosure"]) {
        button = [TokenButtonComponent buttonWithType:UIButtonTypeDetailDisclosure];
    }
    else if ([type isEqualToString:@"contactAdd"]) {
        button = [TokenButtonComponent buttonWithType:UIButtonTypeContactAdd];
    }
    else {
        button = [TokenButtonComponent buttonWithType:UIButtonTypeCustom];
    }
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(didPressedSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        if (_selectedBackgroundColor) {
            self.backgroundColor = _selectedBackgroundColor;
        }
        else {
            self.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
    }
    else {
        self.backgroundColor = _colorCache;
    }
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    [super token_updateAppearanceWithCSSAttributes:attributes shouldLayout:shouldLayout];
    NSString *font = attributes[@"font"];
    if (font) {
        NSMutableArray *fontDescs = font.token_replace(@"px",@"").token_separator(@" ").mutableCopy;
        [fontDescs.mutableCopy removeObject:@""];
        if (fontDescs.count == 2) {
            self.titleLabel.font = [UIFont fontWithName:fontDescs[0] size:[fontDescs[1] floatValue]];
        }
    }
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    [super token_updateAppearanceWithNormalDictionary:dictionary];
    _colorCache        = self.backgroundColor;
    NSDictionary *d    = dictionary;
    NSString *fontSize = d[@"fontSize"];
    if (fontSize)            {
        self.titleLabel.font = [UIFont systemFontOfSize:[fontSize.token_replace(@"px",@"") floatValue]];
    }
    NSString *font = d[@"font"];
    if (font) {
        NSMutableArray *fontDescs = font.token_replace(@"px",@"").token_separator(@" ").mutableCopy;
        [fontDescs.mutableCopy removeObject:@""];
        if (fontDescs.count == 2) {
            self.titleLabel.font = [UIFont fontWithName:fontDescs[0] size:[fontDescs[1] floatValue]];
        }
    }
    if (d[@"title"])                {
        [self setTitle:d[@"title"] forState:(UIControlStateNormal)];
    }
    if (d[@"highlightTitle"]) {
        [self setTitle:d[@"highlightTitle"] forState:(UIControlStateHighlighted)];
    }
    if (d[@"titleColor"]) {
        [self setTitleColor:[UIColor ss_colorWithString:d[@"titleColor"]] forState:UIControlStateNormal];
    }
    if (d[@"highlightTitleColor"]) {
        [self setTitleColor:[UIColor ss_colorWithString:d[@"highlightTitleColor"]] forState:UIControlStateHighlighted];
    }
    else {
        [self setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        
    }
    if (d[@"selectedBackgroundColor"]) {
        _selectedBackgroundColor = [UIColor ss_colorWithString:d[@"selectedBackgroundColor"]];
    }
    if (d[@"image"]){
        [self setImage:nil forState:UIControlStateNormal];
        [self sd_setShowActivityIndicatorView:YES];
        [self sd_addActivityIndicator];
        [self sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:d[@"image"]] options:0
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                      [self setImage:nil forState:UIControlStateNormal];
                                                      [self sd_removeActivityIndicator];
                                                  }];
    }
    if (d[@"selectedImage"]){
        [self sd_setImageWithURL:[NSURL URLWithString:d[@"selectedImage"]]
                        forState:(UIControlStateSelected)
                       completed:nil];
    }
    if (d[@"highlightImage"]){
        [self sd_setImageWithURL:[NSURL URLWithString:d[@"highlightImage"]]
                        forState:(UIControlStateHighlighted)
                       completed:nil];
    }
    NSString *imageMode = d[@"imageMode"];
    if (imageMode){
        NSDictionary *modes = @{
                                @"fill"      : @(0),
                                @"aspectfit" : @(1),
                                @"aspectfill": @(2)
                                };
        if ([modes.allKeys containsObject:imageMode]) { self.imageView.contentMode=[modes[imageMode] integerValue];}
    }
}

-(void)didPressedSelf{
    [self.associatedNode.onClick.value callWithArguments:nil];
}
@end
