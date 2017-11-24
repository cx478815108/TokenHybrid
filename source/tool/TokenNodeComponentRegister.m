//
//  TokenNodeComponentRegister.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/5.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenNodeComponentRegister.h"
#import "TokenXMLNode.h"
#import "TokenLabelComponent.h"
#import "TokenButtonComponent.h"
#import "TokenPureComponent.h"
#import "TokenInputComponent.h"
#import "TokenImageComponent.h"
#import "TokenScrollComponent.h"
#import "TokenTableComponent.h"
#import "TokenTextAreaComponent.h"
#import "TokenSegmentedComponent.h"
#import "TokenSwitchComponent.h"
#import "TokenSearchBarComponent.h"
#import "TokenWebViewComponent.h"
#import "TokenPageControl.h"
#import "TokenExtensionHeader.h"

@implementation TokenHybridRegisterModel

-(instancetype)initWithNodeTagName:(NSString *)nodeTagName
                     nodeClassName:(NSString *)nodeClassName
          nativeComponentClassName:(NSString *)nativeComponentClassName
                      creatProcess:(TokenHybridComponentCreatBlock)creatProcess{
    if (self = [super init]){
        self.nodeTagName              = nodeTagName;
        self.nodeClassName            = nodeClassName;
        self.nativeComponentClassName = nodeClassName;
        self.creatProcess             = creatProcess;
    }
    return self;
}

-(UIView *)creatNativeComponentWithNode:(TokenXMLNode *)node{
    if (!self.customInit) {
        Class obj = NSClassFromString(self.nativeComponentClassName);
        return [[obj alloc] init];
    }
    else {
        if (_creatProcess == nil) return nil;
        return self.creatProcess(node);
    }
}

-(TokenXMLNode *)creatNode{
    Class obj = NSClassFromString(self.nodeClassName);
    return [[obj alloc] init];
}
@end

@implementation TokenNodeComponentRegister{
    NSMutableDictionary *_nodeTagNameRegistModelMapper;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _nodeTagNameRegistModelMapper =@{}.mutableCopy;
    }
    return self;
}

-(void)registDefault{
    TokenHybridRegisterModel *model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"div";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenPureComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"body";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenPureComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];
    
    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"dots";
    model.nodeClassName            = @"TokenDotsNode";
    model.nativeComponentClassName = @"TokenPageControl";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"view";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenPureComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"tableHeader";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenTableHeaderComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"tableSection";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenPureComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"tableRow";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenPureComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"tableFooter";
    model.nodeClassName            = @"TokenPureNode";
    model.nativeComponentClassName = @"TokenPureComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"image";
    model.nodeClassName            = @"TokenImageNode";
    model.nativeComponentClassName = @"TokenImageComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"webView";
    model.nodeClassName            = @"TokenWebViewNode";
    model.nativeComponentClassName = @"TokenWebViewComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"searchBar";
    model.nodeClassName            = @"TokenSearchBarNode";
    model.nativeComponentClassName = @"TokenSearchBarComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"button";
    model.nodeClassName            = @"TokenButtonNode";
    model.nativeComponentClassName = @"TokenButtonComponent";
    model.customInit               = YES;
    model.creatProcess = ^ UIView *(__kindof TokenXMLNode *node) {
        NSString *type = node.innerAttributes[@"type"];
        TokenButtonComponent *button = [TokenButtonComponent buttonWithTypeString:type title:node.innerText];
        return button;
    };
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"navItem";
    model.nodeClassName            = @"TokenButtonNode";
    model.nativeComponentClassName = @"TokenButtonComponent";
    model.customInit               = YES;
    model.creatProcess = ^ UIView *(__kindof TokenXMLNode *node) {
        NSString *type = node.innerAttributes[@"type"];
        TokenButtonComponent *button = [TokenButtonComponent buttonWithTypeString:type title:node.innerText];
        return button;
    };
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"label";
    model.nodeClassName            = @"TokenLabelNode";
    model.nativeComponentClassName = @"TokenLabelComponent";
    model.customInit               = YES;
    model.creatProcess = ^ UIView *(__kindof TokenXMLNode *node) {
        TokenLabelComponent *label = [[TokenLabelComponent alloc] init];
        label.text = node.innerText;
        return label;
    };
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"scrollView";
    model.nodeClassName            = @"TokenScrollNode";
    model.nativeComponentClassName = @"TokenScrollComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"input";
    model.nodeClassName            = @"TokenInputNode";
    model.nativeComponentClassName = @"TokenInputComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"table";
    model.nodeClassName            = @"TokenTableNode";
    model.nativeComponentClassName = @"TokenTableComponent";
    model.customInit               = YES;
    model.creatProcess = ^ UIView *(__kindof TokenXMLNode *node) {
        TokenTableComponent *tableView = [[TokenTableComponent alloc] initWithConfigNode:node];
        return tableView;
    };
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"segment";
    model.nodeClassName            = @"TokenSegmentNode";
    model.nativeComponentClassName = @"TokenSegmentedComponent";
    model.customInit               = YES;
    model.creatProcess = ^ UIView *(__kindof TokenXMLNode *node) {
        NSString *titleString = node.innerAttributes[@"titles"];
        NSMutableArray *titles = nil;
        if (titleString) {
            titles = [NSMutableArray arrayWithArray:titleString.token_separator(@" ")];
            [titles removeObject:@""];
        }
        TokenSegmentedComponent *seg = [[TokenSegmentedComponent alloc] initWithItems:titles];
        return seg;
    };
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"textArea";
    model.nodeClassName            = @"TokenTextAreaNode";
    model.nativeComponentClassName = @"TokenTextAreaComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];

    model = [[TokenHybridRegisterModel alloc] init];
    model.nodeTagName              = @"switch";
    model.nodeClassName            = @"TokenSwitchNode";
    model.nativeComponentClassName = @"TokenSwitchComponent";
    model.customInit               = NO;
    [self registComponentWithModel:model];
}

-(void)registComponentWithModel:(TokenHybridRegisterModel *)model{
    [_nodeTagNameRegistModelMapper setObject:model forKey:model.nodeTagName];
}

-(TokenHybridRegisterModel *)getRegisterModelWithNodeTagName:(NSString *)nodeTagName{
    TokenHybridRegisterModel *model = [_nodeTagNameRegistModelMapper objectForKey:nodeTagName];
    return model;
}

@end
