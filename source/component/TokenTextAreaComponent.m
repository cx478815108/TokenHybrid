//
//  TokenTextAreaComponent.m
//  MyWHUT
//
//  Created by 陈雄 on 2017/10/25.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenTextAreaComponent.h"
#import "UIColor+SSRender.h"
#import "NSString+Token.h"
#import "TokenHybridConstant.h"
#import "UIView+Attributes.h"
#import "TokenXMLNode.h"

@interface TokenTextAreaComponent()<UITextViewDelegate>
@end

@implementation TokenTextAreaComponent
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEndEditingNotification) name:TokenHybridEndEditingNotification object:nil];
        self.delegate = self;
        if (@available(iOS 11, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return self;
}

-(void)didReceiveEndEditingNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resignFirstResponder];
    });
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    [super token_updateAppearanceWithCSSAttributes:attributes shouldLayout:shouldLayout];
    if (attributes[@"color"])            {
        self.textColor = [UIColor ss_colorWithString:attributes[@"color"]];
    }
    NSString *fontSize = attributes[@"font-size"];
    if (fontSize)             {
        self.font = [UIFont systemFontOfSize:[fontSize.token_replace(@"px",@"") floatValue]];
    }
    
    NSString *font = attributes[@"font"];
    if (font) {
        NSMutableArray *fontDescs = font.token_replace(@"px",@"").token_separator(@" ").mutableCopy;
        [fontDescs.mutableCopy removeObject:@""];
        if (fontDescs.count == 2) {
            self.font = [UIFont fontWithName:fontDescs[0] size:[fontDescs[1] floatValue]];
        }
    }
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    [super token_updateAppearanceWithNormalDictionary:dictionary];
    NSDictionary *style = dictionary;
    if (style[@"textColor"])            {
        self.textColor            = [UIColor ss_colorWithString:style[@"textColor"]];
    }
    if (style[@"cursorColor"])          {
        self.tintColor            = [UIColor ss_colorWithString:style[@"cursorColor"]];
    }
    NSString *fontSize = style[@"fontSize"];
    if (fontSize)             {
        self.font                 = [UIFont systemFontOfSize:[fontSize.token_replace(@"px",@"") floatValue]];
    }
    
    NSString *font = style[@"font"];
    if (font) {
        NSMutableArray *fontDescs = font.token_replace(@"px",@"").token_separator(@" ").mutableCopy;
        [fontDescs.mutableCopy removeObject:@""];
        if (fontDescs.count == 2) {
            self.font = [UIFont fontWithName:fontDescs[0] size:[fontDescs[1] floatValue]];
        }
    }

    NSString *showVBar = style[@"showVBar"];
    if (showVBar)    {
        self.showsVerticalScrollIndicator = showVBar.token_turnBoolStringToBoolValue();
    }

    NSString *allowScroll = style[@"allowScroll"];
    if (allowScroll) {
        self.scrollEnabled = allowScroll.token_turnBoolStringToBoolValue();
    }

    NSString *editable = style[@"editable"];
    if (editable) {
        self.editable = editable.token_turnBoolStringToBoolValue();
    }

    NSString *selectable = style[@"selectable"];
    if (selectable) {
        self.selectable = selectable.token_turnBoolStringToBoolValue();
    }

    NSString *align          = style[@"align"];
    if (align) {
        NSDictionary *aligns = @{
                                 @"left":   @(NSTextAlignmentLeft),
                                 @"right":  @(NSTextAlignmentRight),
                                 @"center": @(NSTextAlignmentCenter)
                                 };
        if ([aligns.allKeys containsObject:align]) { self.textAlignment = [aligns[align] integerValue];}
    }
    NSString *keyboardType          = style[@"keyboardType"];
    if (keyboardType) {
        NSDictionary *aligns = @{
                                 @"default":               @(UIKeyboardTypeDefault),
                                 @"ASCIICapable":          @(UIKeyboardTypeASCIICapable),
                                 @"NumbersAndPunctuation": @(UIKeyboardTypeNumbersAndPunctuation),
                                 @"URL":                   @(UIKeyboardTypeURL),
                                 @"Number":                @(UIKeyboardTypeNumberPad),
                                 };
        if ([aligns.allKeys containsObject:align]) {
            self.keyboardType = [aligns[align] integerValue];
        }
    }

    NSString *returnType          = style[@"keyReturnType"];
    if (returnType) {
        NSDictionary *type = @{
                               @"default":  @(UIReturnKeyDefault),
                               @"go":       @(UIReturnKeyGo),
                               @"join":     @(UIReturnKeyJoin),
                               @"next":     @(UIReturnKeyNext),
                               @"search":   @(UIReturnKeySearch),
                               @"send":     @(UIReturnKeySend),
                               @"continue": @(UIReturnKeyContinue)
                               
                               };
        if ([type.allKeys containsObject:returnType]) {
            self.returnKeyType = [type[returnType] integerValue];
        }
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.associatedNode.onBeginEditing) {
        [self.associatedNode.onBeginEditing.value callWithArguments:nil];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (self.associatedNode.onEndEditing) {
        [self.associatedNode.onEndEditing.value callWithArguments:nil];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.associatedNode.onTextChange) {
        [self.associatedNode.onTextChange.value callWithArguments:@[textView.text]];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (self.associatedNode.onKeyBoardReturn) {
            [self.associatedNode.onKeyBoardReturn.value callWithArguments:@[text]];
        }
        [self resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
