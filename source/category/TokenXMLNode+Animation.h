//
//  TokenXMLNode+Animation.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/4.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenXMLNode.h"

@import JavaScriptCore;
@class TokenJSAnimation;
#pragma mark - animation
@protocol TokenAnimationExport <JSExport>
@optional
JSExportAs(moveX, -(TokenJSAnimation *)moveX:(JSValue *)xValue);
JSExportAs(moveY, -(TokenJSAnimation *)moveY:(JSValue *)yValue);
JSExportAs(moveXY, -(TokenJSAnimation *)moveXY:(JSValue *)xValue yValue:(JSValue *)yValue);

JSExportAs(makeFrame, -(TokenJSAnimation *)makeFrame:(JSValue *)frameValue);
JSExportAs(makeSize, -(TokenJSAnimation *)makeSize:(JSValue *)widthValue height:(JSValue *)heightValue);
JSExportAs(makeCenter, -(TokenJSAnimation *)makeCenter:(JSValue *)xValue y:(JSValue *)yValue);
JSExportAs(makeWidth, -(TokenJSAnimation *)makeWidth:(JSValue *)widthValue);
JSExportAs(makeHeight, -(TokenJSAnimation *)makeHeight:(JSValue *)heightValue);

JSExportAs(makeOpacity, -(TokenJSAnimation *)makeOpacity:(JSValue *)opacityValue);
JSExportAs(makeBackground, -(TokenJSAnimation *)makeBackground:(JSValue *)backgroundValue);
JSExportAs(makeBorderColor, -(TokenJSAnimation *)makeBorderColor:(JSValue *)borderColorValue);
JSExportAs(makeBorderWidth, -(TokenJSAnimation *)makeBorderWidth:(JSValue *)borderWidthValue);
JSExportAs(makeCornerRadius, -(TokenJSAnimation *)makeCornerRadius:(JSValue *)cornerRadiusValue);

JSExportAs(makeScale, -(TokenJSAnimation *)makeScale:(JSValue *)scaleValue);
JSExportAs(makeScaleX, -(TokenJSAnimation *)makeScaleX:(JSValue *)scaleXValue);
JSExportAs(makeScaleY, -(TokenJSAnimation *)makeScaleY:(JSValue *)scaleYValue);

JSExportAs(transformX, -(TokenJSAnimation *)transformX:(JSValue *)transformXValue);
JSExportAs(transformY, -(TokenJSAnimation *)transformY:(JSValue *)transformYValue);
JSExportAs(transformZ, -(TokenJSAnimation *)transformZ:(JSValue *)transformZValue);
JSExportAs(transformXY, -(TokenJSAnimation *)transformXY:(JSValue *)xValue yValue:(JSValue *)yValue);
JSExportAs(transformScale, -(TokenJSAnimation *)transformScale:(JSValue *)transformScaleValue);
JSExportAs(transformScaleX, -(TokenJSAnimation *)transformScaleX:(JSValue *)transformScaleXValue);
JSExportAs(transformScaleY, -(TokenJSAnimation *)transformScaleY:(JSValue *)transformScaleYValue);

JSExportAs(rotate, -(TokenJSAnimation *)rotate:(JSValue *)rotateValue);
JSExportAs(rotateX, -(TokenJSAnimation *)rotateX:(JSValue *)rotateXValue);
JSExportAs(rotateY, -(TokenJSAnimation *)rotateY:(JSValue *)rotateYValue);
JSExportAs(rotateZ, -(TokenJSAnimation *)rotateZ:(JSValue *)rotateZValue);

JSExportAs(commit, -(void)animationWithDuration:(JSValue *)duration finish:(JSValue *)finishValue);
JSExportAs(repeat, - (TokenJSAnimation *)repeatWithTime:(JSValue *)time count:(JSValue *)countValue);
- (TokenJSAnimation *)easeIn;
- (TokenJSAnimation *)easeOut;
- (TokenJSAnimation *)easeInOut;
- (TokenJSAnimation *)easeBack;
- (TokenJSAnimation *)spring;
- (TokenJSAnimation *)bounce;
- (TokenJSAnimation *)thenAfter:(JSValue *)time;
@end

@interface TokenJSAnimation :NSObject<TokenAnimationExport>
- (instancetype)initWithView:(UIView *)view;
@end

@protocol TokenAnimationStart <JSExport>
@optional
JSExportAs(fixBug, -(void)fixBug:(JSValue *)bug);
-(TokenJSAnimation *)startAnimation;
@end

@interface TokenPureNode (Animation) <TokenAnimationStart>

@end
