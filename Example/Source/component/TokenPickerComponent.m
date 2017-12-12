//
//  TokenPickerComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/30.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenPickerComponent.h"
#import "UIColor+SSRender.h"
#import "UIColor+Token.h"
#import "UIView+Token.h"

@interface TokenPickerComponent()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic ,strong) UIPickerView *pickerView;
@property(nonatomic ,strong) UIToolbar    *toolBar;
@property(nonatomic ,strong) NSDictionary *data;
@property(nonatomic ,copy  ) TokenPickerComponentSureBlock sureBlock;
@end

@implementation TokenPickerComponent{
    NSDictionary        *_data;
    NSInteger           _component;
    NSInteger           _row;
    CGFloat             _toolBarHeight;
    CGFloat             _pickerViewheight;
    NSMutableDictionary *_resultDictionary;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _toolBarHeight    = 40.0f;
        _pickerViewheight = 240;
        _resultDictionary = @{}.mutableCopy;
    }
    return self;
}

+(void)showInView:(UIView *)superView
             data:(NSDictionary *)data
        sureBlock:(TokenPickerComponentSureBlock)sureBlock{
    TokenPickerComponent *component = [[TokenPickerComponent alloc] initWithFrame: superView.bounds];
    component.sureBlock             = sureBlock;
    component.data                  = data;
    [component showInView:superView];
}

-(void)didPressedCancleItem{
    [self dismiss];
}

-(void)didPressedSureItem{
    [self dismiss];
    if (self.sureBlock == nil) return;
    self.sureBlock(_resultDictionary);
}

-(void)showInView:(UIView *)view
{
    if (view == nil) return;
    
    NSArray *deepth = _data[@"deepth"];
    [deepth enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [_resultDictionary setObject:@"0" forKey:[NSString stringWithFormat:@"%@",@(idx)]];
    }];

    [view addSubview:self];
    self.backgroundColor = UIColor.token_RGBA(0,0,0,0);
    CGFloat width        = [UIScreen mainScreen].bounds.size.width;
    CGFloat height       = [UIScreen mainScreen].bounds.size.height;
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0.25 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.backgroundColor  = UIColor.token_RGBA(0,0,0,0.2);
        self.pickerView.frame = CGRectMake(0, height - _pickerViewheight, width, _pickerViewheight);
        self.toolBar.frame    = CGRectMake(0, self.pickerView.frame.origin.y-_toolBarHeight, width, _toolBarHeight);
    } completion:nil];
}

-(void)dismiss
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor  = UIColor.token_RGBA(0,0,0,0);
        self.pickerView.frame = CGRectMake(0, CGRectGetHeight(self.superview.frame)+_pickerViewheight, width, _pickerViewheight);
        self.toolBar.frame    = CGRectMake(0, CGRectGetHeight(self.superview.frame), width, _toolBarHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    NSArray *deepth = _data[@"deepth"];
    if ([deepth isKindOfClass:[NSArray class]]) {
        return deepth.count;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSArray  *deepth = _data[@"deepth"];
    NSNumber *number = deepth[component];
    return [number integerValue];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *dataArray = _data[@"data"];
    if (![dataArray isKindOfClass:[NSArray class]]) { return @"";}
    NSArray *currentDataArray = dataArray[component];
    if (![currentDataArray isKindOfClass:[NSArray class]]) return @"";
    return [NSString stringWithFormat:@"%@",currentDataArray[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_resultDictionary setObject:[NSString stringWithFormat:@"%@",@(row)] forKey:[NSString stringWithFormat:@"%@",@(component)]];
}

#pragma mark - getter
-(UIPickerView *)pickerView{
    if (_pickerView == nil) {
        CGFloat width = self.superview.frame.size.width;
        CGFloat height = self.superview.frame.size.height;
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height + _toolBarHeight, width, _pickerViewheight)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [self addSubview:_pickerView];
    }
    return _pickerView;
}

-(UIToolbar *)toolBar
{
    if (_toolBar==nil) {
        CGFloat width = self.superview.frame.size.width;
        CGFloat height = self.superview.frame.size.height;
        _toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height, width, _toolBarHeight)];
        [self addSubview:_toolBar];
        
        UIView *topSep = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 0.5)];
        [_toolBar addSubview:topSep];
        
        UIView *bottomSep = [[UIView alloc] initWithFrame:CGRectMake(0, _toolBarHeight -1, width, 0.5)];
        [_toolBar addSubview:bottomSep];
        
        bottomSep.backgroundColor = topSep.backgroundColor = UIColor.token_RGB(200,200,200);
        
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"  取消" style:UIBarButtonItemStylePlain target:self action:@selector(didPressedCancleItem)];
        [leftItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.token_RGB(29, 29, 38), NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} forState:UIControlStateNormal];
        UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定  " style:UIBarButtonItemStylePlain target:self action:@selector(didPressedSureItem)];
        [rightItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColor.token_RGB(29, 29, 38),NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} forState:UIControlStateNormal];
        _toolBar.items=@[leftItem,flexItem,rightItem];
    }
    return _toolBar;
}
@end
