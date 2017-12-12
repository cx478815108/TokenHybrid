//
//  TokenInputComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/17.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenInputComponent.h"
#import "TokenHybridConstant.h"
#import "UIColor+SSRender.h"
#import "NSString+Token.h"
#import "UIView+Attributes.h"
#import "TokenXMLNode.h"

@interface TokenInputComponent() <UITextFieldDelegate>
@end

@implementation TokenInputComponent
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEndEditingNotification) name:TokenHybridEndEditingNotification object:nil];
    }
    return self;
}

-(void)didReceiveEndEditingNotification{
   [self resignFirstResponder];
}

-(void)token_updateAppearanceWithCSSAttributes:(NSDictionary *)attributes shouldLayout:(BOOL)shouldLayout{
    [super token_updateAppearanceWithCSSAttributes:attributes shouldLayout:shouldLayout];
    NSString *fontSize = attributes[@"font-size"];
    if (fontSize)             {
        self.font                 = [UIFont systemFontOfSize:[fontSize.token_replace(@"px",@"") floatValue]];
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
    if (style[@"placeholder"])          {
        self.placeholder          = style[@"placeholder"];
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
    NSString *secure = style[@"secure"];
    if (secure) {
        self.secureTextEntry = secure.token_turnBoolStringToBoolValue();
    }
    
    if([style[@"showClear"] boolValue]) {
        self.clearButtonMode      = UITextFieldViewModeWhileEditing;
    }
    else                                { self.clearButtonMode      = UITextFieldViewModeNever;}
    if(style[@"clearOnBegin"])          {
        self.clearsOnBeginEditing = [style[@"clearOnBegin"] boolValue];
    }
    
    NSString *align          = style[@"align"];
    NSString *borderStyle    = style[@"borderStyle"];
    if (align) {
        NSDictionary *aligns = @{
                                 @"left":   @(NSTextAlignmentLeft),
                                 @"right":  @(NSTextAlignmentRight),
                                 @"center": @(NSTextAlignmentCenter)
                                 };
        if ([aligns.allKeys containsObject:align]) { self.textAlignment = [aligns[align] integerValue];}
    }
    
    if (borderStyle) {
        NSDictionary *roundStyle = @{
                                    @"none":        @(UITextBorderStyleNone),
                                    @"line":        @(UITextBorderStyleLine),
                                    @"bezel":       @(UITextBorderStyleBezel),
                                    @"roundedRect": @(UITextBorderStyleRoundedRect)
                                    };
        self.borderStyle=[roundStyle[borderStyle] integerValue];
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

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (self.associatedNode.onBeginEditing) {
        [self.associatedNode.onBeginEditing.value callWithArguments:nil];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.associatedNode.onEndEditing) {
        [self.associatedNode.onEndEditing.value callWithArguments:nil];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (self.associatedNode.onTextChange) {
        if (string == nil) {
            string = @"";
        }
        [self.associatedNode.onTextChange.value callWithArguments:@[textField.text?textField.text.token_append(string):@""]];
    }
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    textField.text = @"";
    if (self.associatedNode.onClearClick) {
        [self.associatedNode.onClearClick.value callWithArguments:nil];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.associatedNode.onKeyBoardReturn) {
        [self.associatedNode.onKeyBoardReturn.value callWithArguments:@[textField.text]];
    }
    return YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
