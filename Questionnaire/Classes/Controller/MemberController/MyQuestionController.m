//
//  MyQuestionController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/18.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "MyQuestionController.h"

@interface MyQuestionController () <UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) EmptyView *emptyView;

@end

@implementation MyQuestionController

static NSString *cellId = @"homeCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = COLOR_HEX(0xeeeeee);
    
    [self.view addSubview:self.emptyView];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)createQuestionnaire:(UIButton *)sender {
    
    EditQuestioController *vc = [[EditQuestioController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self updateData];
}

- (void)updateData{
    
    kWeakSelf;
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ALERT_DELAY];

    //问卷数据
    AVQuery *query = [AVQuery queryWithClassName:@"RH_Questionnaire"];
    [query whereKey:@"questionType" equalTo:@"8"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (error) {
            //            NSLog(@"%@",[CenterModel showErrorMessage:error]);
        }else{
            NSMutableArray *datas = [NSMutableArray array];
            for (AVObject *obj in objects) {
                NSString *title = [obj objectForKey:@"title"];
                NSString *endDate = [obj objectForKey:@"endDate"];
                NSNumber *copies = [obj objectForKey:@"copies"];
                AVFile *imageFile = [obj objectForKey:@"image"];
//                AVObject *answer = [obj objectForKey:@"answer"];
                NSString *stateType = [obj objectForKey:@"stateType"];
                NSString *questionType = [obj objectForKey:@"questionType"];
                NSArray *question = [obj objectForKey:@"question"];

                NSMutableArray *answerListArray = [NSMutableArray array];
                for (NSDictionary *dic in question) {
                    NSArray *answers = [dic objectForKey:@"answer"];
                    NSMutableArray *answerArray = [NSMutableArray array];
                    AnswerListData *answerListData = [[AnswerListData alloc]init];
                    for (NSDictionary *numdic in answers) {
                        NSString *num = [numdic objectForKey:@"num"];
                        NSString *value = [numdic objectForKey:@"value"];
                        AnswerData *answerData = [[AnswerData alloc]init];
                        answerData.num = num;
                        answerData.value = value;
                        [answerArray addObject:answerData];
                    }
                    NSString *name = [dic objectForKey:@"name"];
                    answerListData.name = name;
                    answerListData.answers = [answerArray mutableCopy];
                    [answerListArray addObject:answerListData];
                }

                HomeData *data = [[HomeData alloc] initWithTitle:title objectId:obj.objectId subTitle:[NSString stringWithFormat:@"%ld",(long)[copies integerValue]] image:imageFile.url time:endDate titleId:@"" stateType:stateType questionType:questionType answerList:answerListArray];
                [datas addObject:data];
            }
            if (datas.count > 0) {
                weakSelf.tableView.hidden = NO;
                weakSelf.emptyView.hidden = YES;
                weakSelf.dataSource = datas;
            }else{
                weakSelf.tableView.hidden = YES;
                weakSelf.emptyView.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        }
    }];
}

- (EmptyView *)emptyView{

    if (!_emptyView) {
        _emptyView = [[EmptyView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) WithoutSomething:@"请点击新建我的问卷!"];
    }
    return _emptyView;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreenHeight*0.17;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeData *homeData = self.dataSource[indexPath.row];
    if (![homeData.stateType isEqualToString:@"1"]){
        return;
    }
    SurveyController *vc = [[SurveyController alloc]init];
    vc.homeData = homeData;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  下拉刷新事件
 */
- (void)tableViewDidTriggerHeaderRefresh{
    
    [self updateData];
    [self tableViewDidFinishTriggerHeader:YES reload:YES];
}

/**
 *  上拉加载事件
 */
- (void)tableViewDidTriggerFooterRefresh{
    
}

@end
