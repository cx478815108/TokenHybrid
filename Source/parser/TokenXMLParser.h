//
//  TokenXMLParser.h
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TokenXMLParser,TokenXMLNode;
@protocol TokenXMLParserDelegate <NSObject>
@optional
-(void)parserDidStart;
-(void)parser:(TokenXMLParser *)parser didStartNodeWithinBodyNode:(TokenXMLNode *)node;
-(void)parser:(TokenXMLParser *)parser didEndNodeWithinBodyNode:(TokenXMLNode *)node;
-(void)parser:(TokenXMLParser *)parser didCreatHeadNode:(TokenXMLNode *)node;
-(void)parser:(TokenXMLParser *)parser didCreatTitleNode:(TokenXMLNode *)node;
-(void)parser:(TokenXMLParser *)parser didCreatNavigationBarNode:(TokenXMLNode *)node;
-(void)parser:(TokenXMLParser *)parser didCreatRootNode:(TokenXMLNode *)node;
-(void)parser:(TokenXMLParser *)parser nodeContainInnerCSSStyle:(NSSet *)nodes;
-(void)parserDidEnd;
-(void)parserErrorOccurred:(NSError *)error;
@end

@interface TokenXMLParser : NSObject
@property(nonatomic ,weak) id <TokenXMLParserDelegate> delegate;
@property(nonatomic ,copy) NSString *identifier;
-(void)parserHTML:(NSString *)html;
-(void)stopParsing;
@end
