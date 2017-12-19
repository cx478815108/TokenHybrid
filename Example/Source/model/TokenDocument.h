//
//  TokenHTMLDocument.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenXMLNode,TokenJSContext;
@interface TokenDocument : NSObject <NSSecureCoding>
@property(nonatomic ,copy  ) NSString     *html;
@property(nonatomic ,copy  ) NSString     *sourceURL;
@property(nonatomic ,strong) TokenXMLNode *rootNode;
@property(nonatomic ,strong) NSArray      <NSDictionary *>*cssRules;
@property(nonatomic ,strong) NSArray      <NSString *>*scripts;
@property(nonatomic ,strong) NSArray      <NSString *>*downloadFailCSSURLs;
@property(nonatomic ,strong) NSArray      <NSString *>*downloadFailScriptURLs;

@property(nonatomic ,weak) TokenXMLNode *bodyNode;
@property(nonatomic ,weak) TokenXMLNode *headNode;
@property(nonatomic ,weak) TokenXMLNode *titleNode;
@property(nonatomic ,weak) TokenXMLNode *navigationBarNode;

@property(nonatomic ,weak) TokenJSContext *jsContext;

-(void)addCSSRuels:(NSDictionary *)rules;
-(void)addJavaScript:(NSString *)script;
-(void)addFailedCSSURL:(NSString *)url;
-(void)addFailedScriptURL:(NSString *)url;
@end
