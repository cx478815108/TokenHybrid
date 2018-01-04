//
//  TokenXMLNode.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/9/26.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenXMLNode.h"
#import "TokenHybridStack.h"
#import "TokenHybridDefine.h"

@implementation TokenXMLNode
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _name       = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"nameKey"];
        _innerText  = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"innerTextKey"];
        _innerAttributes = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:@"innerAttributesKey"];
        _cssAttributes  = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:@"cssAttributesKey"];
        _parentNode = [aDecoder decodeObjectOfClass:[TokenXMLNode class] forKey:@"parentNodeKey"];
        _childNodes = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"childNodesKey"];
        _identifier = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"identifierKey"];
        _innerStyleAttributes = [aDecoder decodeObjectOfClass:[NSDictionary class] forKey:@"innerStyleAttributes"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name       forKey:@"nameKey"];
    [coder encodeObject:_innerText  forKey:@"innerTextKey"];
    [coder encodeObject:_innerAttributes forKey:@"innerAttributesKey"];
    [coder encodeObject:_cssAttributes forKey:@"cssAttributesKey"];
    [coder encodeObject:_parentNode forKey:@"parentNodeKey"];
    [coder encodeObject:_childNodes forKey:@"childNodesKey"];
    [coder encodeObject:_identifier forKey:@"identifierKey"];
    [coder encodeObject:_innerStyleAttributes forKey:@"innerStyleAttributes"];
}

+(BOOL)supportsSecureCoding{
    return YES;
}

-(void)addChildNode:(TokenXMLNode *)childNode{
    NSMutableArray *_childNodeCopy = [NSMutableArray arrayWithArray:_childNodes];
    [_childNodeCopy addObject:childNode];
    _childNodes = _childNodeCopy;
}

-(void)addCSSAttributesFromDictionary:(NSDictionary *)dictionary{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_cssAttributes?_cssAttributes:@{}];
    [dic addEntriesFromDictionary:dictionary];
    _cssAttributes = dic;
}

+(void)enumerateTreeFromRootToChildWithNode:(TokenXMLNode *)rootNode block:(TokenNodeEnumerateBlock)block{
    if (rootNode == nil) { return;}
    TokenHybridStack *stack = [[TokenHybridStack alloc] init];
    BOOL stop = NO;
    [stack push:rootNode];
    while (stack.count && stop == NO) {
        TokenXMLNode *currentNode = [stack top];
        !block?:block(currentNode,&stop);
        [stack pop];
        for (NSInteger i = 0; i <currentNode.childNodes.count; i ++) {
            [stack push:currentNode.childNodes[i]];
        }
    }
}

- (NSString *)description
{
    NSMutableString *desc = [NSMutableString stringWithFormat:@"\n{\n    TokenXMLNode:%p\n",self];
    [desc appendFormat:@"    tag:<%@></%@>\n",_name,_name];
    if (_parentNode) {
        [desc appendFormat:@"    parentNode:<%@></%@>\n",_parentNode.name,_parentNode.name];
    }
    if (_innerAttributes.allKeys.count) {
        [desc appendFormat:@"    attributs:    %@\n",_innerAttributes];
    }
    if (_innerStyleAttributes.allKeys.count) {
        [desc appendFormat:@"    innerStyleAttributs:    %@\n",_innerStyleAttributes];
    }
    if (_identifier.length > 0 ) {
        [desc appendFormat:@"    identifier:%@\n",_identifier];
    }
    
    if (_innerText.length >5) {
        [desc appendFormat:@"    innerText:%@\n",_innerText];
    }

    [desc appendString:@"}\n"];
    return desc;
}
@end

@implementation TokenPureNode
@end

@implementation TokenLabelNode
@end

@implementation TokenScrollNode
@end

@implementation TokenButtonNode
@end

@implementation TokenImageNode
@end

@implementation TokenTextAreaNode
@end

@implementation TokenInputNode
@end

@implementation TokenNavigationBarNode

@end

@implementation TokenTableNode
@end

@implementation TokenSegmentNode

@end

@implementation TokenSwitchNode

@end

@implementation TokenSearchBarNode
@end

@implementation TokenWebViewNode
@end

@implementation TokenDotsNode
@end




