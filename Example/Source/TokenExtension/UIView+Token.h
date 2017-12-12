//
//  UIView+Token.h
//  掌理教务处
//
//  Created by 陈雄 on 2017/9/13.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef __kindof UIView *(^TokenUIViewCGRectInstanceBlock)(CGRect frame);
typedef __kindof UIView *(^TokenUIViewCGFloatSetBlock)(CGFloat value);
typedef CGFloat (^TokenUIViewCGFloatGetBlock)(void);
typedef __kindof UIView *(^TokenUIViewCGSizeSetBlock)(CGSize size);
typedef CGSize  (^TokenUIViewCGSizeGetBlock)(void);
typedef __kindof UIView *(^TokenUIViewCGRectSetBlock)(CGRect rect);
typedef __kindof UIView *(^TokenUIViewBOOLBlock)(BOOL value);
typedef __kindof UIView  *(^TokenUIViewColorSetBlock)(UIColor *color);
typedef __kindof CALayer *(^TokenUIViewLayerGetBlock)(void);
typedef __kindof UIView *(^TokenUIViewTagSetBlock)(NSInteger tag);
typedef __kindof UIView *(^TokenUIViewGetBlock)(void);
typedef __kindof UIView  *(^TokenUIViewContentModeSetBlock)(UIViewContentMode mode);
typedef __kindof UIView *(^TokenUIViewSubViewOperationBlock)(UIView *subView);
typedef __kindof UIView *(^TokenUIViewOperationBlock)(void);
typedef __kindof UIView *(^TokenUIViewInsertOperationBlock)(UIView *subView,NSInteger index);
typedef __kindof UIView *(^TokenUIViewOtherInsertOperationBlock)(UIView *subView1,UIView *subView2);
typedef __kindof UIView *(^TokenUIViewGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizerBlock);

@interface UIView (Token)
@property (nonatomic ,copy ,readonly,class) TokenUIViewCGRectInstanceBlock  token_initWithFrame;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatSetBlock            token_setOrignX;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_orignX;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatSetBlock            token_setOrignY;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_orignY;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatSetBlock            token_setCenterX;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_centerX;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_centerY;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_maxX;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_minX;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_maxY;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_minY;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatSetBlock            token_setWidth;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_width;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatSetBlock            token_setHeight;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatGetBlock            token_height;
@property (nonatomic ,copy ,readonly) TokenUIViewCGSizeSetBlock             token_setSize;
@property (nonatomic ,copy ,readonly) TokenUIViewCGSizeGetBlock             token_size;
@property (nonatomic ,copy ,readonly) TokenUIViewCGRectSetBlock             token_setFrame;
@property (nonatomic ,copy ,readonly) TokenUIViewBOOLBlock                  token_setClipsToBounds;
@property (nonatomic ,copy ,readonly) TokenUIViewTagSetBlock                token_setTag;
@property (nonatomic ,copy ,readonly) TokenUIViewBOOLBlock                  token_setHidden;
@property (nonatomic ,copy ,readonly) TokenUIViewColorSetBlock              token_setBackgroundColor;
@property (nonatomic ,copy ,readonly) TokenUIViewColorSetBlock              token_setTintColor;
@property (nonatomic ,copy ,readonly) TokenUIViewCGFloatSetBlock            token_setAlpha;
@property (nonatomic ,copy ,readonly) TokenUIViewContentModeSetBlock        token_setContentMode;
@property (nonatomic ,copy ,readonly) TokenUIViewSubViewOperationBlock      token_addSubview;
@property (nonatomic ,copy ,readonly) TokenUIViewSubViewOperationBlock      token_bringSubviewToFront;
@property (nonatomic ,copy ,readonly) TokenUIViewSubViewOperationBlock      token_sendSubviewToBack;
@property (nonatomic ,copy ,readonly) TokenUIViewInsertOperationBlock       token_insertSubviewAtIndex;
@property (nonatomic ,copy ,readonly) TokenUIViewOtherInsertOperationBlock  token_insertSubviewBelowSubView;
@property (nonatomic ,copy ,readonly) TokenUIViewOtherInsertOperationBlock  token_insertSubviewAboveSubView;
@property (nonatomic ,copy ,readonly) TokenUIViewOperationBlock             token_removeFromSuperview;
@property (nonatomic ,copy ,readonly) TokenUIViewBOOLBlock                  token_snapshotViewAfterScreenUpdates;
@property (nonatomic ,copy ,readonly) TokenUIViewGestureRecognizerBlock     token_addGestureRecognizer;
@property (nonatomic ,copy ,readonly) TokenUIViewGestureRecognizerBlock     token_removeGestureRecognizer;
@end

typedef __kindof UIControl * (^TokenControlTargetBlock)(id target,SEL action ,UIControlEvents controlEvents);

@interface UIControl (Token)
@property (nonatomic ,copy ,readonly) TokenControlTargetBlock token_addTarget;
@end

typedef __kindof UIButton *(^TokenButtonTypeInstanceBlock)(UIButtonType type);
typedef __kindof UIButton *(^TokenButtonSetTitleBlock)(NSString *title,UIControlState state);
typedef __kindof UIButton *(^TokenButtonsetAttributedTitleBlock)(NSAttributedString *title,UIControlState state);
typedef __kindof UIButton *(^TokenButtonSetColorBlock)(UIColor *titleColor,UIControlState state);
typedef __kindof UIButton *(^TokenButtonSetImageBlock)(UIImage *image,UIControlState state);

typedef __kindof UIButton * (^TokenButtonTargetBlock)(id target,SEL action ,UIControlEvents controlEvents);

@interface UIButton (Token)
@property (nonatomic ,copy ,readonly,class) TokenButtonTypeInstanceBlock   token_buttonWithType;
@property (nonatomic ,copy ,readonly) TokenButtonSetTitleBlock             token_setTitleWithState;
@property (nonatomic ,copy ,readonly) TokenButtonsetAttributedTitleBlock   token_setAttributedTitleWithState;
@property (nonatomic ,copy ,readonly) TokenButtonSetColorBlock             token_setTitleColorWithState;
@property (nonatomic ,copy ,readonly) TokenButtonSetImageBlock             token_setImageWithState;
@property (nonatomic ,copy ,readonly) TokenButtonSetImageBlock             token_setBackgroundImageWithState;
@property (nonatomic ,copy ,readonly) TokenButtonTargetBlock               token_addTarget;
@end









