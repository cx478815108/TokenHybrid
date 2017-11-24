//
//  TokenHybridDebugView.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/11/6.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenHybridDebugView.h"
#import "TokenConsoleView.h"
#import "TokenConsolePushView.h"
#import "JHChainableAnimator.h"
#import "TokenCompeleteView.h"

@interface TokenHybridDebugView()<TokenConsoleViewClickDelagate,TokenCompeleteViewDelegate>
@property(nonatomic ,strong) UIScrollView         *scrollView;
@property(nonatomic ,strong) TokenConsoleView     *consoleView;
@property(nonatomic ,strong) UIButton             *execButton;
@property(nonatomic ,strong) JHChainableAnimator  *animator;
@property(nonatomic ,strong) TokenConsolePushView *pushView;
@property(nonatomic ,strong) TokenCompeleteView   *compeleteView;
@property(nonatomic ,strong) TokenCompeleteView   *compeleteView2;
@end

@implementation TokenHybridDebugView{
    BOOL           _pushed;
    NSMutableArray *_logArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.scrollView];
        self.consoleView                     = [[TokenConsoleView alloc] initWithFrame:CGRectZero];
        self.consoleView.backgroundColor     = [UIColor groupTableViewBackgroundColor];
        self.consoleView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.consoleView.rowHeight           = 38.0f;
        self.consoleView.clickDelegate       = self;
        
        self.filed                      = [[UITextField alloc] initWithFrame:CGRectZero];
        self.filed.font                 = [UIFont systemFontOfSize:12.0f];
        self.scrollView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview: self.consoleView];
        [self.scrollView addSubview: self.filed];
        self.scrollView.scrollEnabled  = NO;
        
        self.filed.borderStyle         = UITextBorderStyleRoundedRect;
        self.filed.backgroundColor     = [UIColor groupTableViewBackgroundColor];
        self.filed.clearButtonMode     = UITextFieldViewModeWhileEditing;
        self.filed.keyboardType        = UIKeyboardTypeASCIICapable;
        
        self.filed.placeholder = @"请输入代码JS代码";
        self.execButton        = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [self.execButton setTitle:@"执行" forState:(UIControlStateNormal)];
        [self.execButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [self.execButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [self.execButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [self.scrollView addSubview:self.execButton];
        [self.execButton addTarget:self action:@selector(didPressExecButton) forControlEvents:UIControlEventTouchUpInside];
        
        NSArray *titles = @[
                            @"getElementById",
                            @"getElementsByClassName",
                            @"getElementsByTagName",
                            @"addEventListener"];
        
        NSArray *titles2 = @[
                             @"var",
                             @"=",
                             @".",
                             @"token.",
                             @"alert()",
                             @"log()",
                             @"document.",
                             @"()",
                             @"\"\"",];
        
        self.compeleteView = [[TokenCompeleteView alloc] initWithFrame:CGRectZero titles:titles2];
        self.compeleteView.clickDelegate = self;
        [self.scrollView addSubview:self.compeleteView];
        
        
        self.compeleteView2 = [[TokenCompeleteView alloc] initWithFrame:CGRectZero titles:titles];
        self.compeleteView2.clickDelegate = self;
        [self.scrollView addSubview:self.compeleteView2];
        
        self.pushView = [[TokenConsolePushView alloc] init];
        [self.scrollView addSubview:self.pushView];
        [self.pushView.backButton addTarget:self action:@selector(didPressedBackButton) forControlEvents:UIControlEventTouchUpInside];
        
        _logArray = @[].mutableCopy;
    }
    return self;
}

#pragma mark -

-(void)consoleView:(TokenConsoleView *)consoleView didSelectedRow:(NSInteger)row{
    [self.scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:YES];
    NSString *text = consoleView.dataObjs[row];
    if ([text hasPrefix:@"(String)错误："]) {
        self.pushView.textView.textColor = [UIColor redColor];
    }
    else{
        self.pushView.textView.textColor = [UIColor darkTextColor];
    }
    self.pushView.textView.text = text;
    [self.pushView.textView setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)compeleteView:(TokenCompeleteView *)view didPressedButton:(UIButton *)button{
    [self.filed replaceRange:self.filed.selectedTextRange withText:button.titleLabel.text];
}

-(void)didPressedBackButton{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

-(void)reloadData:(NSArray *)data{
    self.consoleView.dataObjs = data;
    [self.consoleView reloadData];
}

-(void)addLog:(NSString *)log{
    if (log) {
        [_logArray addObject:log];
        self.consoleView.dataObjs = _logArray;
        [self.consoleView reloadData];
    }
}

-(void)clear{
    _logArray = @[].mutableCopy;
    self.consoleView.dataObjs = @[];
    [self.consoleView reloadData];
}

-(void)didPressExecButton{
    if ([self.delegate respondsToSelector:@selector(debugView:didPressExcuseButtonWithScript:)]) {
        [self.delegate debugView:self didPressExcuseButtonWithScript:self.filed.text];
    }
}

-(void)scrollToBottom{
    [self.consoleView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.consoleView.dataObjs.count-1 inSection:0]
                            atScrollPosition:(UITableViewScrollPositionBottom)
                                    animated:YES];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.scrollView.frame       = self.bounds;
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width*2,0);
    CGFloat fieldHeight         = 36.0f;
    self.compeleteView.frame    = CGRectMake(0, fieldHeight + 2, self.frame.size.width, 36);
    self.compeleteView2.frame   = CGRectMake(0, CGRectGetMaxY(self.compeleteView.frame) + 2, self.frame.size.width, 36);
    self.consoleView.frame      = CGRectMake(0, CGRectGetMaxY(self.compeleteView2.frame) + 4,
                                              self.frame.size.width,
                                               self.frame.size.height - CGRectGetMaxY(self.compeleteView2.frame) - 4);
    self.filed.frame            = CGRectMake(4, 2, self.frame.size.width-56, fieldHeight);
    self.execButton.frame       = CGRectMake(CGRectGetMaxX(self.filed.frame)+6, self.filed.frame.origin.y, 44, 40);
    self.pushView.frame         = CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height);
}

@end
