//
//  TokenTableCell.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenTableCell.h"
#import "TokenXMLNode.h"
#import "UIColor+Token.h"
#import "NSString+Token.h"
#import "TokenDataItem.h"
#import "NSDictionary+chainScript.h"
#import "UIView+Attributes.h"
#import <YogaKit/UIView+Yoga.h>

static NSString *reuseIdentifier = @"TokenTableCell";

@implementation TokenTableCell
{
    BOOL                 _subViewConfiged;
    NSMutableDictionary *_viewStore;
    NSInteger            _nodeIdentifierCount;
    NSMutableDictionary <NSString *,NSDictionary *>*_renderPropertyDictionary;
}

+(NSString *)reuseIdentifier{    
    return reuseIdentifier;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
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
        [view token_updateAppearanceWithCSSAttributes:obj.cssAttributes];
        [view token_updateAppearanceWithCSSAttributes:obj.innerStyleAttributes];
        [view token_updateAppearanceWithNormalDictionary:obj.innerAttributes];
        [self.contentView addSubview:view];
    }];
    
    [self.contentView.yoga applyLayoutPreservingOrigin:YES];
    _subViewConfiged = YES;
    _nodeIdentifierCount = 0;
    //配置accessoryType
    NSString *accessoryType = node.innerAttributes[@"accessoryType"];
    if (accessoryType == nil) return;
    if ([accessoryType isEqualToString:@"none"]) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    else if ([accessoryType isEqualToString:@"infoButton"]) {
        self.accessoryType = UITableViewCellAccessoryDetailButton;
    }
    else if ([accessoryType isEqualToString:@"arrow"]) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if ([accessoryType isEqualToString:@"checkmark"]) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    }
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
                NSString *indexKey        = _dataItem.customForLoop[@"forIndex"];
                NSString *sectionKey      = _dataItem.customForLoop[@"forSection"];
                NSString *newMatchString  = matchString.token_replace(@"{",@"")
                                                       .token_replace(@"}",@"");
                if ([newMatchString isEqualToString:indexKey]) {
                    return [NSString stringWithFormat:@"%@",@(self.indexPath.row)];
                }
                else if ([newMatchString isEqualToString:sectionKey]) {
                    return [NSString stringWithFormat:@"%@",@(self.indexPath.section)];
                }
                
                NSString *mappedString = [_dataItem.dataObj token_chainScript:newMatchString
                                                                      itemKey:itemKey
                                                                       idxKey:indexKey
                                                                   sectionKey:sectionKey
                                                                    indexPath:self.indexPath];
                return mappedString;
            });
        }
        [dataObj setObject:obj forKey:key];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view token_updateAppearanceWithNormalDictionary:dataObj];
    });
}
#pragma mark - getter
-(UIView *)recoverViewFromNode:(TokenXMLNode *)node{
    node.identifier = [NSString stringWithFormat:@"%@",@(_nodeIdentifierCount)];
    _nodeIdentifierCount += 1;
    UIView *view = [UIView token_produceViewWithNode:node];
    if (view) { [_viewStore setObject:view forKey:node.identifier];}
    
    [node.childNodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *subview = [self recoverViewFromNode:obj];
        [subview token_updateAppearanceWithCSSAttributes:obj.cssAttributes];
        [subview token_updateAppearanceWithCSSAttributes:obj.innerStyleAttributes];
        [subview token_updateAppearanceWithNormalDictionary:obj.innerAttributes];
        [view addSubview:subview];
    }];
    //记录属性信息
    [self recordSetPropertyWithNode:node];
    return view;
}

-(CGSize)sizeThatFits:(CGSize)size{
    __block CGFloat maxHeight = 44.0f;
    [_viewStore enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, UIView *obj, BOOL * _Nonnull stop) {
        CGFloat height = CGRectGetMaxY(obj.frame);
        if (height > maxHeight) { maxHeight = height;}
    }];
    return CGSizeMake(size.width, maxHeight);
}

@end
