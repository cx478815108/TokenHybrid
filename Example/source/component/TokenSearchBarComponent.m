//
//  TokenSearchBarComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/30.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenSearchBarComponent.h"
#import "TokenHybridConstant.h"
#import "UIColor+SSRender.h"
#import "NSString+Token.h"
#import "UIView+Attributes.h"
#import "TokenXMLNode.h"

@interface TokenSearchBarComponent()<UISearchBarDelegate>
@end

@implementation TokenSearchBarComponent
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveEndEditingNotification) name:TokenHybridEndEditingNotification object:nil];
    }
    return self;
}

-(void)didReceiveEndEditingNotification{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resignFirstResponder];
    });
}

-(void)token_updateAppearanceWithNormalDictionary:(NSDictionary *)dictionary{
    [super token_updateAppearanceWithNormalDictionary:dictionary];
    NSDictionary *d = dictionary;
    NSString *color = d[@"cursorColor"];
    if (color) { self.tintColor = [UIColor ss_colorWithString:color];}
    color = d[@"barColor"];
    if (color) {
        self.barTintColor = [UIColor ss_colorWithString:color];
    }
    NSString *showsCancelButton = d[@"showsCancelButton"];
    if (showsCancelButton)    {
        self.showsCancelButton = showsCancelButton.token_turnBoolStringToBoolValue();
    }
    self.placeholder = d[@"placeHolder"];
}
#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (self.associatedNode.onBeginEditing) {
        [self.associatedNode.onBeginEditing.value callWithArguments:nil];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    if (self.associatedNode.onEndEditing) {
        [self.associatedNode.onEndEditing.value callWithArguments:nil];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (self.associatedNode.onTextChange) {
        [self.associatedNode.onTextChange.value callWithArguments:@[searchText]];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    if (self.associatedNode.onSearchButtonClick) {
        [self.associatedNode.onSearchButtonClick.value callWithArguments:@[searchBar.text]];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    if (self.associatedNode.onCancleButtonClick) {
        [self.associatedNode.onCancleButtonClick.value callWithArguments:nil];
    }
}

@end
