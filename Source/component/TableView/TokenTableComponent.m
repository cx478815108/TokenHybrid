//
//  TokenTableComponent.m
//  HybridDemo
//
//  Created by 陈雄 on 2017/10/27.
//  Copyright © 2017年 com.feelings. All rights reserved.
//

#import "TokenTableComponent.h"
#import "TokenXMLNode.h"
#import "TokenTableCell.h"
#import "TokenTableSectionView.h"
#import "TokenHybridConstant.h"
#import "TokenDataItem.h"
#import "NSString+Token.h"
#import "TokenPureComponent.h"
#import "UIColor+SSRender.h"
#import "UIView+Attributes.h"
#import "TokenJSContext.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface TokenTableComponent() <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic ,strong) NSMutableArray  *rowData;
@property(nonatomic ,strong) NSMutableArray  *sectionData;
@end

@implementation TokenTableComponent{
    NSNumber     *_rowHeight;
    NSNumber     *_sectionHeaderHeight;
    NSNumber     *_sectionMargin;
    UIView       *_tableHeaderView;
    UIView       *_tableFooterView;
    TokenXMLNode *_tableRowNode;
    TokenXMLNode *_tableHeaderNode;
    TokenXMLNode *_tableSectionNode;
    TokenXMLNode *_tableFooterNode;
    TokenXMLNode *_configNode;
    UIColor      *_cellContentColorCache;
    UIColor      *_cellColorCache;
    UIColor      *_cellHighlightColor;
    BOOL         _showSectionView;
}

-(instancetype)initWithConfigNode:(TokenXMLNode *)configNode{
    if (self = [super init]) {
        _configNode = configNode;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRootViewFinishApplyLayout) name:TokenHybridComponentDidApplyLayoutNotification object:nil];
        [self configTableView];
    }
    return self;
}

-(void)configTableView{
    NSString *style = _configNode.innerAttributes[@"displayStyle"];
    if ([style isEqualToString:@"group"]) {
       _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    }
    else {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    }
    
    NSString *showSeparator =  _configNode.innerAttributes[@"showSeparator"];
    if (showSeparator) {
        if ([showSeparator token_turnBoolStringToBoolValue]) {
            _tableView.separatorStyle  = UITableViewCellSeparatorStyleSingleLine;
        }
        else {
            _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        }
    }
    NSString *separatorInset =  _configNode.innerAttributes[@"separatorInset"];
    if (separatorInset) {
        _tableView.separatorInset = UIEdgeInsetsFromString(separatorInset);
    }
    
    NSString *rowSectionHeight = _configNode.innerAttributes[@"rowSectionHeight"];
    if (rowSectionHeight) {
        _sectionHeaderHeight = @([rowSectionHeight.token_replace(@"px",@"") floatValue]);
    }
    
    NSString *rowHeight = _configNode.innerAttributes[@"rowHeight"];
    if (rowHeight) {
        _rowHeight = @([rowHeight.token_replace(@"px",@"") floatValue]);
    }
    
    NSString *showSectionView = _configNode.innerAttributes[@"showSectionView"];
    if (showSectionView) {
        _showSectionView = showSectionView.token_turnBoolStringToBoolValue();
    }
    else _showSectionView = YES;
    
    NSString *cellHighlightColorString =_configNode.innerAttributes[@"cellHighlightColor"];
    if (cellHighlightColorString) {
        _cellHighlightColor = [UIColor ss_colorWithString:cellHighlightColorString];
    }
    
    [_tableView registerClass:[TokenTableCell class] forCellReuseIdentifier:[TokenTableCell reuseIdentifier]];
    [_tableView registerClass:[TokenTableSectionView class] forHeaderFooterViewReuseIdentifier:[TokenTableSectionView reuseIdentifier]];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    if (@available(iOS 11, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)reloadData:(NSArray *)dataArray{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        _rowData = @[].mutableCopy;
        _sectionData = @[].mutableCopy;
        NSDictionary *customForLoop = [self getDataRenderProperityName];
        [dataArray enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull sectionData, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *rowDataArray = sectionData[@"rowsData"];
            if ([rowDataArray isKindOfClass:[NSArray class]]) {
                NSMutableArray *sectionRowArray = @[].mutableCopy;
                [rowDataArray enumerateObjectsUsingBlock:^(NSDictionary  *_Nonnull itemDataObj, NSUInteger idx2, BOOL * _Nonnull stop) {
                    TokenDataItem *item = [TokenDataItem itemWithDataObj:itemDataObj customForLoop:customForLoop];
                    item.identify = [NSString stringWithFormat:@"%@-%@",@(idx),@(idx2)];
                    [sectionRowArray addObject:item];
                }];
                
                [_rowData addObject:sectionRowArray];
            }
            
            NSDictionary *secData = sectionData[@"sectionData"];
            if ([secData isKindOfClass:[NSDictionary class]]) {
                TokenDataItem *item = [TokenDataItem itemWithDataObj:secData customForLoop:customForLoop];
                [_sectionData addObject:item];
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (_sectionData.count == _rowData.count) {
                [self.tableView reloadData];
            }
        });
    });
}

-(void)scrollToTop:(BOOL)animate{
    if (_sectionData.count && _rowData.count) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }
}

#pragma mark - notification
-(void)didReceiveRootViewFinishApplyLayout{
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[UITableView class]]) {
            if ([obj isKindOfClass:[TokenTableHeaderComponent class]]) {
                _tableHeaderView = obj;
            }
            else if ([obj isKindOfClass:[TokenTableFooterComponent class]]){
                _tableFooterView = obj;
            }
            [obj removeFromSuperview];
        }
    }];
    [self configWithNode:_configNode];
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = _tableHeaderView;
    if (_tableFooterView == nil) {
        _tableFooterView = [[UIView alloc] init];
    }
    self.tableView.tableFooterView = _tableFooterView;
}

-(void)configWithNode:(TokenXMLNode *)configNode{
    [configNode.childNodes enumerateObjectsUsingBlock:^(TokenXMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"tableHeader"]) {
            _tableHeaderNode = obj;
        }
        else if ([obj.name isEqualToString:@"tableSection"]){
            _tableSectionNode = obj;
        }
        
        else if ([obj.name isEqualToString:@"tableRow"]){
            //配置cell 全局属性
            _tableRowNode = obj;
        }
        else if ([obj.name isEqualToString:@"tableFooter"]){
            _tableFooterNode = obj;
        }
    }];
    
    NSString *sectionMargin = configNode.innerAttributes[@"sectionMargin"];
    if (sectionMargin) {
        _sectionMargin = @([sectionMargin.token_replace(@"px",@"") floatValue]);
    }
    [self token_updateAppearanceWithNormalDictionary:configNode.innerAttributes];
}

#pragma mark - layout
-(void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.backgroundColor = self.backgroundColor;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionData.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *singleRowArray = self.rowData[section];
    return singleRowArray.count;
}

-(__kindof UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TokenTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[TokenTableCell reuseIdentifier]];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (_tableSectionNode == nil) return nil;
    if (_showSectionView == NO) return nil;
    TokenTableSectionView *sectionView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[TokenTableSectionView reuseIdentifier]];
    [sectionView configHierarchyWithNode:_tableSectionNode];
    sectionView.section = section;
    sectionView.dataItem = self.sectionData[section];
    return sectionView;
}

- (void)configureCell:(TokenTableCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    [cell configHierarchyWithNode:_tableRowNode];
    cell.fd_enforceFrameLayout = NO;
    cell.indexPath = indexPath;
    if (self.rowData.count == 0) return;
    NSArray *data = self.rowData[indexPath.section];
    if (indexPath.row <= data.count - 1) {
        cell.dataItem  = data[indexPath.row];
    }
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _cellColorCache = cell.backgroundColor;
    _cellContentColorCache = cell.contentView.backgroundColor;
    cell.backgroundColor = _cellHighlightColor?_cellHighlightColor:UIColor.groupTableViewBackgroundColor;
    cell.contentView.backgroundColor = _cellHighlightColor?_cellHighlightColor:UIColor.groupTableViewBackgroundColor;
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=_cellColorCache;
    cell.contentView.backgroundColor=_cellContentColorCache;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_rowHeight) { return [_rowHeight floatValue];}
    TokenDataItem *item = self.rowData[indexPath.section][indexPath.row];
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[TokenTableCell reuseIdentifier] cacheByKey:item.identify configuration:^(TokenTableCell *cell) {
        [self configureCell:cell atIndexPath:indexPath];
    }];
    return height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_sectionHeaderHeight) return [_sectionHeaderHeight floatValue];
    CGFloat height = [tableView fd_heightForHeaderFooterViewWithIdentifier:[TokenTableSectionView reuseIdentifier] configuration:^(TokenTableSectionView *headerFooterView) {
        TokenDataItem *item = self.sectionData[section];
        headerFooterView.dataItem = item;
    }];
    return height;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    TokenDataItem *dataItem = self.sectionData[section];
    return dataItem.dataObj[@"sectionHeaderTitle"];
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    TokenDataItem *dataItem = self.sectionData[section];
    return dataItem.dataObj[@"sectionFooterTitle"];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return [_sectionMargin floatValue];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.associatedNode.onClick) {
        [self.associatedNode.onClick.value callWithArguments:@[@(indexPath.section),@(indexPath.row)]];
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    _cellColorCache = cell.backgroundColor;
    _cellContentColorCache = cell.contentView.backgroundColor;
    cell.backgroundColor = _cellHighlightColor?_cellHighlightColor:UIColor.groupTableViewBackgroundColor;
    cell.contentView.backgroundColor = _cellHighlightColor?_cellHighlightColor:UIColor.groupTableViewBackgroundColor;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cell.backgroundColor=_cellColorCache;
        cell.contentView.backgroundColor=_cellContentColorCache;
    });
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor=_cellColorCache;
    cell.contentView.backgroundColor=_cellContentColorCache;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (self.associatedNode.didScroll) {
        [self.associatedNode.didScroll.value callWithArguments:nil];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.associatedNode.didEndDecelerating) {
        [self.associatedNode.didEndDecelerating.value callWithArguments:nil];
    }
}

#pragma makk - getter
-(NSDictionary *)getDataRenderProperityName{
    NSString *forIndexProperityName         = _configNode.innerAttributes[@"for-index"];
    NSString *forItemProperityName          = _configNode.innerAttributes[@"for-item"];
    NSString *forSectionIndexProperityName  = _configNode.innerAttributes[@"for-sectionIndex"];
    NSMutableDictionary *dic = @{}.mutableCopy;
    [dic setObject:forIndexProperityName?forIndexProperityName:@"idx" forKey:@"forIndex"];
    [dic setObject:forItemProperityName?forItemProperityName:@"item" forKey:@"forItem"];
    [dic setObject:forSectionIndexProperityName?forSectionIndexProperityName:@"section" forKey:@"forSection"];
    return dic;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
