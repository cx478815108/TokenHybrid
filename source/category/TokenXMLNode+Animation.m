//
//  TokenXMLNode+Animation.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/4.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenXMLNode+Animation.h"
#import "JSValue+Token.h"
#import "UIColor+SSRender.h"
#import <ChainableAnimations/ChainableAnimations.h>

@implementation TokenJSAnimation
{
    JHChainableAnimator *_animator;
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _animator = [[JHChainableAnimator alloc] initWithView:view];
    }
    return self;
}

#pragma mark -

-(TokenJSAnimation *)moveX:(JSValue *)xValue{
    if (![xValue token_isNilObject]) {
        _animator.moveX([[xValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)moveY:(JSValue *)yValue{
    if (![yValue token_isNilObject]) {
        _animator.moveY([[yValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)moveXY:(JSValue *)xValue yValue:(JSValue *)yValue{
    if (![xValue token_isNilObject] && ![yValue token_isNilObject]) {
        _animator.moveXY([[xValue toNumber] floatValue],[[yValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeFrame:(JSValue *)frameValue{
    if (![frameValue token_isNilObject]) {
        CGRect frame = CGRectFromString([frameValue toString]);
        _animator.makeFrame(frame);
    }
    return self;
}

-(TokenJSAnimation *)makeSize:(JSValue *)widthValue height:(JSValue *)heightValue{
    if (![widthValue token_isNilObject] && ![heightValue token_isNilObject]) {
        _animator.makeSize([[widthValue toNumber] floatValue],[[heightValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeCenter:(JSValue *)xValue y:(JSValue *)yValue{
    if (![xValue token_isNilObject] && ![yValue token_isNilObject]) {
        _animator.makeCenter([[xValue toNumber] floatValue],[[yValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeWidth:(JSValue *)widthValue{
    if (![widthValue token_isNilObject]) {
        _animator.makeWidth([[widthValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeHeight:(JSValue *)heightValue{
    if (![heightValue token_isNilObject]) {
        _animator.makeHeight([[heightValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeOpacity:(JSValue *)opacityValue{
    if (![opacityValue token_isNilObject]) {
        _animator.makeOpacity([[opacityValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeBackground:(JSValue *)backgroundValue{
    if (![backgroundValue token_isNilObject]) {
        _animator.makeBackground([UIColor ss_colorWithString:[backgroundValue toString]]);
    }
    return self;
}

-(TokenJSAnimation *)makeBorderWidth:(JSValue *)borderWidthValue{
    if (![borderWidthValue token_isNilObject]) {
        _animator.makeBorderWidth([[borderWidthValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeBorderColor:(JSValue *)borderColorValue{
    if (![borderColorValue token_isNilObject]) {
        _animator.makeBorderColor([UIColor ss_colorWithString:[borderColorValue toString]]);
    }
    return self;
}

-(TokenJSAnimation *)makeCornerRadius:(JSValue *)cornerRadiusValue{
    if (![cornerRadiusValue token_isNilObject]) {
        _animator.makeCornerRadius([[cornerRadiusValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeScale:(JSValue *)scaleValue{
    if (![scaleValue token_isNilObject]) {
        _animator.makeScale([[scaleValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeScaleX:(JSValue *)scaleXValue{
    if (![scaleXValue token_isNilObject]) {
        _animator.makeScaleX([[scaleXValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)makeScaleY:(JSValue *)scaleYValue{
    if (![scaleYValue token_isNilObject]) {
        _animator.makeScaleY([[scaleYValue toNumber] floatValue]);
    }
    return self;
}


-(TokenJSAnimation *)transformX:(JSValue *)transformXValue{
    if (![transformXValue token_isNilObject]) {
        _animator.transformX([[transformXValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)transformY:(JSValue *)transformYValue{
    if (![transformYValue token_isNilObject]) {
        _animator.transformY([[transformYValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)transformZ:(JSValue *)transformZValue{
    if (![transformZValue token_isNilObject]) {
        _animator.transformZ([[transformZValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)transformXY:(JSValue *)xValue yValue:(JSValue *)yValue{
    if (![xValue token_isNilObject] && ![yValue token_isNilObject]) {
        _animator.transformXY([[xValue toNumber] floatValue],[[yValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)transformScale:(JSValue *)transformScaleValue{
    if (![transformScaleValue token_isNilObject]) {
        _animator.transformScale([[transformScaleValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)transformScaleX:(JSValue *)transformScaleXValue{
    if (![transformScaleXValue token_isNilObject]) {
        _animator.transformScaleX([[transformScaleXValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)transformScaleY:(JSValue *)transformScaleYValue{
    if (![transformScaleYValue token_isNilObject]) {
        _animator.transformScaleY([[transformScaleYValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)rotate:(JSValue *)rotateValue{
    if (![rotateValue token_isNilObject]) {
        _animator.rotate([[rotateValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)rotateX:(JSValue *)rotateXValue{
    if (![rotateXValue token_isNilObject]) {
        _animator.rotateX([[rotateXValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)rotateY:(JSValue *)rotateYValue{
    if (![rotateYValue token_isNilObject]) {
        _animator.rotateY([[rotateYValue toNumber] floatValue]);
    }
    return self;
}

-(TokenJSAnimation *)rotateZ:(JSValue *)rotateZValue{
    if (![rotateZValue token_isNilObject]) {
        _animator.rotateZ([[rotateZValue toNumber] floatValue]);
    }
    return self;
}

-(void)animationWithDuration:(JSValue *)duration finish:(JSValue *)finish{
    if ([duration token_isNilObject]) return;
    dispatch_async(dispatch_get_main_queue(), ^{
       _animator.animate([[duration toNumber] floatValue]);
    });
    if (![finish token_isNilObject]) {
        [finish callWithArguments:nil];
    }
}

-(TokenJSAnimation *)thenAfter:(JSValue *)time{
    if ([time token_isNilObject]) {
        _animator.thenAfter(0);
        return self;
    };
    NSNumber *number = [time toNumber];
    _animator.thenAfter([number floatValue]);
    return self;
}

-(TokenJSAnimation *)repeatWithTime:(JSValue *)time count:(JSValue *)count{
    if ([time token_isNilObject] || [count token_isNilObject]) {
        _animator.repeat(0.25,1);
        return self;
    };
    _animator.repeat([[time toNumber] integerValue],[[count toNumber] integerValue]);
    return self;
}

-(TokenJSAnimation *)easeIn{
    [_animator.easeIn isAnimating];
    return self;
}

-(TokenJSAnimation *)easeOut{
    [_animator.easeOut isAnimating];
    return self;
}

-(TokenJSAnimation *)easeBack{
    [_animator.easeBack isAnimating];
    return self;
}

-(TokenJSAnimation *)spring{
    [_animator.spring isAnimating];
    return self;
}

-(TokenJSAnimation *)bounce{
    [_animator.bounce isAnimating];
    return self;
}

- (TokenJSAnimation *)easeInOut {
    [_animator.easeInOut isAnimating];
    return self;
}

@end

@implementation TokenPureNode (Animation)
-(TokenJSAnimation *)startAnimation{
    UIView *view = self.associatedView;
    if (view == nil) {
        return nil;
    };
    TokenJSAnimation *obj = [[TokenJSAnimation alloc] initWithView:view];
    return obj;
}

- (void)fixBug:(JSValue *)bug {}

@end
