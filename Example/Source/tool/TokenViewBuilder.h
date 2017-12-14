//
//  TokenViewBuilder.h
//  TokenHybrid
//
//  Created by 陈雄 on 2017/11/8.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@class TokenDocument,
       TokenXMLNode,
       TokenPureComponent,
       TokenViewBuilder,
       TokenJSContext;

@protocol TokenViewBuilderDelegate <NSObject>
@optional
-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didFetchTitle:(NSString *)title;
-(void)viewBuilder:(TokenViewBuilder *)viewBuilder parserErrorOccurred:(NSError *)error;
-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didCreatNavigationBarNode:(TokenXMLNode *)node;
-(void)viewBuilder:(TokenViewBuilder *)viewBuilder didCreatBodyView:(TokenPureComponent *)view;
-(void)viewBuilderWillRunScript;
@end

@interface TokenViewBuilder : NSObject
@property(nonatomic ,strong) TokenDocument      *document;
@property(nonatomic ,strong) TokenPureComponent *bodyView;
@property(nonatomic ,strong) TokenJSContext     *jsContext;
@property(nonatomic ,strong) NSUserDefaults     *currentPageDefaults;
@property(nonatomic ,weak  ) id <TokenViewBuilderDelegate> delegate;
@property(nonatomic ,assign) BOOL useCache;
@property(nonatomic ,assign) CGRect bodyViewFrame;
-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithBodyViewFrame:(CGRect)frame;
-(void)buildViewWithSourceURL:(NSString *)url;
-(void)refreshView;
@end
