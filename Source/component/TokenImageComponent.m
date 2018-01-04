//
//  TokenImageView.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/10.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenImageComponent.h"
#import "TokenXMLNode.h"
#import "UIView+Attributes.h"
#import <SDWebImage/UIView+WebCache.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation TokenImageComponent{
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
    [self.associatedNode.onClick.value callWithArguments:nil];
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    [super token_updateAppearanceWithNormalDictionary:dictionary];
    NSDictionary *d = dictionary;
    NSString *mode  = d[@"imageMode"];
    if (mode){
        NSDictionary *modes = @{
                                @"fill"      : @(0),
                                @"aspectfit" : @(1),
                                @"aspectfill": @(2)
                                };
        if ([modes.allKeys containsObject:mode]) { self.contentMode=[modes[mode] integerValue];}
    }
    NSString *image = d[@"src"];
    if (image){
        self.image = nil;
        [self sd_setShowActivityIndicatorView:YES];
        [self sd_addActivityIndicator];
        [self sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:image] options:0
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                      self.image = image;
                                                      [self sd_removeActivityIndicator];
                                                  }];
    }
}
@end
