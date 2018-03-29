//
//  SurveyController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "SurveyController.h"

@interface SurveyController () <UITableViewDelegate,UITableViewDataSource,AnswerOptionsCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *currentPage;

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *answers;

@property (strong, nonatomic) NSMutableArray *selectedSource;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) NSInteger page;

@end

@implementation SurveyController

static NSString *cellId = @"answerOptionsCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.leftButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.rightButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    [self.leftButton addLineWithCorner:5];
    [self.rightButton addLineWithCorner:5];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.tableView addLineWithCorner:5];
    self.tableView.bounces = NO;
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerOptionsCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    if (![ETRegularUtil isEmptyString:self.homeData.title]) {
        self.titleLabel.text = self.homeData.title;
    }else{
        self.titleLabel.text = @"问卷详情";
    }
    self.page = 1;
    self.currentIndex = 0;
    self.leftButton.hidden = YES;
    [self reloadDataSource];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitAction:(UIButton *)sender {
    
    NSInteger i = 0;
    for (AnswerListData *answerListData in self.homeData.answerList) {
        if (!answerListData.isAnswered) {
            i++;
        }
    }
    if (i == 0) {
        [self submitAnswer];
    }else{
        NSString *message = [NSString stringWithFormat:@"还有%ld道问卷未完成不能提交",(long)i];
        [[ETMessageView sharedInstance]showMessage:message onView:self.view Type:MESSAGE_ALERT_DELAY];
    }
}

- (NSArray *)sortQNData{

    NSMutableArray *totalArray = [NSMutableArray array];

    for (NSInteger i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        NSArray *anwsersArray = self.answers[i];
        NSMutableArray *uploadAnswers = [NSMutableArray array];
        for (NSInteger j = 0; j < anwsersArray.count; j++) {
            AnswerData *answerData = anwsersArray[j];
            NSString *isSelected = [NSString stringWithFormat:@"%d",answerData.isSelected];
            NSDictionary *singeDic = @{@"num":[NSString stringWithFormat:@"%ld", j+1], @"value":answerData.value,@"isSelected":isSelected};
            [uploadAnswers addObject:singeDic];
        }
        NSDictionary *completeQN = @{@"answer":uploadAnswers,@"name":title};
        [totalArray addObject:completeQN];
    }

    return totalArray;
}

- (void)submitAnswer{
    
    for (int i = 0; i < self.homeData.answerList.count; i++) {
        AnswerListData *answerListData = self.homeData.answerList[i];
        [self.titles safelyAddObject:answerListData.name];
        [self.answers safelyAddObject:answerListData.answers];
    }
    
    self.view.userInteractionEnabled = NO;
    
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];

    //用objectid初始化实例
    AVObject *newObject = [AVObject objectWithClassName:@"RH_Questionnaire" objectId:self.homeData.objectId];
    [newObject incrementKey:@"copies" byAmount:@(1)];
    [newObject setObject:@"2" forKey:@"stateType"];
    [newObject setObject:[self sortQNData] forKey:@"answer"];
    kWeakSelf;
    [newObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        self.view.userInteractionEnabled = YES;
        if (succeeded) {
            [[ETMessageView sharedInstance] showMessage:@"上传成功" onView:self.view Type:MESSAGE_ALERT_DELAY];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [[ETMessageView sharedInstance] showMessage:@"上传失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }];
}

- (IBAction)clickOperation:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{
            self.page--;
            [UIView setPopAnimation:self.tableView];
        }
            break;
        case 1:{
            
            self.page++;
            [UIView setPushAnimation:self.tableView];
        }
            break;
        default:
            break;
    }
    if (self.page <= 1) {
        self.leftButton.hidden = YES;
    }else if (self.page == self.homeData.answerList.count) {
        self.rightButton.hidden = YES;
        self.leftButton.hidden = NO;
    }else{
        self.leftButton.hidden = NO;
        self.rightButton.hidden = NO;
    }
    
    [self reloadDataSource];
}

- (void)reloadDataSource{
    
    if (self.homeData.answerList.count == 1) {
        self.leftButton.hidden = YES;
        self.rightButton.hidden = YES;
    }
    
    self.currentPage.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.page,self.homeData.answerList.count];
    AnswerListData *answerListData = self.homeData.answerList[self.page-1];
    self.currentIndex = answerListData.selectedIndex;
    self.dataSource = [answerListData.answers mutableCopy];
    [self.tableView reloadData];
}
#pragma mark - Table view data source

- (NSMutableArray *)titles{
    
    if (!_titles) {
        _titles = [NSMutableArray array];
    }
    return _titles;
}

- (NSMutableArray *)answers{
    
    if (!_answers) {
        _answers = [NSMutableArray array];
    }
    return _answers;
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectedSource{
    
    if (!_selectedSource) {
        _selectedSource = [NSMutableArray array];
    }
    return _selectedSource;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AnswerOptionsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    //单选
    AnswerData *data = self.dataSource[indexPath.row];
    if (self.currentIndex == 0) {
        data.isSelected = NO;
    }else{
        if (self.currentIndex == indexPath.row+1) {
            data.isSelected = YES;
        }else{
            data.isSelected = NO;
        }
    }
    cell.index = indexPath.row;
    cell.delegate = self;
    cell.isOptions = NO;
    cell.data = data;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreenHeight*0.1;
}

- (void)cell:(AnswerOptionsCell *)cell didSelectRowAtIndexPath:(NSInteger)index{
    
    self.currentIndex = index+1;
    
    AnswerData *data = self.dataSource[index];
    data.isSelected = YES;
    //更新数据
    AnswerListData *answerListData = self.homeData.answerList[self.page-1];
    answerListData.isAnswered = YES;
    answerListData.selectedIndex = index+1;
    AnswerData *answerData = answerListData.answers[index];
    answerData = data;
    [self.selectedSource addObject:answerListData];
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return kScreenHeight*0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, kScreenHeight*0.1)];
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.05, 0, view.width-kScreenWidth*0.1, view.height)];
    [view addSubview:headTitle];
    headTitle.numberOfLines = 0;
    headTitle.font = [UIFont fontWithName:TextFont size:kSize(20)];
    AnswerListData *answerListData = self.homeData.answerList[self.page-1];
    headTitle.text = answerListData.name;
    return view;
}


@end
