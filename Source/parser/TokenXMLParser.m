//
//  TokenXMLParser.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenXMLParser.h"
#import "TokenXMLNode.h"
#import "TokenHybridStack.h"
#import "TokenExtensionHeader.h"
#import "TokenNodeComponentRegister.h"
#import "TokenHybridOrganizer.h"
#import "TokenHybridDefine.h"
#import "TokenCSSParser.h"

NS_INLINE dispatch_queue_t tokenXMLParserQueue(){
    static dispatch_once_t onceToken;
    static dispatch_queue_t _obj;
    dispatch_once(&onceToken, ^{
        _obj = dispatch_queue_create("com.tokenXMLParser.queue", DISPATCH_QUEUE_SERIAL);
    });
    return _obj;
}

@interface TokenXMLParser()<NSXMLParserDelegate>
@property(nonatomic ,strong) NSXMLParser      *parser;
@property(nonatomic ,strong) TokenHybridStack *stack;
@property(nonatomic ,strong) NSDictionary     *nodeTagNameDelegateMethodMapper;
@end

@implementation TokenXMLParser{
    BOOL          _isParserBodyNode;
    NSInteger     _parserState;
    TokenXMLNode *_rootNode;
    NSMutableSet *_nodeContainInnerCSSStyleSet;
}

-(instancetype)initWithBodyViewFrame:(CGRect)frame{
    if (self = [super init]) {
        self.bodyViewFrame = frame;
    }
    return self;
}

-(void)parserHTML:(NSString *)html
{
    dispatch_async(tokenXMLParserQueue(), ^{
        NSString *closedHTML = [self handleSimeClosedTagWithTagNameArray:@[@"meta",@"input"] html:html];
        NSData *data         = [closedHTML dataUsingEncoding:NSUTF8StringEncoding];
        _parser              = [[NSXMLParser alloc] initWithData:data];
        _parser.delegate     = self;
       [_parser parse];
    });
}

-(NSString *)handleSimeClosedTagWithTagNameArray:(NSArray *)tagNameArray html:(NSString *)html{
    __block NSString *temp = html;
    for (NSString *tagName in tagNameArray) {
        NSString *testString = @"<".token_append(tagName);
        NSString *closedString = [NSString stringWithFormat:@"</%@>",tagName];
        if ([html containsString:testString]) {
            //检测是否闭合
            NSString *pattern = [NSString stringWithFormat:@"<%@(.*?)>",tagName];
            NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
            NSArray<NSTextCheckingResult *>  *results = [exp matchesInString:html options:0 range:NSMakeRange(0, html.length)];
            
            [results enumerateObjectsUsingBlock:^(NSTextCheckingResult * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *matchString = [html substringWithRange:obj.range];
                NSString *nextString = [html substringWithRange:NSMakeRange(obj.range.length+obj.range.location, tagName.length+3)];
                if (![nextString isEqualToString:closedString]) {
                    temp = temp.token_replace(matchString,matchString.token_append(closedString));
                }
            }];
        }
    }
    return temp;
}

#pragma mark - NSXMLParserDelegate
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    _parserState = 0;
    _stack = [[TokenHybridStack alloc] init];
    _nodeContainInnerCSSStyleSet = [NSMutableSet set];
    if ([_delegate respondsToSelector:@selector(parserDidStart)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate parserDidStart];
        });
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
-(void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
   attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    _parserState                    = 1;
    TokenHybridOrganizer *hybridOrganizer = [TokenHybridOrganizer sharedOrganizer];
    TokenHybridRegisterModel *model = [hybridOrganizer.nodeComponentRegister getRegisterModelWithNodeTagName:elementName];
    TokenXMLNode *node              = model?[model creatNode]:[[TokenXMLNode alloc] init];
    node.name                       = elementName;
    node.innerAttributes            = attributeDict;

    NSString *innerStyleString = node.innerAttributes[@"style"];
    if (innerStyleString && innerStyleString.length) {
        CGFloat      width          = self.bodyViewFrame.size.width;
        CGFloat      height         = self.bodyViewFrame.size.height;
        NSDictionary *innerCSSStyle = [TokenCSSParser converAttrStringToDictionary:innerStyleString
                                                                containerViewWidth:width
                                                               containerViewHeight:height];
        node.innerStyleAttributes  = innerCSSStyle;
        [_nodeContainInnerCSSStyleSet addObject:node];
    }

    [_stack push:node];
    
    if ([elementName isEqualToString:@"body"]){
        _isParserBodyNode = YES;
    }
    
    if (_isParserBodyNode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_delegate respondsToSelector:@selector(parser:didStartNodeWithinBodyNode:)]) {
                [_delegate parser:self didStartNodeWithinBodyNode:node];
            }
        });
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    TokenXMLNode *currentNode = [self.stack top];
    if (_parserState == 2) {
        NSMutableString *orignString = [NSMutableString stringWithString:currentNode.innerText];
        [orignString appendString:string];
        currentNode.innerText = orignString;
    }
    else {
        currentNode.innerText = string;
    }
    _parserState = 2;
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName {
    _parserState = 3;
    TokenXMLNode *currentNode = [self.stack pop];
    TokenXMLNode *parentNode  = [self.stack top];
    [parentNode addChildNode:currentNode];
    currentNode.parentNode = parentNode;
    if (_isParserBodyNode) {
        if ([_delegate respondsToSelector:@selector(parser:didEndNodeWithinBodyNode:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate parser:self didEndNodeWithinBodyNode:currentNode];
            });
        }
    }
    
    if ([elementName isEqualToString:@"body"]) {
        _isParserBodyNode = NO;
    }
    else {
        NSString *delegateMethod = [self nodeTagNameDelegateMethodMapper][elementName];
        if (delegateMethod) {
            SEL selector = NSSelectorFromString(delegateMethod);
            if ([_delegate respondsToSelector:selector]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_delegate performSelector:selector withObject:self withObject:currentNode];
                });
            }
        }
    }
    _rootNode = currentNode;
}
#pragma clang diagnostic pop

-(void)parser:(NSXMLParser *)parser
parseErrorOccurred:(NSError *)parseError {
    _parserState = 4;
    if ([_delegate respondsToSelector:@selector(parserErrorOccurred:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate parserErrorOccurred:parseError];
        });
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    _parserState = 5;
    _stack = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_nodeContainInnerCSSStyleSet.count) {
            if ([_delegate respondsToSelector:@selector(parser:nodeContainInnerCSSStyle:)]) {
                [_delegate parser:self nodeContainInnerCSSStyle:_nodeContainInnerCSSStyleSet];
//                _nodeContainInnerCSSStyleSet = nil;
            }
        }
        
        if ([_delegate respondsToSelector:@selector(parser:didCreatRootNode:)]) {
            [_delegate parser:self didCreatRootNode:_rootNode];
        }
        if ([_delegate respondsToSelector:@selector(parserDidEnd)]) {
            [_delegate parserDidEnd];
        }
     });
}

-(void)stopParsing{
    [_parser abortParsing];
}

#pragma mark - getter
-(NSDictionary *)nodeTagNameDelegateMethodMapper{
    if (_nodeTagNameDelegateMethodMapper == nil) {
        _nodeTagNameDelegateMethodMapper = @{
                                             @"head"          :@"parser:didCreatHeadNode:",
                                             @"title"         :@"parser:didCreatTitleNode:",
                                             @"navigationBar" :@"parser:didCreatNavigationBarNode:",
                                             };
    }
    
    return _nodeTagNameDelegateMethodMapper;
}

-(void)dealloc{
    HybridLog(@"TokenXMLParser dead");
}


@end
