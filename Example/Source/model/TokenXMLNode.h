//
//  TokenXMLNode.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@import JavaScriptCore;
@class TokenXMLNode;
typedef void(^TokenNodeEnumerateBlock)(TokenXMLNode *node,BOOL *stop);
typedef void(^TokenNodeComponentConfigBlock)(__kindof UIView *view);

@interface TokenXMLNode : NSObject <NSSecureCoding>
@property(nonatomic ,copy  ) NSString     *name;
@property(nonatomic ,copy  ) NSString     *innerText;
@property(nonatomic ,copy  ) NSString     *identifier;
@property(nonatomic ,weak  ) TokenXMLNode *parentNode;
@property(nonatomic ,strong) NSDictionary *innerAttributes;
@property(nonatomic ,strong) NSDictionary *innerStyleAttributes;
@property(nonatomic ,strong) NSDictionary *cssAttributes;
@property(nonatomic ,copy  ) NSString     *cachedFrame;
@property(nonatomic ,strong) NSArray      <TokenXMLNode *> *childNodes;
@property(nonatomic ,weak  ) __kindof UIView *associatedView;

-(void)addChildNode:(TokenXMLNode *)childNode;
-(void)addCSSAttributesFromDictionary:(NSDictionary *)dictionary;
+(void)enumerateTreeFromRootToChildWithNode:(TokenXMLNode *)rootNode
                                      block:(TokenNodeEnumerateBlock)block;
@end

@interface TokenPureNode : TokenXMLNode
@end

@interface TokenLabelNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onClick;
@end

@interface TokenScrollNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onHeaderRefresh;
@property(nonatomic ,strong) JSManagedValue *onFooterRefresh;
@property(nonatomic ,strong) JSManagedValue *didScroll;
@property(nonatomic ,strong) JSManagedValue *didEndDecelerating;
@end

@interface TokenButtonNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onClick;
@end

@interface TokenImageNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onClick;
@end

@interface TokenTextAreaNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onBeginEditing;
@property(nonatomic ,strong) JSManagedValue *onEndEditing;
@property(nonatomic ,strong) JSManagedValue *onTextChange;
@property(nonatomic ,strong) JSManagedValue *onKeyBoardReturn;
@end

@interface TokenInputNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onBeginEditing;
@property(nonatomic ,strong) JSManagedValue *onEndEditing;
@property(nonatomic ,strong) JSManagedValue *onClearClick;
@property(nonatomic ,strong) JSManagedValue *onTextChange;
@property(nonatomic ,strong) JSManagedValue *onKeyBoardReturn;
@end

@interface TokenNavigationBarNode : TokenPureNode
@end

@interface TokenTableNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onHeaderRefresh;
@property(nonatomic ,strong) JSManagedValue *onFooterRefresh;
@property(nonatomic ,strong) JSManagedValue *onClick;
@property(nonatomic ,strong) JSManagedValue *didScroll;
@property(nonatomic ,strong) JSManagedValue *didEndDecelerating;
@end

@interface TokenSegmentNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onClick;
@end

@interface TokenSwitchNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onClick;
@end

@interface TokenSearchBarNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onBeginEditing;
@property(nonatomic ,strong) JSManagedValue *onEndEditing;
@property(nonatomic ,strong) JSManagedValue *onTextChange;
@property(nonatomic ,strong) JSManagedValue *onSearchButtonClick;
@property(nonatomic ,strong) JSManagedValue *onCancleButtonClick;
@end

@interface TokenWebViewNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onHeaderRefresh;
@property(nonatomic ,strong) JSManagedValue *onFooterRefresh;
@property(nonatomic ,strong) JSManagedValue *onStartLoad;
@property(nonatomic ,strong) JSManagedValue *onReceiveContent;
@property(nonatomic ,strong) JSManagedValue *onFinish;
@property(nonatomic ,strong) JSManagedValue *onFailLoad;
@property(nonatomic ,strong) JSManagedValue *onReceiveJSMessage;
@end

@interface TokenDotsNode : TokenPureNode
@property(nonatomic ,strong) JSManagedValue *onClick;
@end



