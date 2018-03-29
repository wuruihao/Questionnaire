//
//  QuestionController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/23.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "QuestionController.h"
#import "QuestionCell.h"
#define APPName  ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"])
#define BundleID ([[NSBundle mainBundle] bundleIdentifier])

@interface QuestionController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation QuestionController

static NSString *cellId = @"questionCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleLabel.text = APPName;
    
    self.showRefreshHeader = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = COLOR_HEX(0xeeeeee);
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self refreshData];
}

- (void)refreshData {
    
    kWeakSelf;
    AVQuery *query = [AVQuery queryWithClassName:@"BianShen"];
    [query orderByDescending:@"createdAt"];
    [query whereKey:@"bid" equalTo:BundleID];
    // image 为 File
    [query includeKey:@"image"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        if (!error) {
            [weakSelf.dataSource removeAllObjects];
            [weakSelf.dataSource addObjectsFromArray:objects];
            [weakSelf.tableView reloadData];
        }else {
            [[ETMessageView sharedInstance]showMessage:@"服务器开小差了~" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    [cell configureWithItem:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AVObject *detail = self.dataSource[indexPath.row];
    NSString *desc   = [detail objectForKey:@"desc"];
    NSString *url    = [detail objectForKey:@"url"];
    if (desc) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kScreenHeight*0.1;
}

/**
 *  下拉刷新事件
 */
- (void)tableViewDidTriggerHeaderRefresh{
    
    [self refreshData];
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

/**
 *  上拉加载事件
 */
- (void)tableViewDidTriggerFooterRefresh{
    
}

@end
