//
//  TokenXMLNode+JavascriptSupport.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenXMLNode+JSExport.h"

#import "TokenLabelComponent.h"
#import "TokenButtonComponent.h"
#import "TokenScrollComponent.h"
#import "TokenSwitchComponent.h"
#import "TokenSegmentedComponent.h"
#import "TokenTableComponent.h"
#import "TokenInputComponent.h"
#import "TokenTextAreaComponent.h"
#import "TokenSearchBarComponent.h"
#import "TokenImageComponent.h"
#import "TokenWebViewComponent.h"
#import "TokenPageControl.h"

#import "TokenHybridRenderController.h"
#import "TokenJSContext.h"

#import "JSValue+Token.h"
#import "UIView+Token.h"
#import "UIColor+SSRender.h"
#import "TokenComponent+pullRefresh.h"

#import "MJRefresh/MJRefresh.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "UIView+WebCache.h"

@implementation TokenXMLNode (JavascriptSupport)

-(TokenXMLNode *)getElementById:(NSString *)elementId{
    __block TokenXMLNode *node = nil;
    [TokenXMLNode enumerateTreeFromRootToChildWithNode:self block:^(TokenXMLNode *obj ,BOOL *stop) {
        if ([obj.innerAttributes[@"id"] isEqualToString:elementId]) {
            node = obj;
            *stop = YES;
        }
    }];
    return node;
}

-(NSArray<TokenXMLNode *> *)getElementsByTagName:(NSString *)tagName{
    NSMutableArray *eles = @[].mutableCopy;
    [TokenXMLNode enumerateTreeFromRootToChildWithNode:self block:^(TokenXMLNode *node, BOOL *stop) {
        if ([node.name isEqualToString:tagName]) {
            [eles addObject:node];
        }
    }];
    return eles;
}

-(NSArray<TokenXMLNode *> *)getElementsByClassName:(NSString *)className{
    NSMutableArray *eles = @[].mutableCopy;
    [TokenXMLNode enumerateTreeFromRootToChildWithNode:self block:^(TokenXMLNode *node ,BOOL *stop) {
        NSString *clsString = node.innerAttributes[@"class"];
        if (clsString && clsString.length) {
            NSArray *nodeClasses = [clsString componentsSeparatedByString:@" "];
            if ([nodeClasses containsObject:className]) {
                [eles addObject:node];
            }
        }
    }];
    return eles;
}
@end

@implementation TokenDocument (JavascriptSupport)
-(TokenXMLNode *)getElementById:(NSString *)elementId{
    TokenXMLNode *node = [self.bodyNode getElementById:elementId];
    if (node) { return node;}
    return [self.headNode getElementById:elementId];
}

-(NSArray<TokenXMLNode *> *)getElementsByClassName:(NSString *)className{
    NSArray *results = [self.bodyNode getElementsByClassName:className];
    NSArray *results2 = [self.headNode getElementsByClassName:className];
    NSMutableArray *array = [NSMutableArray arrayWithArray:results];
    if (results2.count) {
        [array addObjectsFromArray:results2];
    }
    return array;
}

-(NSArray<TokenXMLNode *> *)getElementsByTagName:(NSString *)tagName{
    NSArray *results = [self.bodyNode getElementsByTagName:tagName];
    NSArray *results2 = [self.headNode getElementsByTagName:tagName];
    NSMutableArray *array = [NSMutableArray arrayWithArray:results];
    if (results2.count) {
        [array addObjectsFromArray:results2];
    }
    return array;
}

-(void)pushNavigatorWithURL:(NSString *)htmlURL extension:(JSValue *)value{
    if (htmlURL && htmlURL.length) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIViewController *currentController = [self.jsContext getContainerController];
            TokenHybridRenderController *nextController;
            
            if (self.jsContext ) {
                nextController = [[[self.jsContext getViewPushedControllerClass] alloc] initWithHTMLURL:htmlURL];
            }
            else {
                nextController = [[TokenHybridRenderController alloc] initWithHTMLURL:htmlURL];
            }
            if (![value token_isNilObject]) {
                NSDictionary *extension = [value toObject];
                if ([extension isKindOfClass:[NSDictionary class]]) {
                    nextController.extension = extension;
                }
                nextController.previousController = (TokenHybridRenderController *)currentController;
            }
            [currentController.navigationController pushViewController:nextController animated:YES];
            
        });
    }
}

-(void)popNavigator{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *currentControlelr = [self.jsContext getContainerController];
        [currentControlelr.navigationController popViewControllerAnimated:YES];
    });
}

-(void)setTitle:(NSString *)title{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *currentControlelr = [self.jsContext getContainerController];
        currentControlelr.title = title;
    });
}

@end

@implementation TokenPureNode (Basic)
-(void)setSize:(JSValue *)widthValue height:(JSValue *)heightValue{
    if ([widthValue token_isNilObject] || [heightValue token_isNilObject]) return ;
    NSNumber *width = [widthValue toNumber];
    NSNumber *height = [heightValue toNumber];
    if (self.associatedView) {
        self.associatedView.token_setSize(CGSizeMake([width floatValue], [height floatValue]));
    }
}

-(void)setOrigin:(JSValue *)originX originY:(JSValue *)originY{
    if ([originX token_isNilObject] || [originY token_isNilObject]) return ;
    NSNumber *originXNumber = [originX toNumber];
    NSNumber *originYNumber = [originY toNumber];
    if (self.associatedView) {
        self.associatedView.token_setOrignX([originXNumber floatValue]);
        self.associatedView.token_setOrignY([originYNumber floatValue]);
    }
}

-(NSNumber *)componentWidth{
    return @(self.associatedView.token_width());
}

-(NSNumber *)componentHeight{
    return @(self.associatedView.token_height());
}

-(NSNumber *)originX{
    return @(self.associatedView.token_orignX());
}

-(NSNumber *)originY{
    return @(self.associatedView.token_orignY());
}

-(NSNumber *)centerX{
    return @(self.associatedView.token_centerX());
}

-(NSNumber *)centerY{
    return @(self.associatedView.token_centerY());
}
-(NSNumber *)maxX{
    return @(self.associatedView.token_maxX());
}

-(NSNumber *)maxY{
    return @(self.associatedView.token_maxY());
}

-(void)setHidden:(JSValue *)hiddenValue{
    self.associatedView.hidden = [hiddenValue toBool];
}

-(void)setBackgroundColor:(JSValue *)colorValue{
    if ([colorValue token_isNilObject]) {
        return;
    }
    self.associatedView.backgroundColor = [UIColor ss_colorWithString:[colorValue toString]];
}

-(void)setCornerRadius:(JSValue *)radiusValue{
    if ([radiusValue token_isNilObject]) {
        return;
    }
    self.associatedView.layer.cornerRadius = [[radiusValue toNumber] floatValue];
}

-(void)setBorderColor:(JSValue *)colorValue{
    if ([colorValue token_isNilObject]) {
        return;
    }
    self.associatedView.layer.borderColor = [UIColor ss_colorWithString:[colorValue toString]].CGColor;
}


-(void)setBorderWidth:(JSValue *)widthValue{
    if ([widthValue token_isNilObject]) {
        return;
    }
    self.associatedView.layer.borderWidth = [[widthValue toNumber] floatValue];
}

-(void)setUserInteractionEnabled:(JSValue *)value{
    self.associatedView.userInteractionEnabled = [value toBool];
}

@end

@implementation TokenScrollNode (scrollView)
-(void)scrollToTopAnimate:(JSValue *)value{
    TokenScrollComponent *view = self.associatedView;
    CGPoint offset = view.contentOffset;
    offset.y = -view.contentInset.top;
    offset.x = -view.contentInset.left;
    [view setContentOffset:offset animated:[value toBool]];
}

-(void)showHBar:(JSValue *)value{
    TokenScrollComponent *view = self.associatedView;
    view.showsHorizontalScrollIndicator = [value toBool];
}

-(void)showVBar:(JSValue *)value{
    TokenScrollComponent *view = self.associatedView;
    view.showsVerticalScrollIndicator = [value toBool];
}

-(void)scrollEnable:(JSValue *)value{
    TokenScrollComponent *view = self.associatedView;
    view.scrollEnabled = [value toBool];
}

-(void)pageEnable:(JSValue *)value{
    TokenScrollComponent *view = self.associatedView;
    view.pagingEnabled = [value toBool];
}

-(void)openHeaderRefresh{
    TokenScrollComponent *view = self.associatedView;
    [view openHeaderRefresh];
}

-(void)stopHeaderRefresh{
    TokenScrollComponent *view = self.associatedView;
    [view stopHeaderRefresh];
}

-(void)hiddenHeaderRefresh{
    TokenScrollComponent *view = self.associatedView;
    [view hiddenHeaderRefresh];
}

-(void)openFooterRefresh{
    TokenScrollComponent *view = self.associatedView;
    [view openFooterRefresh];
}

-(void)stopFooterRefresh{
    TokenScrollComponent *view = self.associatedView;
    [view stopFooterRefresh];
}

-(void)hiddenFooterRefresh{
    TokenScrollComponent *view = self.associatedView;
    [view hiddenFooterRefresh];
}

-(void)setScrollInsetWithTop:(JSValue *)top
                        left:(JSValue *)left
                      bottom:(JSValue *)bottom
                       right:(JSValue *)right{
    if ([top token_isNilObject] || [left token_isNilObject] || [bottom token_isNilObject] || [right token_isNilObject]) {
        return;
    }
    TokenScrollComponent *view = self.associatedView;
    view.contentInset = UIEdgeInsetsMake([[top toNumber] floatValue],
                                         [[left toNumber] floatValue],
                                         [[bottom toNumber] floatValue],
                                         [[right toNumber] floatValue]);
}

-(void)setContentSizeWithWidth:(JSValue *)width height:(JSValue *)height{
    if ([width token_isNilObject] || [height token_isNilObject]) {
        return;
    }
    TokenScrollComponent *view = self.associatedView;
    view.contentSize = CGSizeMake([[width toNumber] floatValue], [[height toNumber] floatValue]);
}

-(NSNumber *)offsetX{
    if (self.associatedView == nil) {
        return @(-1);
    }
    TokenScrollComponent *view = self.associatedView;
    return @(view.contentOffset.x);
}

-(NSNumber *)offsetY{
    if (self.associatedView == nil) {
        return @(-1);
    }
    TokenScrollComponent *view = self.associatedView;
    return @(view.contentOffset.y);
}

-(void)setJSOnHeaderRefresh:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onHeaderRefresh = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnFooterRefresh:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onFooterRefresh = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnScroll:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.didScroll = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnEndDecelerating:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.didEndDecelerating = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

@end

@implementation TokenButtonNode (Button)
-(void)setJSOnClick:(JSValue *)clickValue{
    [(TokenJSContext *)clickValue.context keepEventValueAlive:clickValue];
    self.onClick = [clickValue token_isNilObject]?nil:[JSManagedValue managedValueWithValue:clickValue andOwner:self];
}

-(void)setSelectedTitle:(JSValue *)title{
    TokenButtonComponent *button = self.associatedView;
    [button setTitle:[title toString]  forState:(UIControlStateSelected)];
}

-(void)setHightTitle:(JSValue *)title{
    TokenButtonComponent *button = self.associatedView;
    [button setTitle:[title toString]  forState:(UIControlStateHighlighted)];
}

-(void)setTitle:(JSValue *)title{
    TokenButtonComponent *button = self.associatedView;
    [button setTitle:[title toString]  forState:(UIControlStateNormal)];
}
-(void)setHightTitleColor:(JSValue *)color{
    if ([color token_isNilObject]) {
        return;
    }
   TokenButtonComponent *button = self.associatedView;
    NSString *stringColor = [color toString];
    [button setTitleColor:[UIColor ss_colorWithString:stringColor] forState:(UIControlStateHighlighted)];
}

-(void)setTitleColor:(JSValue *)color{
    if ([color token_isNilObject]) {
        return;
    }
    TokenButtonComponent *button = self.associatedView;
    NSString *stringColor = [color toString];
    [button setTitleColor:[UIColor ss_colorWithString:stringColor] forState:(UIControlStateNormal)];
}

-(void)setSelectedTitleColor:(JSValue *)color{
    if ([color token_isNilObject]) {
        return;
    }
    TokenButtonComponent *button = self.associatedView;
    NSString *stringColor = [color toString];
    [button setTitleColor:[UIColor ss_colorWithString:stringColor] forState:(UIControlStateSelected)];
}

-(void)setSelectedBackgroundColor:(JSValue *)color{
    TokenButtonComponent *button = self.associatedView;
    NSString *stringColor = [color toString];
    button.selectedBackgroundColor = [UIColor ss_colorWithString:stringColor];
}

-(void)setFont:(JSValue *)fontValue{
    if ([fontValue token_isNilObject]) return;
    JSValue *fontName = fontValue[@"fontName"];
    JSValue *fontSize = fontValue[@"size"];
    TokenButtonComponent *button = self.associatedView;
    button.titleLabel.font = [UIFont fontWithName:[fontName toString] size:[[fontSize toNumber] floatValue]];
}

-(BOOL)isSelected{
    TokenButtonComponent *button = self.associatedView;
    return button.isSelected;
}

- (void)setSelected:(JSValue *)value {
    TokenButtonComponent *button = self.associatedView;
    button.selected = [value toBool];
}

@end

@implementation TokenImageNode (Image)
- (void)setImage:(JSValue *)image animate:(JSValue *)animate{
    if ([image token_isNilObject]) {
        return;
    }
    TokenImageComponent *imageView = self.associatedView;
    NSURL *url = [NSURL URLWithString:[image toString]];
    BOOL showActivity = animate?[animate toBool]:NO;
    if (showActivity) {
        [imageView sd_setShowActivityIndicatorView:showActivity];
        [imageView sd_setIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    }
    
    [imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (showActivity) {
            [imageView sd_removeActivityIndicator];
        }
    }];
}

-(void)setJSOnClick:(JSValue *)clickValue{
    TokenImageComponent *imageView = self.associatedView;
    [imageView addTapGestureRecognizer];
    [(TokenJSContext *)clickValue.context keepEventValueAlive:clickValue];
    self.onClick = [clickValue token_isNilObject]?nil:[JSManagedValue managedValueWithValue:clickValue andOwner:self];
}

@end

@implementation TokenLabelNode (Label)

-(void)setJSOnClick:(JSValue *)clickValue{
    TokenImageComponent *imageView = self.associatedView;
    [imageView addTapGestureRecognizer];
    [(TokenJSContext *)clickValue.context keepEventValueAlive:clickValue];
    self.onClick = [clickValue token_isNilObject]?nil:[JSManagedValue managedValueWithValue:clickValue andOwner:self];
}

- (void)adjustFontSize:(JSValue *)value {
    TokenLabelComponent *label = self.associatedView;
    label.adjustsFontSizeToFitWidth = [value toBool];
}

- (void)setFont:(JSValue *)fontValue {
    if ([fontValue token_isNilObject]) {
        return;
    }
    if ([fontValue token_isNilObject]) return;
    JSValue *fontName = fontValue[@"fontName"];
    JSValue *fontSize = fontValue[@"size"];
    TokenLabelComponent *label = self.associatedView;
    label.font = [UIFont fontWithName:[fontName toString] size:[[fontSize toNumber] floatValue]];
}

- (void)setNumberOfLines:(JSValue *)numberValue {
    if ([numberValue token_isNilObject]) {
        return;
    }
    TokenLabelComponent *label = self.associatedView;
    label.numberOfLines = [[numberValue toNumber] integerValue];
}

- (void)setText:(JSValue *)text {
    TokenLabelComponent *label = self.associatedView;
    label.text = [text toString];
}

- (void)setTextColor:(JSValue *)textColor {
    TokenLabelComponent *label = self.associatedView;
    label.textColor = [UIColor ss_colorWithString:[textColor toString]];
}

-(void)setTextAlign:(JSValue *)align{
    if ([align token_isNilObject]) {
        return;
    }
    NSDictionary *aligns = @{@"left"  : @(NSTextAlignmentLeft),
                             @"right" : @(NSTextAlignmentRight),
                             @"center": @(NSTextAlignmentCenter)};
    TokenLabelComponent *label = self.associatedView;
    if ([aligns.allKeys containsObject:[align toString]]) {
        label.textAlignment = [aligns[align] integerValue];
    }
}

@end

@implementation TokenInputNode (TextField)
- (void)clear {
    TokenInputComponent *inputComponent = self.associatedView;
    inputComponent.text = @"";
}

- (void)endEditing {
    TokenInputComponent *inputComponent = self.associatedView;
    [inputComponent resignFirstResponder];
}

- (void)setPlaceHolder:(JSValue *)placeHolder {
    TokenInputComponent *inputComponent = self.associatedView;
    inputComponent.placeholder = [placeHolder toString];
}

-(void)setFont:(JSValue *)fontValue{
    if ([fontValue token_isNilObject]) {
        return;
    }
    if ([fontValue token_isNilObject]) return;
    JSValue *fontName = fontValue[@"fontName"];
    JSValue *fontSize = fontValue[@"size"];
    TokenInputComponent *view = self.associatedView;
    view.font = [UIFont fontWithName:[fontName toString] size:[[fontSize toNumber] floatValue]];
}

-(void)setSecure:(JSValue *)value{
    TokenInputComponent *inputComponent = self.associatedView;
    inputComponent.secureTextEntry = [value toBool];
}

- (void)setText:(JSValue *)fieldText {
    TokenInputComponent *inputComponent = self.associatedView;
    inputComponent.text = [fieldText toString];
}

- (void)setTextColor:(JSValue *)textColor {
    TokenInputComponent *inputComponent = self.associatedView;
    inputComponent.textColor = [UIColor ss_colorWithString:[textColor toString]];
}

-(void)setCursorColor:(JSValue *)color{
    TokenInputComponent *inputComponent = self.associatedView;
    inputComponent.tintColor = [UIColor ss_colorWithString:[color toString]];
}

-(NSString *)text{
    TokenInputComponent *inputComponent = self.associatedView;
    return inputComponent.text;
}

-(void)setTextAlign:(JSValue *)align{
    if ([align token_isNilObject]) {
        return;
    }
    NSDictionary *aligns = @{@"left"  : @(NSTextAlignmentLeft),
                             @"right" : @(NSTextAlignmentRight),
                             @"center": @(NSTextAlignmentCenter)};
    TokenInputComponent *label = self.associatedView;
    if ([aligns.allKeys containsObject:[align toString]]) {
        label.textAlignment = [aligns[align] integerValue];
    }
}

- (void)setJSKeyBoardReturn:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onKeyBoardReturn = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)setJSOnBeginEditing:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onBeginEditing = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSClearClick:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onClearClick = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)setJSOnEndEditing:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onEndEditing = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}


- (void)setJSOnTextChange:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onTextChange = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

@end


@implementation TokenTextAreaNode (TextView)
- (void)clear {
    TokenTextAreaComponent *inputComponent = self.associatedView;
    inputComponent.text = @"";
}

- (void)endEditing {
    TokenTextAreaComponent *inputComponent = self.associatedView;
    [inputComponent resignFirstResponder];
}

- (void)setPlaceHolder:(JSValue *)placeHolder {}

- (void)setText:(JSValue *)fieldText {
    TokenTextAreaComponent *inputComponent = self.associatedView;
    inputComponent.text = [fieldText toString];
}

- (void)setTextColor:(JSValue *)textColor {
    TokenTextAreaComponent *inputComponent = self.associatedView;
    inputComponent.textColor = [UIColor ss_colorWithString:[textColor toString]];
}

-(void)setCursorColor:(JSValue *)color{
    TokenTextAreaComponent *inputComponent = self.associatedView;
    inputComponent.tintColor = [UIColor ss_colorWithString:[color toString]];
}

-(NSString *)text{
    TokenTextAreaComponent *inputComponent = self.associatedView;
    return inputComponent.text;
}

-(void)setTextAlign:(JSValue *)align{
    if ([align token_isNilObject]) {
        return;
    }
    NSDictionary *aligns = @{@"left"  : @(NSTextAlignmentLeft),
                             @"right" : @(NSTextAlignmentRight),
                             @"center": @(NSTextAlignmentCenter)};
    TokenTextAreaComponent *label = self.associatedView;
    if ([aligns.allKeys containsObject:[align toString]]) {
        label.textAlignment = [aligns[align] integerValue];
    }
}

- (void)setJSKeyBoardReturn:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onKeyBoardReturn = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSClearClick:(JSValue *)value{}

- (void)setJSOnBeginEditing:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onBeginEditing = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)setJSOnEndEditing:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onEndEditing = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)setJSOnTextChange:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onTextChange = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setEditable:(JSValue *)value{
    TokenTextAreaComponent *inputComponent = self.associatedView;
    inputComponent.editable = [value toBool];
}

-(void)showHBar:(JSValue *)value{
    TokenTextAreaComponent *view = self.associatedView;
    view.showsHorizontalScrollIndicator = [value toBool];
}

-(void)showVBar:(JSValue *)value{
    TokenTextAreaComponent *view = self.associatedView;
    view.showsVerticalScrollIndicator = [value toBool];
}

-(void)scrollEnable:(JSValue *)value{
    TokenTextAreaComponent *view = self.associatedView;
    view.scrollEnabled = [value toBool];
}

-(void)setFont:(JSValue *)fontValue{
    if ([fontValue token_isNilObject]) {
        return;
    }
    if ([fontValue token_isNilObject]) return;
    JSValue *fontName = fontValue[@"fontName"];
    JSValue *fontSize = fontValue[@"size"];
    TokenTextAreaComponent *view = self.associatedView;
    view.font = [UIFont fontWithName:[fontName toString] size:[[fontSize toNumber] floatValue]];
}

- (void)setSecure:(JSValue *)value {}

@end



@implementation TokenSearchBarNode (SearchBar)

-(NSString *)text{
    TokenSearchBarComponent *searchBar = self.associatedView;
    return searchBar.text;
}

-(void)setText:(JSValue *)value{
    TokenSearchBarComponent *searchBar = self.associatedView;
    searchBar.text = [value toString];
}

- (void)showsCancelButton:(JSValue *)boolValue {
    TokenSearchBarComponent *searchBar = self.associatedView;
    searchBar.showsCancelButton = [boolValue toBool];
}

-(void)setPlaceHolder:(JSValue *)placeHolder{
    TokenSearchBarComponent *searchBar = self.associatedView;
    searchBar.placeholder = [placeHolder toString];
}

-(void)setCursorColor:(JSValue *)color{
    if ([color token_isNilObject]) {
        return;
    }
    TokenSearchBarComponent *searchBar = self.associatedView;
    searchBar.tintColor = [UIColor ss_colorWithString:[color toString]];
}

-(void)setBarColor:(JSValue *)color{
    if ([color token_isNilObject]) {
        return;
    }
    TokenSearchBarComponent *searchBar = (TokenSearchBarComponent *)self.associatedView;
    searchBar.barTintColor = [UIColor ss_colorWithString:[color toString]];
}

- (void)setJSSearchButtonClick:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onSearchButtonClick = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)setJSOnBeginEditing:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onBeginEditing = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}


- (void)setJSOnEndEditing:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onBeginEditing = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}


- (void)setJSOnTextChange:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onTextChange = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)endEditing{
    [self.associatedView endEditing:YES];
}

@end

@implementation TokenSegmentNode (Segment)
- (void)setSelectedIndex:(JSValue *)indexValue {
    if ([indexValue token_isNilObject]) {
        return;
    }
    TokenSegmentedComponent *segment = self.associatedView;
    segment.selectedSegmentIndex = [[indexValue toNumber] integerValue];
}

-(void)setJSOnClick:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onClick = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(NSNumber *)selectedIndex{
    TokenSegmentedComponent *segment = self.associatedView;
    if (segment) {
        return @(segment.selectedSegmentIndex);
    }
    return @(-1);
}

@end

@implementation TokenSwitchNode (Switch)
-(BOOL)isOn{
    TokenSwitchComponent *switchComponent = self.associatedView;
    return switchComponent.isOn;
}

-(void)setJSOnClick:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onClick = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setSwitchState:(JSValue *)stateValue animate:(JSValue *)animate{
    if (stateValue == nil || [stateValue isUndefined] || animate == nil || [animate isUndefined]) return;
    TokenSwitchComponent *switchComponent = self.associatedView;
    [switchComponent setOn:[stateValue toBool] animated:[animate toBool]];
}

@end

@implementation TokenWebViewNode (WebView)

-(void)setJSOnHeaderRefresh:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onHeaderRefresh = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnFooterRefresh:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onFooterRefresh = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(NSNumber *)offsetX{
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    return @(webView.scrollView.contentOffset.x);
}

-(NSNumber *)offsetY{
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    return @(webView.scrollView.contentOffset.y);
}

- (void)goBack {
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    [webView goBack];
}

- (void)goForward {
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    [webView goForward];
}

- (void)loadURL:(JSValue *)urlValue {
    if ([urlValue token_isNilObject]) {
        return;
    }
    TokenWebViewComponent *webView = self.associatedView;
    [webView loadURL:[urlValue toString]];
}

- (void)reload {
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    [webView reload];
}

- (void)setUA:(JSValue *)UA {
    TokenWebViewComponent *webView = self.associatedView;
    [webView setUA:[UA toString]];
}

- (void)stopLoading {
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    [webView stopLoading];
}

- (void)setJSOnFailLoad:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onFailLoad = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}


- (void)setJSOnFinish:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onFinish= [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)setJSOnReceiveContent:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onReceiveContent = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}


- (void)setJSOnReceiveJSMessage:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onReceiveJSMessage = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}


- (void)setJSOnStartLoad:(JSValue *)value {
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onStartLoad = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

- (void)hiddenFooterRefresh {
    TokenWebViewComponent *webView = self.associatedView;
    [webView hiddenFooterRefresh];
}

- (void)hiddenHeaderRefresh {
    TokenWebViewComponent *webView = self.associatedView;
    [webView hiddenHeaderRefresh];
}

- (void)openFooterRefresh {
    TokenWebViewComponent *webView = self.associatedView;
    [webView openFooterRefresh];
}

- (void)openHeaderRefresh {
    TokenWebViewComponent *webView = self.associatedView;
    [webView openHeaderRefresh];
}

- (void)stopFooterRefresh {
    TokenWebViewComponent *webView = self.associatedView;
    [webView stopFooterRefresh];
}

- (void)stopHeaderRefresh {
    TokenWebViewComponent *webView = self.associatedView;
    [webView stopHeaderRefresh];
}

- (void)pageEnable:(JSValue *)value {}

- (void)scrollEnable:(JSValue *)value {
    WKWebView *webView = [(TokenWebViewComponent *)self.associatedView webView];
    webView.scrollView.scrollEnabled = [value toBool];
}

- (void)scrollToTopAnimate:(JSValue *)value {
    if ([value token_isNilObject]) return;
    UIScrollView *view = [(TokenWebViewComponent *)self.associatedView webView].scrollView;
    CGPoint offset = view.contentOffset;
    offset.y = -view.contentInset.top;
    offset.x = -view.contentInset.left;
    [view setContentOffset:offset animated:[value toBool]];
}

- (void)setContentSizeWithWidth:(JSValue *)width height:(JSValue *)height {}

- (void)setScrollInsetWithTop:(JSValue *)top left:(JSValue *)left bottom:(JSValue *)bottom right:(JSValue *)right {}

- (void)showHBar:(JSValue *)value {
    UIScrollView *view = [(TokenWebViewComponent *)self.associatedView webView].scrollView;
    view.showsHorizontalScrollIndicator = [value toBool];
}

- (void)showVBar:(JSValue *)value {
    UIScrollView *view = [(TokenWebViewComponent *)self.associatedView webView].scrollView;
    view.showsVerticalScrollIndicator = [value toBool];
}

- (void)setJSOnEndDecelerating:(JSValue *)value {}


- (void)setJSOnScroll:(JSValue *)value {}

@end

@implementation TokenTableNode (table)
-(void)reloadData:(JSValue *)data{
    if ([data token_isNilObject]) return;
    NSArray *nativeData = [data toArray];
    if (nativeData.count == 0) return;
    [(TokenTableComponent *)self.associatedView reloadData:nativeData];
}

-(void)setJSOnClick:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onClick = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(NSNumber *)sections{
    TokenTableComponent *view = self.associatedView;
    return @([view.tableView numberOfSections]);
}

-(NSNumber *)rowsInSection:(JSValue *)value{
    if ([value token_isNilObject]) {
        return @(-1);
    }
    TokenTableComponent *view = self.associatedView;
    return @([view.tableView numberOfRowsInSection:[[value toNumber] integerValue]]);
}

-(NSNumber *)offsetX{
    TokenTableComponent *view = self.associatedView;
    return @(view.tableView.contentOffset.x);
}

-(NSNumber *)offsetY{
    TokenTableComponent *view = self.associatedView;
    return @(view.tableView.contentOffset.y);
}

- (void)hiddenFooterRefresh {
    TokenTableComponent *view = self.associatedView;
    [view hiddenFooterRefresh];
}

- (void)hiddenHeaderRefresh {
    TokenTableComponent *view = self.associatedView;
    [view hiddenHeaderRefresh];
}

- (void)openFooterRefresh {
    TokenTableComponent *view = self.associatedView;
    [view openFooterRefresh];
}

- (void)openHeaderRefresh {
    TokenTableComponent *view = self.associatedView;
    [view openHeaderRefresh];
}

- (void)pageEnable:(JSValue *)value {}

- (void)scrollEnable:(JSValue *)value {
    TokenTableComponent *view = self.associatedView;
    view.tableView.scrollEnabled = [value toBool];
}

- (void)scrollToTopAnimate:(JSValue *)value {
    TokenTableComponent *view = self.associatedView;
    if ([view.tableView numberOfSections]) {
        if ([view.tableView numberOfRowsInSection:0]) {
            [view.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:[value toBool]];
        }
    }
}

- (void)setContentSizeWithWidth:(JSValue *)width height:(JSValue *)height {}

- (void)setScrollInsetWithTop:(JSValue *)top left:(JSValue *)left bottom:(JSValue *)bottom right:(JSValue *)right {
    if ([top token_isNilObject] || [left token_isNilObject] || [bottom token_isNilObject] || [right token_isNilObject]) {
        return;
    }
    TokenTableComponent *view = self.associatedView;
    view.tableView.contentInset = UIEdgeInsetsMake([[top toNumber] floatValue],
                                         [[left toNumber] floatValue],
                                         [[bottom toNumber] floatValue],
                                         [[right toNumber] floatValue]);
}

- (void)showHBar:(JSValue *)value {
    TokenTableComponent *view = self.associatedView;
    view.tableView.showsHorizontalScrollIndicator = [value toBool];
}

- (void)showVBar:(JSValue *)value {
    TokenTableComponent *view = self.associatedView;
    view.tableView.showsVerticalScrollIndicator = [value toBool];
}

- (void)stopFooterRefresh {
    TokenTableComponent *view = self.associatedView;
    [view stopFooterRefresh];
}

- (void)stopHeaderRefresh {
    TokenTableComponent *view = self.associatedView;
    [view stopHeaderRefresh];
}

-(void)setJSOnHeaderRefresh:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onHeaderRefresh = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnFooterRefresh:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onFooterRefresh = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnScroll:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.didScroll = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setJSOnEndDecelerating:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.didEndDecelerating = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

@end


@implementation TokenDotsNode (Dots)
-(void)setOnIndexChange:(JSValue *)value{
    [(TokenJSContext *)value.context keepEventValueAlive:value];
    self.onClick = [value token_isNilObject]?nil:[JSManagedValue managedValueWithValue:value andOwner:self];
}

-(void)setDotsColor:(JSValue *)value{
    if (![value token_isNilObject]) {
        TokenPageControl *view = self.associatedView;
        view.pageIndicatorTintColor = [UIColor ss_colorWithString:[value toString]];
    }
}

-(void)setOnDotsColor:(JSValue *)value{
    if (![value token_isNilObject]) {
        TokenPageControl *view = self.associatedView;
        view.currentPageIndicatorTintColor = [UIColor ss_colorWithString:[value toString]];
    }
}

-(void)setCurentIndex:(JSValue *)value{
    if (![value token_isNilObject]) {
        TokenPageControl *view = self.associatedView;
        view.currentPage = [[value toNumber] integerValue];
    }
}

-(NSNumber *)currentIndex{
    TokenPageControl *view = self.associatedView;
    return @(view.currentPage);
}

@end

