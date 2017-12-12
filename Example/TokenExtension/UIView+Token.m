//
//  UIView+Token.m
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "UIView+Token.h"

@implementation UIView (Token)

+(TokenUIViewCGRectInstanceBlock)token_initWithFrame{
    return ^__kindof UIView *(CGRect frame) {
        return  [[self alloc] initWithFrame:frame];
    };
}

-(TokenUIViewCGFloatSetBlock)token_setOrignX{
    return ^__kindof UIView *(CGFloat value) {
        CGRect newFrame = self.frame;
        newFrame.origin.x = value;
        self.frame = newFrame;
        return self;
    };
}

-(TokenUIViewCGFloatGetBlock)token_orignX{
    return ^CGFloat{
        return self.frame.origin.x;
    };
}

-(TokenUIViewCGFloatSetBlock)token_setOrignY{
    return ^UIView *(CGFloat value) {
        CGRect newFrame = self.frame;
        newFrame.origin.y = value;
        self.frame = newFrame;
        return self;
    };
}

-(TokenUIViewCGFloatGetBlock)token_orignY{
    return ^CGFloat{
        return self.frame.origin.y;
    };
}

-(TokenUIViewCGFloatSetBlock)token_setCenterX{
    return ^UIView *(CGFloat value) {
        self.center=CGPointMake(value, self.center.y);
        return self;
    };
}

-(TokenUIViewCGFloatGetBlock)token_centerX{
    return ^CGFloat{
        return self.frame.origin.x;
    };
}


-(TokenUIViewCGFloatGetBlock)token_centerY{
    return ^CGFloat{
        return self.frame.origin.y;
    };
}

-(TokenUIViewCGFloatGetBlock)token_maxX{
    return ^CGFloat{
        return CGRectGetMaxX(self.frame);
    };
}

-(TokenUIViewCGFloatGetBlock)token_maxY{
    return ^CGFloat{
        return CGRectGetMaxY(self.frame);
    };
}

-(TokenUIViewCGFloatGetBlock)token_minY{
    return ^CGFloat{
        return CGRectGetMinY(self.frame);
    };
}

-(TokenUIViewCGFloatGetBlock)token_minX{
    return ^CGFloat{
        return CGRectGetMinX(self.frame);
    };
}

-(TokenUIViewCGFloatGetBlock)token_width{
    return ^CGFloat{
        return CGRectGetWidth(self.frame);
    };
}

-(TokenUIViewCGFloatSetBlock)token_setWidth{
    return ^__kindof UIView *(CGFloat value) {
        CGPoint origin = self.frame.origin;
        self.frame = CGRectMake(origin.x, origin.y, value, self.frame.size.height);
        return self;
    };
}

-(TokenUIViewCGFloatSetBlock)token_setHeight{
    return ^__kindof UIView *(CGFloat value) {
        CGPoint origin = self.frame.origin;
        self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, value);
        return self;
    };
}

-(TokenUIViewCGFloatGetBlock)token_height{
    return ^CGFloat{
        return CGRectGetHeight(self.frame);
    };
}

-(TokenUIViewCGRectSetBlock)token_setFrame{
    return ^__kindof UIView *(CGRect frame) {
        self.frame = frame;
        return self;
    };
}


-(TokenUIViewCGSizeSetBlock)token_setSize{
    return ^__kindof UIView *(CGSize size) {
        self.frame = (CGRect){self.frame.origin.x,self.frame.origin.x,size};
        return self;
    };
}

-(TokenUIViewCGSizeGetBlock)token_size{
    return ^CGSize (void){
        return self.frame.size;
    };
}

#pragma mark - 

-(TokenUIViewTagSetBlock)token_setTag{
    return ^__kindof UIView *(NSInteger tag){
        self.tag = tag;
        return self;
    };
}

-(TokenUIViewBOOLBlock)token_setClipsToBounds{
    return ^__kindof UIView *(BOOL value) {
        self.clipsToBounds = value;
        return self;
    };
}

-(TokenUIViewBOOLBlock)token_setHidden{
    return ^__kindof UIView *(BOOL value) {
        self.hidden = value;
        return self;
    };
}

-(TokenUIViewColorSetBlock)token_setBackgroundColor{
    return ^__kindof UIView *(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

-(TokenUIViewColorSetBlock)token_setTintColor{
    return ^__kindof UIView *(UIColor *color) {
        self.tintColor = color;
        return self;
    };
}


-(TokenUIViewCGFloatSetBlock)token_setAlpha{
    return ^__kindof UIView *(CGFloat value) {
        self.alpha = value;
        return self;
    };
}


-(TokenUIViewContentModeSetBlock)token_setContentMode{
    return ^__kindof UIView *(UIViewContentMode mode) {
        self.contentMode = mode;
        return self;
    };
}

-(TokenUIViewSubViewOperationBlock)token_addSubview{
    return ^__kindof UIView *(UIView *subView) {
        [self addSubview:subView];
        return self;
    };
}

-(TokenUIViewSubViewOperationBlock)token_bringSubviewToFront{
    return ^__kindof UIView *(UIView *subView) {
        [self bringSubviewToFront:subView];
        return self;
    };
}

-(TokenUIViewSubViewOperationBlock)token_sendSubviewToBack{
    return ^__kindof UIView *(UIView *subView) {
        [self sendSubviewToBack:subView];
        return self;
    };
}

-(TokenUIViewInsertOperationBlock)token_insertSubviewAtIndex{
    return ^__kindof UIView *(UIView *subView, NSInteger index) {
        [self insertSubview:subView atIndex:index];
        return self;
    };
}

-(TokenUIViewOperationBlock)token_removeFromSuperview{
    return ^__kindof UIView *(void){
        [self removeFromSuperview];
        return self;
    };
}

-(TokenUIViewOtherInsertOperationBlock)token_insertSubviewBelowSubView{
    return ^__kindof UIView *(UIView *subView1, UIView *subView2) {
        [self insertSubview:subView1 belowSubview:subView2];
        return self;
    };
}

-(TokenUIViewOtherInsertOperationBlock)token_insertSubviewAboveSubView{
    return ^__kindof UIView *(UIView *subView1, UIView *subView2) {
        [self insertSubview:subView1 aboveSubview:subView2];
        return self;
    };
}

-(TokenUIViewBOOLBlock)token_snapshotViewAfterScreenUpdates{
    return ^__kindof UIView *(BOOL value) {
        return [self snapshotViewAfterScreenUpdates:value];
    };
}

-(TokenUIViewGestureRecognizerBlock)token_addGestureRecognizer{
    return ^__kindof UIView *(UIGestureRecognizer *gestureRecognizer){
        [self addGestureRecognizer:gestureRecognizer];
        return self;
    };
}

-(TokenUIViewGestureRecognizerBlock)token_removeGestureRecognizer{
    return ^__kindof UIView *(UIGestureRecognizer *gestureRecognizer){
        [self removeGestureRecognizer:gestureRecognizer];
        return self;
    };
}

@end

@implementation UIControl (Token)

-(TokenControlTargetBlock)token_addTarget{
    return ^__kindof UIControl *(id target, SEL action, UIControlEvents controlEvents) {
        [self addTarget:target action:action forControlEvents:controlEvents];
        return self;
    };
}

@end

@implementation UIButton (Token)

+(TokenButtonTypeInstanceBlock)token_buttonWithType{
    return ^__kindof UIButton *(UIButtonType type) {
        return [self buttonWithType:type];
    };
}

-(TokenButtonSetTitleBlock)token_setTitleWithState{
    return  ^__kindof UIButton *(NSString *title, UIControlState state) {
        [self setTitle:title forState:state];
        return self;
    };
}

-(TokenButtonsetAttributedTitleBlock)token_setAttributedTitleWithState{
    return  ^__kindof UIButton *(NSAttributedString *title, UIControlState state) {
        [self setAttributedTitle:title forState:state];
        return self;
    };
}

-(TokenButtonSetColorBlock)token_setTitleColorWithState{
    return ^__kindof UIButton *(UIColor *titleColor, UIControlState state) {
        [self setTitleColor:titleColor forState:state];
        return self;
    };
}

-(TokenButtonSetImageBlock)token_setImageWithState{
    return ^__kindof UIButton *(UIImage *image, UIControlState state) {
        [self setImage:image forState:state];
        return self;
    };
}

-(TokenButtonSetImageBlock)token_setBackgroundImageWithState{
    return ^__kindof UIButton *(UIImage *image, UIControlState state) {
        [self setBackgroundImage:image forState:state];
        return self;
    };
}

@end



