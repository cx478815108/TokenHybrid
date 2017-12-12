//
//  TokenHTMLDocument.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenDocument.h"
#import "TokenXMLNode.h"
#import "TokenXMLNode+JSExport.h"
#import "TokenHybridDefine.h"

@implementation TokenDocument
- (instancetype)initWithCoder:(NSCoder *)coder
{
    if (self = [super init]) {
        _html                    = [coder decodeObjectOfClass:[NSString class] forKey:@"htmlKey"];
        _sourceURL               = [coder decodeObjectOfClass:[NSString class] forKey:@"sourceURLKey"];
        _rootNode                = [coder decodeObjectOfClass:[TokenXMLNode class] forKey:@"rootNodeKey"];
        _cssRules                = [coder decodeObjectOfClass:[NSArray class] forKey:@"cssRulesKey"];
        _scripts                 = [coder decodeObjectOfClass:[NSArray class] forKey:@"scriptsKey"];
        _downloadFailCSSURLs     = [coder decodeObjectOfClass:[NSArray class] forKey:@"downloadFailCSSURLsKey"];
        _downloadFailScriptURLs  = [coder decodeObjectOfClass:[NSArray class] forKey:@"downloadFailScriptURLsKey"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_html forKey:@"htmlKey"];
    [aCoder encodeObject:_sourceURL forKey:@"sourceURLKey"];
    [aCoder encodeObject:_rootNode forKey:@"rootNodeKey"];
    [aCoder encodeObject:_scripts forKey:@"scriptsKey"];
    [aCoder encodeObject:_cssRules forKey:@"cssRulesKey"];
    [aCoder encodeObject:_downloadFailCSSURLs forKey:@"downloadFailCSSURLsKey"];
    [aCoder encodeObject:_downloadFailScriptURLs forKey:@"downloadFailScriptURLsKey"];
}

-(void)addCSSRuels:(NSDictionary *)rules{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_cssRules?_cssRules:@[]];
    [temp addObject:rules];
    _cssRules = temp;
}

-(void)addJavaScript:(NSString *)script{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_scripts?_scripts:@[]];
    [temp addObject:script];
    _scripts = temp;
}

-(void)addFailedCSSURL:(NSString *)url{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_downloadFailCSSURLs?_downloadFailCSSURLs:@[]];
    [temp addObject:url];
    _downloadFailCSSURLs = temp;
}

-(void)addFailedScriptURL:(NSString *)url{
    NSMutableArray *temp = [NSMutableArray arrayWithArray:_downloadFailScriptURLs?_downloadFailScriptURLs:@[]];
    [temp addObject:url];
    _downloadFailScriptURLs = temp;
}

-(TokenXMLNode *)bodyNode{
    if (_bodyNode == nil) {
        NSArray *bodys = [self.rootNode getElementsByTagName:@"body"];
        if (bodys.count) {
            _bodyNode = bodys[0];
        }
    }
    return _bodyNode;
}

-(TokenXMLNode *)headNode{
    if (_headNode == nil) {
        NSArray *heads = [self.rootNode getElementsByTagName:@"head"];
        if (heads.count) {
            _headNode = heads[0];
        }
    }
    return _headNode;
}

-(TokenXMLNode *)titleNode{
    if (_titleNode == nil) {
        NSArray *nodes = [self.headNode getElementsByTagName:@"title"];
        if (nodes.count) {
            _titleNode = nodes[0];
        }
    }
    return _titleNode;
}

-(TokenXMLNode *)navigationBarNode{
    if (_navigationBarNode == nil) {
        NSArray *nodes = [self.headNode getElementsByTagName:@"navigationBar"];
        if (nodes.count) {
            _navigationBarNode = nodes[0];
        }
    }
    return _navigationBarNode;
}

+(BOOL)supportsSecureCoding{
    return YES;
}

- (void)dealloc
{
    HybridLog(@"TokenDocument dead");
}

@end
