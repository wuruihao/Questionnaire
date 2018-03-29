/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "ETRefreshTableViewController.h"

#import "MJRefresh.h"

@interface ETRefreshTableViewController ()

@property (nonatomic, readonly) UITableViewStyle style;

@end

@implementation ETRefreshTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style{
    self = [super init];
    if (self) {
        _style = style;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, self.view.frame.size.width, self.view.frame.size.height -64)];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _currentPage = 0;
    _pageSize = 10;
    _showRefreshHeader = NO;
    _showRefreshFooter = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)getListByPage:(NSInteger)page{};

#pragma mark - setter

- (void)setShowRefreshHeader:(BOOL)showRefreshHeader{
    
    if (_showRefreshHeader != showRefreshHeader) {
        _showRefreshHeader = showRefreshHeader;
        if (_showRefreshHeader) {
            __weak ETRefreshTableViewController *weakSelf = self;
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerHeaderRefresh];
                [weakSelf.tableView.mj_header beginRefreshing];
            }];
            //            header.updatedTimeHidden = YES;
        }
        else{
            [self.tableView.mj_header removeFromSuperview];
        }
    }
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter{
    
    if (_showRefreshFooter != showRefreshFooter) {
        _showRefreshFooter = showRefreshFooter;
        if (_showRefreshFooter) {
            __weak ETRefreshTableViewController *weakSelf = self;
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                [weakSelf tableViewDidTriggerFooterRefresh];
                [weakSelf.tableView.mj_footer beginRefreshing];
            }];
        }
        else{
            [self.tableView.mj_footer removeFromSuperview];
        }
    }
}

#pragma mark - getter

- (NSInteger)pageSize {
    
    if (_pageSize<1) {
        _pageSize = 10;
    }
    return _pageSize;
}

- (NSInteger)totalPage {
    if (self.total==0) {
        return 0;
    }
    else {
        return (int)ceil((double)self.total/self.pageSize);
    }
}

- (NSMutableArray *)dataSource{
    
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KCELLDEFAULTHEIGHT;
}

#pragma mark - public refresh

- (void)autoTriggerHeaderRefresh
{
    if (self.showRefreshHeader) {
        [self tableViewDidTriggerHeaderRefresh];
    }
}

/**
 *  下拉刷新事件
 */
- (void)tableViewDidTriggerHeaderRefresh{
    
}

/**
 *  上拉加载事件
 */
- (void)tableViewDidTriggerFooterRefresh{
    
}

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload
{
    __weak ETRefreshTableViewController *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (reload) {
            [weakSelf.tableView reloadData];
        }
        if (isHeader) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        else{
            [weakSelf.tableView.mj_footer endRefreshing];
        }
    });
}

@end
