//
//  TokenXMLNode+JavascriptSupport.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenXMLNode.h"
#import "TokenDocument.h"

@import JavaScriptCore;

#pragma mark - TokenDocumentExport
@protocol TokenDocumentExport <JSExport>
@optional
JSExportAs(getElementById,         -(TokenXMLNode *)getElementById:(NSString *)elementId);
JSExportAs(getElementsByTagName,   -(NSArray <TokenXMLNode *>*)getElementsByTagName:(NSString *)tagName);
JSExportAs(getElementsByClassName, -(NSArray <TokenXMLNode *>*)getElementsByClassName:(NSString *)className);
JSExportAs(pushNavigatorWithURL, -(void)pushNavigatorWithURL:(NSString *)htmlURL extension:(JSValue *)value);
@property(nonatomic ,copy  ) NSString     *html;
@property(nonatomic ,copy  ) NSString     *sourceURL;
@property(nonatomic ,weak) TokenXMLNode *rootNode;
@property(nonatomic ,weak) TokenXMLNode *bodyNode;
@property(nonatomic ,weak) TokenXMLNode *headNode;
@property(nonatomic ,weak) TokenXMLNode *titleNode;
@property(nonatomic ,weak) TokenXMLNode *navigationBarNode;
-(void)popNavigator;
-(void)setTitle:(NSString *)title;
@end

@interface TokenDocument (JavascriptSupport) <TokenDocumentExport>
@end

@protocol TokenXMLNodeExport <JSExport>
@optional
JSExportAs(getElementById,         -(TokenXMLNode *)getElementById:(NSString *)elementId);
JSExportAs(getElementsByTagName,   -(NSArray <TokenXMLNode *>*)getElementsByTagName:(NSString *)tagName);
JSExportAs(getElementsByClassName, -(NSArray <TokenXMLNode *>*)getElementsByClassName:(NSString *)className);

@property(nonatomic ,copy  ) NSString     *name;
@property(nonatomic ,copy  ) NSString     *innerText;
@property(nonatomic ,copy  ) NSString     *identifier;
@property(nonatomic ,weak  ) TokenXMLNode *parentNode;
@property(nonatomic ,strong) NSDictionary *innerAttributes;
@property(nonatomic ,strong) NSDictionary *cssAttributes;
@property(nonatomic ,strong) NSArray       <TokenXMLNode *> *childNodes;
@end

@interface TokenXMLNode (JavascriptSupport) <TokenXMLNodeExport>
@end

@protocol TokenPureNodeExport <JSExport>
@optional
JSExportAs(setSize, -(void)setSize:(JSValue *)widthValue height:(JSValue *)heightValue);
JSExportAs(setOrigin, -(void)setOrigin:(JSValue *)originX originY:(JSValue *)originY);
@property(nonatomic ,readonly) NSNumber *componentWidth;
@property(nonatomic ,readonly) NSNumber *componentHeight;
@property(nonatomic ,readonly) NSNumber *originX;
@property(nonatomic ,readonly) NSNumber *originY;
@property(nonatomic ,readonly) NSNumber *centerX;
@property(nonatomic ,readonly) NSNumber *centerY;
@property(nonatomic ,readonly) NSNumber *maxX;
@property(nonatomic ,readonly) NSNumber *maxY;
-(void)setHidden:(JSValue *)hiddenValue;
-(void)setBackgroundColor:(JSValue *)colorValue;
-(void)setCornerRadius:(JSValue *)radiusValue;
-(void)setBorderColor:(JSValue *)colorValue;
-(void)setBorderWidth:(JSValue *)widthValue;
-(void)setUserInteractionEnabled:(JSValue *)value;
@end

@interface TokenPureNode (Basic)<TokenPureNodeExport>
@end

#pragma mark - PullRefresh
@protocol TokenNodeScrollExport <JSExport>
@optional
JSExportAs(scrollToTop, -(void)scrollToTopAnimate:(JSValue *)value);
JSExportAs(setScrollInset, -(void)setScrollInsetWithTop:(JSValue *)top left:(JSValue *)left bottom:(JSValue *)bottom right:(JSValue *)right);
JSExportAs(setContentSize, -(void)setContentSizeWithWidth:(JSValue *)width height:(JSValue *)height);
JSExportAs(onHeaderRefresh, -(void)setJSOnHeaderRefresh:(JSValue *)value);
JSExportAs(onFooterRefresh, -(void)setJSOnFooterRefresh:(JSValue *)value);
JSExportAs(setOnScroll, -(void)setJSOnScroll:(JSValue *)value);
JSExportAs(setOnEndDecelerating, -(void)setJSOnEndDecelerating:(JSValue *)value);
@property(nonatomic ,copy ,readonly) NSNumber *offsetX;
@property(nonatomic ,copy ,readonly) NSNumber *offsetY;
-(void)openHeaderRefresh;
-(void)stopHeaderRefresh;
-(void)hiddenHeaderRefresh;
-(void)openFooterRefresh;
-(void)stopFooterRefresh;
-(void)hiddenFooterRefresh;
-(void)showHBar:(JSValue *)value;
-(void)showVBar:(JSValue *)value;
-(void)scrollEnable:(JSValue *)value;
-(void)pageEnable:(JSValue *)value;
@end

@interface TokenScrollNode (scrollView) <TokenNodeScrollExport>
@end

#pragma mark - button
@protocol TokenButtonNodeExport <JSExport>
@optional
JSExportAs(setSelectedTitle,      -(void)setSelectedTitle:(JSValue *)title);
JSExportAs(setHightTitle,         -(void)setHightTitle:(JSValue *)title);
JSExportAs(setTitle,              -(void)setTitle:(JSValue *)title);
JSExportAs(setHightTitleColor,    -(void)setHightTitleColor:(JSValue *)color);
JSExportAs(setTitleColor,         -(void)setTitleColor:(JSValue *)color);
JSExportAs(setSelectedTitleColor, -(void)setSelectedTitleColor:(JSValue *)color);
JSExportAs(setSelectedBackgroundColor, -(void)setSelectedBackgroundColor:(JSValue *)color);
JSExportAs(setFont,               -(void)setFont:(JSValue *)fontValue);
JSExportAs(setOnClick,            -(void)setJSOnClick:(JSValue *)onClick);
JSExportAs(setSelected,           -(void)setSelected:(JSValue *)value);
@property(nonatomic ,assign,readonly) BOOL isSelected;
@end

@interface TokenButtonNode (Button) <TokenButtonNodeExport>
@end

#pragma mark - image
@protocol TokenImageNodeExport <JSExport>
@optional
JSExportAs(setImage, -(void)setImage:(JSValue *)image animate:(JSValue *)animate);
JSExportAs(setOnClick, -(void)setJSOnClick:(JSValue *)value);
@end

@interface TokenImageNode (Image) <TokenImageNodeExport>
@end

#pragma mark - label
@protocol TokenLabelNodeExport <JSExport>
@optional
JSExportAs(setText,          -(void)setText:(JSValue *)text);
JSExportAs(setFont,          -(void)setFont:(JSValue *)fontValue);
JSExportAs(setTextColor,     -(void)setTextColor:(JSValue *)textColor);
JSExportAs(setNumberOfLines, -(void)setNumberOfLines:(JSValue *)numberValue);
JSExportAs(setTextAlign, -(void)setTextAlign:(JSValue *)align);
JSExportAs(setOnClick, -(void)setJSOnClick:(JSValue *)value);
-(void)adjustFontSize:(JSValue *)value;
@end

@interface TokenLabelNode (Label) <TokenLabelNodeExport>
@end

#pragma mark - tableView
@protocol TokenNodeTableExport <JSExport>
@optional
JSExportAs(reloadData, -(void)reloadData:(JSValue *)data);
JSExportAs(setOnClick, -(void)setJSOnClick:(JSValue *)value);
JSExportAs(rowsInSection, -(NSNumber *)rowsInSection:(JSValue *)value);
@property(nonatomic,copy,readonly) NSNumber *sections;
@end

@interface TokenTableNode (table) <TokenNodeTableExport,TokenNodeScrollExport>
@end

#pragma mark - textField
@protocol TokenInputNodeExport <JSExport>
@optional
JSExportAs(setFont,        -(void)setFont:(JSValue *)fontValue);
JSExportAs(setSecure,       -(void)setSecure:(JSValue *)value);
JSExportAs(setText,        -(void)setText:(JSValue *)fieldText);
JSExportAs(setTextColor,   -(void)setTextColor:(JSValue *)textColor);
JSExportAs(setCursorColor, -(void)setCursorColor:(JSValue *)color);
JSExportAs(setPlaceHolder, -(void)setPlaceHolder:(JSValue *)placeHolder);
JSExportAs(setTextAlign, -(void)setTextAlign:(JSValue *)align);
JSExportAs(onBeginEditing, -(void)setJSOnBeginEditing:(JSValue *)value);
JSExportAs(onEndEditing, -(void)setJSOnEndEditing:(JSValue *)value);
JSExportAs(onTextChange, -(void)setJSOnTextChange:(JSValue *)value);
JSExportAs(onClearClick, -(void)setJSClearClick:(JSValue *)value);
JSExportAs(onKeyBoardReturn, -(void)setJSKeyBoardReturn:(JSValue *)value);
@property(nonatomic ,copy,readonly) NSString *text;
-(void)endEditing;
-(void)clear;
@end

@interface TokenInputNode (TextField) <TokenInputNodeExport>
@end

@protocol TokenTextAreaNodeExport <JSExport>
@optional
JSExportAs(setEditable,-(void)setEditable:(JSValue *)value);
-(void)showHBar:(JSValue *)value;
-(void)showVBar:(JSValue *)value;
-(void)scrollEnable:(JSValue *)value;
@end

@interface TokenTextAreaNode(TextView) <TokenInputNodeExport,TokenTextAreaNodeExport>
@end

#pragma mark - searchBar
@protocol TokenSearchNodeExport <JSExport>
@optional
JSExportAs(showsCancelButton, -(void)showsCancelButton:(JSValue *)boolValue);
JSExportAs(setPlaceHolder, -(void)setPlaceHolder:(JSValue *)placeHolder);
JSExportAs(setCursorColor, -(void)setCursorColor:(JSValue *)color);
JSExportAs(setBarColor, -(void)setBarColor:(JSValue *)color);
JSExportAs(onBeginEditing, -(void)setJSOnBeginEditing:(JSValue *)value);
JSExportAs(onEndEditing, -(void)setJSOnEndEditing:(JSValue *)value);
JSExportAs(onTextChange, -(void)setJSOnTextChange:(JSValue *)value);
JSExportAs(onSearchButtonClick, -(void)setJSSearchButtonClick:(JSValue *)value);
JSExportAs(setText, -(void)setText:(JSValue *)value);
@property(nonatomic ,copy,readonly) NSString *text;
-(void)endEditing;
@end

@interface TokenSearchBarNode (SearchBar) <TokenSearchNodeExport>
@end

#pragma mark - segment
@protocol TokenSegmentNodeExport <JSExport>
@optional
JSExportAs(setSelectedIndex, -(void)setSelectedIndex:(JSValue *)indexValue);
JSExportAs(setOnClick, -(void)setJSOnClick:(JSValue *)value);
@property(nonatomic,copy ,readonly) NSNumber *selectedIndex;
@end

@interface TokenSegmentNode (Segment) <TokenSegmentNodeExport>
@end

#pragma mark - switch
@protocol TokenSwitchExport <JSExport>
@optional
JSExportAs(setSwitchState, -(void)setSwitchState:(JSValue *)stateValue animate:(JSValue *)animate);
JSExportAs(setOnClick, -(void)setJSOnClick:(JSValue *)value);
@property(nonatomic ,assign,readonly) BOOL isOn;
@end

@interface TokenSwitchNode (Switch) <TokenSwitchExport>
@end

@protocol TokenWebViewExport <JSExport>
@optional
JSExportAs(onStartLoad, -(void)setJSOnStartLoad:(JSValue *)value);
JSExportAs(onReceiveContent, -(void)setJSOnReceiveContent:(JSValue *)value);
JSExportAs(onFinish, -(void)setJSOnFinish:(JSValue *)value);
JSExportAs(onFailLoad, -(void)setJSOnFailLoad:(JSValue *)value);
JSExportAs(onReceiveJSMessage, -(void)setJSOnReceiveJSMessage:(JSValue *)value);
JSExportAs(loadURL, -(void)loadURL:(JSValue *)urlValue);
-(void)goBack;
-(void)goForward;
-(void)reload;
-(void)stopLoading;
-(void)setUA:(JSValue *)UA;
@end

@interface TokenWebViewNode (WebView) <TokenWebViewExport,TokenNodeScrollExport>
@end

@protocol TokenDotsExport <JSExport>
@optional
JSExportAs(setOnIndexChange, -(void)setOnIndexChange:(JSValue *)value);
JSExportAs(setDotsColor, -(void)setDotsColor:(JSValue *)value);
JSExportAs(setOnDotsColor, -(void)setOnDotsColor:(JSValue *)value);
-(void)setCurentIndex:(JSValue *)value;
-(NSNumber *)currentIndex;
@end

@interface TokenDotsNode (Dots) <TokenDotsExport>
@end

