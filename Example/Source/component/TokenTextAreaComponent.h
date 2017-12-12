//
//  TokenTextAreaComponent.h
//  MyWHUT
//
//  Created by 陈雄 on 2017/10/25.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TokenTextAreaNode;
@interface TokenTextAreaComponent : UITextView
@property(nonatomic ,weak) TokenTextAreaNode *associatedNode;
@end
