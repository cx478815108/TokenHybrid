//
//  UIView+Attributes.m
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/9.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "UIView+Attributes.h"
#import "TokenXMLNode.h"
#import "TokenHybridStack.h"
#import "TokenNodeComponentRegister.h"
#import "TokenHybridOrganizer.h"

#import "UIColor+SSRender.h"
#import "UIView+TokenFlexLayout.h"
#import "NSString+Token.h"

@implementation UIView (Attributes)
-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes{
    if (attributes == nil) { return;}
    [self token_updateAppearanceWithCSSAttributes:attributes shouldLayout:YES];
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    NSMutableDictionary *d = [attributes mutableCopy];
    if(d[@"border-radius"]) {
        self.layer.cornerRadius = [d[@"border-radius"] floatValue];
    }
    if(d[@"z-index"]) {
        self.layer.zPosition    = [d[@"z-index"] floatValue];
    }
    if(d[@"border-width"])  {
        self.layer.borderWidth  = [d[@"border-width"] floatValue];
    }
    if(d[@"border-color"])  {
        self.layer.borderColor  = [UIColor ss_colorWithString:d[@"border-color"]].CGColor;
    }
    if(d[@"background-color"])  {
        self.backgroundColor    = [UIColor ss_colorWithString:d[@"background-color"]];
    }
    //filter some css attributes
    [d removeObjectsForKeys:@[@"border-radius",
                              @"color",
                              @"text-align",
                              @"background-color",
                              @"border-color",
                              @"border-width",
                              @"z-index",
                              @"border-radius",
                              @"font-size",
                              @"font",
                              @"image"]];
    if (shouldLayout) {
       [self token_layoutWithAttributes:d];
    }
}

+(void)token_enumerateViewFromRootToChildWithRootView:(UIView *)rootView
                                                block:(UIViewEnumerateBlock)block{
    if (rootView == nil) { return;}
    TokenHybridStack *stack = [[TokenHybridStack alloc] init];
    BOOL stop = NO;
    [stack push:rootView];
    while (stack.count && stop == NO) {
        UIView *currentView = [stack top];
        !block?:block(currentView,&stop);
        [stack pop];
        for (NSInteger i = 0; i <currentView.subviews.count; i ++) {
            [stack push:currentView.subviews[i]];
        }
    }
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    if (dictionary == nil) return;
    NSDictionary *d = dictionary;
    if(d[@"borderRadius"]) { self.layer.cornerRadius   = [d[@"borderRadius"] floatValue];}
    if(d[@"zIndex"])       { self.layer.zPosition      = [d[@"zIndex"] floatValue];}
    if(d[@"borderWidth"])  { self.layer.borderWidth    = [d[@"borderWidth"] floatValue];}
    if(d[@"borderColor"])  { self.layer.borderColor    = [UIColor ss_colorWithString:d[@"borderColor"]].CGColor;}
    if(d[@"backgroundColor"])  { self.backgroundColor  = [UIColor ss_colorWithString:d[@"backgroundColor"]];}
    NSString *hidden = d[@"hidden"];
    if(hidden) {self.hidden = hidden.token_turnBoolStringToBoolValue(); }
}

+(UIView *)token_produceViewWithNode:(TokenXMLNode *)node{
    TokenNodeComponentRegister *componentRegister = [TokenHybridOrganizer sharedOrganizer].nodeComponentRegister;
    TokenHybridRegisterModel   *model             = [componentRegister getRegisterModelWithNodeTagName:node.name];
    return [model creatNativeComponentWithNode:node];
}
@end
