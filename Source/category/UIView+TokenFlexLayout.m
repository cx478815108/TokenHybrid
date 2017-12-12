//
//  UIView+TokenFlexLayout.m
//  TokenHTMLRender
//
//  Created by 陈雄 on 2017/9/23.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "UIView+TokenFlexLayout.h"
#import <YogaKit/UIView+Yoga.h>

#define TokenAttrCountCheck attrCount++;if(attrCount == attrNumber) return ;

#define Token_setFloatValue(pName,value) \
if (value) {\
    if ([value hasSuffix:@"%"]) {\
        value = [value stringByReplacingOccurrencesOfString:@"%" withString:@""];\
        [layout set##pName:YGPercentValue([value floatValue])];\
    }\
    else {\
        [layout set##pName:YGPointValue([value floatValue])];\
    }\
    TokenAttrCountCheck \
}\

@implementation UIView (TokenFlexLayout)
-(void)token_layoutWithAttributes:(NSDictionary *)attributes{
    NSInteger attrNumber = attributes.allKeys.count;
    __block NSInteger attrCount = 0;
    [self configureLayoutWithBlock:^(YGLayout * layout) {
        layout.isEnabled = YES;

        NSString *display = attributes[@"display"];
        if (display) {
            layout.display = [self token_getDisplayWithString:display];
            TokenAttrCountCheck
        }
        
        NSString *flexGrow = attributes[@"flex-grow"];
        if (flexGrow) {
            layout.flexGrow = [flexGrow floatValue];
            TokenAttrCountCheck
        }
        
        NSString *flexWrap = attributes[@"flex-wrap"];
        if (flexWrap) {
            layout.flexWrap = [self token_getFlexWrapWithString:flexWrap];
            TokenAttrCountCheck
        }
        
        NSString *flexDirection = attributes[@"flex-direction"];
        if (flexDirection) {
            [layout setFlexDirection:[self token_getFlexDirectionWithString:flexDirection]];
            TokenAttrCountCheck
        }
        
        NSString *justifyContent = attributes[@"justify-content"];
        if (justifyContent) {
            layout.justifyContent = [self token_getJustifyWithString:justifyContent];
            TokenAttrCountCheck
        }
        
        NSString *alignContent = attributes[@"align-content"];
        if (alignContent) {
            layout.alignContent = [self token_getAlignWithString:justifyContent];
            TokenAttrCountCheck
        }
        
        NSString *alignItems = attributes[@"align-items"];
        if (alignItems) {
            layout.alignItems = [self token_getAlignWithString:alignItems];
            TokenAttrCountCheck
        }
        
        NSString *alignSelf = attributes[@"align-self"];
        if (alignSelf) {
            layout.alignSelf = [self token_getAlignWithString:alignSelf];
            TokenAttrCountCheck
        }
        
        NSString *overFlow =attributes[@"overflow"];
        if (overFlow) {
            layout.overflow = [self token_getOverflowWithString:overFlow];
            TokenAttrCountCheck
        }
        
        NSString *flexShrink = attributes[@"flex-shrink"];
        if (flexShrink) {
            layout.flexShrink = [flexShrink floatValue];
            TokenAttrCountCheck
        }
        
        NSString *flexBasis = attributes[@"flex-basis"];
        if (flexBasis) {
            layout.flexBasis = YGPointValue([flexBasis floatValue]);
            TokenAttrCountCheck
        }
        
        NSString *position = attributes[@"position"];
        if (position) {
            layout.position = [self token_getPositionTypeWithString:position];
            TokenAttrCountCheck
        }
        
        NSString *width = attributes[@"width"];
        Token_setFloatValue(Width,width);
        
        NSString *height = attributes[@"height"];
        Token_setFloatValue(Height,height);
        
        NSString *left = attributes[@"left"];
        Token_setFloatValue(Left,left);
        
        NSString *right = attributes[@"right"];
        Token_setFloatValue(Right,right);
        
        NSString *top = attributes[@"top"];
        Token_setFloatValue(Top,top);
        
        NSString *bottom = attributes[@"bottom"];
        Token_setFloatValue(Bottom,bottom);
        
        NSString *start = attributes[@"start"];
        Token_setFloatValue(Start,start);
        
        NSString *end = attributes[@"end"];
        Token_setFloatValue(End,end);
        
        //image
        NSString *aspectRatio = attributes[@"aspectRatio"];
        if (aspectRatio) {
            layout.aspectRatio = [aspectRatio floatValue];
        }
        
        //marign
        NSString *margin = attributes[@"margin"];
        Token_setFloatValue(Margin,margin);
        
        NSString *marginLeft = attributes[@"margin-left"];
        Token_setFloatValue(MarginLeft,marginLeft);
        
        NSString *marginRight = attributes[@"margin-right"];
        Token_setFloatValue(MarginRight,marginRight);
        
        NSString *marginStart = attributes[@"margin-start"];
        Token_setFloatValue(MarginStart,marginStart);
        
        NSString *marginEnd = attributes[@"margin-end"];
        Token_setFloatValue(MarginEnd,marginEnd);
        
        NSString *marginTop = attributes[@"margin-top"];
        Token_setFloatValue(MarginTop,marginTop);
        
        NSString *marginBottom = attributes[@"margin-bottom"];
        Token_setFloatValue(MarginBottom,marginBottom);
        
        NSString *marginHorizontal = attributes[@"margin-horizontal"];
        Token_setFloatValue(MarginHorizontal,marginHorizontal);
        
        NSString *marginVertical = attributes[@"margin-vertical"];
        Token_setFloatValue(MarginVertical,marginVertical);
        
        //padding
        
        NSString *padding = attributes[@"padding"];
        Token_setFloatValue(Padding,padding);
        
        NSString *paddingLeft = attributes[@"padding-left"];
        Token_setFloatValue(PaddingLeft,paddingLeft);
        
        NSString *paddingRight = attributes[@"padding-right"];
        Token_setFloatValue(PaddingRight,paddingRight);
        
        NSString *paddingStart = attributes[@"padding-start"];
        Token_setFloatValue(PaddingStart,paddingStart);
        
        NSString *paddingEnd = attributes[@"padding-end"];
        Token_setFloatValue(PaddingEnd,paddingEnd);
        
        NSString *paddingTop = attributes[@"padding-top"];
        Token_setFloatValue(PaddingTop,paddingTop);
        
        NSString *paddingBottom = attributes[@"padding-bottom"];
        Token_setFloatValue(PaddingBottom,paddingBottom);
        
        NSString *paddingHorizontal = attributes[@"padding-horizontal"];
        Token_setFloatValue(PaddingHorizontal,paddingHorizontal);
        
        NSString *paddingVertical = attributes[@"padding-vertical"];
        Token_setFloatValue(PaddingVertical,paddingVertical);
        
        NSString *maxWidth = attributes[@"max-width"];
        Token_setFloatValue(MaxWidth,maxWidth);
        
        NSString *minWidth = attributes[@"min-width"];
        Token_setFloatValue(MinWidth,minWidth);
        
        NSString *maxHeight = attributes[@"max-height"];
        Token_setFloatValue(MaxHeight,maxHeight);
        
        NSString *minHeight = attributes[@"min-height"];
        Token_setFloatValue(MinHeight,minHeight);
        
        NSString *direction = attributes[@"direction"];
        if(direction) {
            layout.direction = [self token_getDirectionWithString:direction];
            TokenAttrCountCheck
        }
    }];
}

-(YGDirection)token_getDirectionWithString:(NSString *)direction{
    if ([direction isEqualToString:@"inherit"]) {
        return YGDirectionInherit;
    }
    if ([direction isEqualToString:@"ltr"]) {
        return YGDirectionLTR;
    }
    if ([direction isEqualToString:@"rtl"]) {
        return YGDirectionRTL;
    }
    return YGDirectionInherit;
}


-(YGFlexDirection)token_getFlexDirectionWithString:(NSString *)flexDirectionString{
    //flex-direction
    if ([flexDirectionString isEqualToString:@"row"]) {
        return YGFlexDirectionRow;
    }
    else if ([flexDirectionString isEqualToString:@"column"]) {
        return YGFlexDirectionColumn;
    }
    else if ([flexDirectionString isEqualToString:@"column-reverse"]) {
        return YGFlexDirectionColumnReverse;
    }
    else if ([flexDirectionString isEqualToString:@"row-reverse"]) {
        return YGFlexDirectionRowReverse;
    }
    return YGFlexDirectionRow;
}

-(YGJustify)token_getJustifyWithString:(NSString *)justifyContent{
    //justify-content
    if ([justifyContent isEqualToString:@"flex-start"]) {
        return YGJustifyFlexStart;
    }
    else if ([justifyContent isEqualToString:@"center"]) {
        return YGJustifyCenter;
    }
    else if ([justifyContent isEqualToString:@"flex-end"]) {
        return YGJustifyFlexEnd;
    }
    else if ([justifyContent isEqualToString:@"space-between"]) {
        return YGJustifySpaceBetween;
    }
    else if ([justifyContent isEqualToString:@"space-around"]) {
        return YGJustifySpaceAround;
    }
    return YGJustifyFlexStart;
}

-(YGAlign)token_getAlignWithString:(NSString *)align{
    //align-content
    if ([align isEqualToString:@"flex-start"]) {
        return YGAlignFlexStart;
    }
    else if ([align isEqualToString:@"center"]) {
        return YGAlignCenter;
    }
    else if ([align isEqualToString:@"flex-end"]) {
        return YGAlignFlexEnd;
    }
    else if ([align isEqualToString:@"space-between"]) {
        return YGAlignSpaceBetween;
    }
    else if ([align isEqualToString:@"stretch"]) {
        return YGAlignStretch;
    }
    else if ([align isEqualToString:@"space-around"]) {
        return YGAlignSpaceAround;
    }
    else if ([align isEqualToString:@"baseline"]) {
        return YGAlignBaseline;
    }
    return YGAlignAuto;
}

-(YGWrap)token_getFlexWrapWithString:(NSString *)wrap{
    //flex-wrap
    if ([wrap isEqualToString:@"nowrap"]) {
        return YGWrapNoWrap;
    }
    else if ([wrap isEqualToString:@"wrap"]) {
        return YGWrapWrap;
    }
    else if ([wrap isEqualToString:@"wrap-reverse"]) {
        return YGWrapWrapReverse;
    }
    return YGWrapWrap;
}

-(YGOverflow)token_getOverflowWithString:(NSString *)overflow{
    if ([overflow isEqualToString:@"visible"]) {
        self.clipsToBounds = NO;
        return YGOverflowVisible;
    }
    else if ([overflow isEqualToString:@"hidden"]) {
        self.clipsToBounds = YES;
        return YGOverflowHidden;
    }
    else if ([overflow isEqualToString:@"scroll"]) {
        return YGOverflowScroll;
    }
    return YGOverflowVisible;
}

-(YGPositionType)token_getPositionTypeWithString:(NSString *)positionTyle{
    if ([positionTyle isEqualToString:@"relative"]) {
        return YGPositionTypeRelative;
    }
    else if ([positionTyle isEqualToString:@"absolute"]) {
        return YGPositionTypeAbsolute;
    }
    return YGPositionTypeRelative;
}

-(YGDisplay)token_getDisplayWithString:(NSString *)display{
    if ([display isEqualToString:@"flex"]) {
        self.hidden = NO;
        return YGDisplayFlex;
    }
    else if ([display isEqualToString:@"none"]) {
        self.hidden = YES;
        return YGDisplayNone;
    }
    return YGDisplayFlex;
}
@end
