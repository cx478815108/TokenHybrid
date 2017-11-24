//
//  TokenTableSectionView.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenTableSectionView.h"
#import "TokenXMLNode.h"
#import "UIColor+Token.h"
#import "NSString+Token.h"
#import "UIView+Attributes.h"
#import "NSDictionary+chainScript.h"
#import "TokenDataItem.h"
#import <YogaKit/UIView+Yoga.h>

@implementation TokenTableSectionView
{
    BOOL                 _subViewConfiged;
    NSMutableDictionary *_viewStore;
    NSInteger            _nodeIdentifierCount;
    NSMutableDictionary <NSString *,NSDictionary *>*_renderPropertyDictionary;
}

+(NSString *)reuseIdentifier{
    static NSString *reuseIdentifier = @"TokenTableSectionView";
    return reuseIdentifier;
}

-(void)configHierarchyWithNode:(TokenXMLNode *)node{
    if (_subViewConfiged) { return;}
    else { _viewStore = @{}.mutableCopy;}
    //初始化需要被动态渲染的属性
    _renderPropertyDictionary = @{}.mutableCopy;
    //开始界面布局
    [self.contentView token_updateAppearanceWithCSSAttributes:node.cssAttributes];
    if (node.innerStyleAttributes) {
        [self.contentView token_updateAppearanceWithCSSAttributes:node.innerStyleAttributes];
    }
    [self.contentView token_updateAppearanceWithNormalDictionary:node.innerAttributes];
    //防止从缓存开启的时候， yoga.isEnabled 没有开启，崩溃
    self.contentView.yoga.isEnabled = YES;
    [node.childNodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [self recoverViewFromNode:obj];
        [view token_updateAppearanceWithCSSAttributes:obj.innerAttributes];
        [view token_updateAppearanceWithNormalDictionary:obj.innerAttributes];
        [self.contentView addSubview:view];
    }];
    
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
    _subViewConfiged = YES;
    _nodeIdentifierCount = 0;
}

-(void)recordSetPropertyWithNode:(TokenXMLNode *)node{
    //设置 需要渲染的的属性
    NSMutableDictionary *singleRenderDictionary = @{}.mutableCopy;
    __block BOOL shouldRecord = NO;
    [node.innerAttributes enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSString  *_Nonnull value, BOOL * _Nonnull stop) {
        if ([value hasPrefix:@"{{"] && [value hasSuffix:@"}}"]) {
            [singleRenderDictionary setObject:value forKey:key];
            shouldRecord = YES;
        }
    }];
    if ([node.innerText containsString:@"{{"] && [node.innerText containsString:@"{{"]) {
        [singleRenderDictionary setObject:node.innerText forKey:@"innerText"];
        [_renderPropertyDictionary setObject:singleRenderDictionary forKey:node.identifier];
    }
    if (shouldRecord) {
        [_renderPropertyDictionary setObject:singleRenderDictionary forKey:node.identifier];
    }
}

#pragma mark - setter
-(void)setDataItem:(TokenDataItem *)dataItem{
    _dataItem = dataItem;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [_renderPropertyDictionary enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull viewIdentifier, NSDictionary * _Nonnull properityStory, BOOL * _Nonnull stop) {
            [self updateViewWithIdentifier:viewIdentifier properityStore:properityStory];
        }];
    });
}

-(void)updateViewWithIdentifier:(NSString *)viewIdentifier
                 properityStore:(NSDictionary *)properityStore{
    UIView *view = [_viewStore objectForKey:viewIdentifier];
    NSMutableDictionary *dataObj = @{}.mutableCopy;
    [properityStore enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key,  NSString *_Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj containsString:@"{{"]) {
            obj = obj.token_replaceWithRegExpHigh(@"\\{\\{(.*?)\\}\\}", ^NSString *(NSString *matchString) {
                NSString *itemKey         = _dataItem.customForLoop[@"forItem"];
                NSString *sectionKey      = _dataItem.customForLoop[@"forSection"];
                NSString *newMatchString  = matchString.token_replace(@"{",@"").token_replace(@"}",@"");
                if ([newMatchString isEqualToString:sectionKey]) {
                    return [NSString stringWithFormat:@"%@",@(self.section)];
                }
                
                NSString *mappedString = [_dataItem.dataObj token_chainScript:newMatchString
                                                                      itemKey:itemKey
                                                                       idxKey:sectionKey
                                                                 forLoopIndex:self.section];
                return mappedString;
            });
        }
        [dataObj setObject:obj forKey:key];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view token_updateAppearanceWithNormalDictionary:dataObj];
    });
}

#pragma mark - setter
-(UIView *)recoverViewFromNode:(TokenXMLNode *)node{
    _nodeIdentifierCount += 1;
    node.identifier = [NSString stringWithFormat:@"%@",@(_nodeIdentifierCount)];
    UIView *view = [UIView token_produceViewWithNode:node];
    if (view) { [_viewStore setObject:view forKey:node.identifier];}
    [node.childNodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subview = [self recoverViewFromNode:obj];
        [subview token_updateAppearanceWithCSSAttributes:node.cssAttributes];
        [subview token_updateAppearanceWithCSSAttributes:obj.innerStyleAttributes];
        [subview token_updateAppearanceWithNormalDictionary:obj.innerAttributes];
        [view addSubview:subview];
    }];
    //记录属性信息
    [self recordSetPropertyWithNode:node];
    return view;
}

-(CGSize)sizeThatFits:(CGSize)size{
    __block CGFloat maxHeight = 24.0f;
    [_viewStore enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIView *obj, BOOL * _Nonnull stop) {
        CGFloat height = CGRectGetMaxY(obj.frame);
        if (height > maxHeight) { maxHeight = height;}
    }];
    return CGSizeMake(size.width, maxHeight);
}


@end
