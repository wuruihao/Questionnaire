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

#import <UIKit/UIKit.h>

#define KCELLDEFAULTHEIGHT 50

@interface ETRefreshTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) NSInteger total;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger totalPage;
@property (assign, nonatomic) NSInteger currentPage;


@property (assign, nonatomic) BOOL showRefreshHeader;//是否支持下拉刷新
@property (assign, nonatomic) BOOL showRefreshFooter;//是否支持上拉加载

- (instancetype)initWithStyle:(UITableViewStyle)style;

- (void)tableViewDidTriggerHeaderRefresh;//下拉刷新事件
- (void)tableViewDidTriggerFooterRefresh;//上拉加载事件

- (void)tableViewDidFinishTriggerHeader:(BOOL)isHeader reload:(BOOL)reload;

@end
