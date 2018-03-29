
//
//  EditAnswerController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/18.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "EditAnswerController.h"

@interface EditAnswerController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) AnswerTitleView *answerTitleView;

@property (strong, nonatomic) NSMutableArray *addAnswers;
@property (strong, nonatomic) NSMutableArray *answerList;

@property (strong, nonatomic) NSMutableArray *titles;
@property (strong, nonatomic) NSMutableArray *answers;

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UILabel *answerNum;
@property (strong, nonatomic) UIButton *addButton;

@property (assign, nonatomic) NSInteger answerId;

@property (assign, nonatomic) NSInteger page;

@end

@implementation EditAnswerController

static NSString *cellId = @"answerOptionsCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.leftButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.rightButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.saveButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    [self.leftButton addLineWithCorner:5];
    [self.rightButton addLineWithCorner:5];
    
    [self.tableView addLineWithCorner:10];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"AnswerOptionsCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    self.page = 1;
    self.leftButton.hidden = YES;
    
   UIView *footerView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, kScreenHeight*0.06)];
    [footerView addSubview:self.addButton];
    self.tableView.tableFooterView = footerView;
    
    self.tableView.tableHeaderView = self.answerTitleView;
    
    [self initDataSource];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveAnswer:(id)sender {
    
    //判断数据是否完整
    NSInteger i = 0;
    for (AnswerData *answerData in self.dataSource) {
        if (![ETRegularUtil isEmptyString:answerData.value]) {
            i++;
        }
    }
    if ([ETRegularUtil isEmptyString:self.answerTitleView.answerTitle.text] || i != self.dataSource.count) {
        [[ETMessageView sharedInstance]showMessage:@"请填写完善信息" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    
    //保存问卷数据
    [self addAnswerData];
    
    //提交问卷
    [self submitQuestionnaire];
}
- (void)isEmptyData{
    

}
- (NSArray *)sortQNData{
    
    NSMutableArray *totalArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.titles.count; i++) {
        NSString *title = self.titles[i];
        NSArray *anwsersArray = self.answers[i];
        NSMutableArray *uploadAnswers = [NSMutableArray array];
        for (NSInteger j = 0; j < anwsersArray.count; j++) {
            AnswerData *answerData = anwsersArray[j];
            NSDictionary *singeDic = @{@"num":[NSString stringWithFormat:@"%ld", j+1], @"value":answerData.value};
            [uploadAnswers addObject:singeDic];
        }
        NSDictionary *completeQN = @{@"answer":uploadAnswers,@"name":title};
        [totalArray addObject:completeQN];
    }
    
    return totalArray;
}

- (void)submitQuestionnaire{
    
    for (int i = 0; i < self.homeData.answerList.count; i++) {
        AnswerListData *answerListData = self.homeData.answerList[i];
        [self.titles addObject:answerListData.name];
        [self.answers addObject:answerListData.answers];
    }
    
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];
    
    self.view.userInteractionEnabled = NO;
    
    AVObject *object = [[AVObject alloc] initWithClassName:@"RH_Questionnaire"];
    [object setObject:self.homeData.title forKey:@"title"];
    [object setObject:self.homeData.time forKey:@"endDate"];
    [object setObject:[self sortQNData] forKey:@"question"];
    [object setObject:BidID forKey:@"questionId"];
    [object setObject:[NSNumber numberWithInteger:0] forKey:@"copies"];
    [object setObject:@"3" forKey:@"stateType"];
    [object setObject:self.homeData.questionType forKey:@"questionType"];
    NSData *imageData = UIImageJPEGRepresentation(self.homeData.iocnImage, 0.5);
    AVFile *file = [AVFile fileWithData:imageData];
    [object setObject:file forKey:@"image"];
    
    kWeakSelf;
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        weakSelf.view.userInteractionEnabled = YES;
        if (succeeded) {
            [[ETMessageView sharedInstance] showMessage:@"上传成功" onView:self.view Type:MESSAGE_ALERT_DELAY];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [[ETMessageView sharedInstance] showMessage:@"上传失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }];
}

- (IBAction)clickNextOperation:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{
            //删除问卷
            [self deleteData];
        }
            break;
        case 1:{
            //判断数据是否完整
            NSInteger i = 0;
            for (AnswerData *answerData in self.dataSource) {
                if (![ETRegularUtil isEmptyString:answerData.value]) {
                    i++;
                }
            }
            if ([ETRegularUtil isEmptyString:self.answerTitleView.answerTitle.text] || i != self.dataSource.count) {
                [[ETMessageView sharedInstance]showMessage:@"请填写完善信息" onView:self.view Type:MESSAGE_ALERT_DELAY];
                return;
            }
            //添加问卷数据
            [self addAnswerData];
            self.page++;
            [UIView setPushAnimation:self.tableView];
            //初始化问卷模板
            [self initDataSource];
        }
            break;
        default:
            break;
    }
    if (self.page <= 1) {
        self.leftButton.hidden = YES;
    }else{
        self.leftButton.hidden = NO;
    }
}
//初始化数据
- (void)initDataSource{
    
    AnswerData *data = [[AnswerData alloc]init];
    AnswerData *data2 = [[AnswerData alloc]init];
    self.answerTitleView.answerTitle.text = @"";
    self.answerTitleView.answerNum.text = [NSString stringWithFormat:@"Q%ld:",(long)self.page];
    self.dataSource = [@[data,data2] mutableCopy];
    [self.tableView reloadData];
    
    if (self.page == 1) {
        self.leftButton.hidden = YES;
    }else{
       self.leftButton.hidden = NO;
    }
}

//新建数据
- (void)addAnswerData{
 
    AnswerListData *new = [[AnswerListData alloc] init];
    new.name = [NSString stringWithFormat:@"%@%@",self.answerTitleView.answerNum.text,self.answerTitleView.answerTitle.text];
    [self.addAnswers  removeAllObjects];
    for (AnswerData *answerData in self.dataSource) {
        if (![ETRegularUtil isEmptyString:answerData.value]) {
            [self.addAnswers addObject:answerData];
        }
    }
    new.answers = [self.addAnswers mutableCopy];
    
    //初始化用户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *answerId = [userDefaults objectForKey:@"answerId"];
    //这里判空避免拿不到数据 崩溃
    if (![ETRegularUtil isEmptyString:answerId]) {
        self.answerId = [answerId integerValue];
    }
    new.answerId = ++self.answerId;
    //快速创建
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",(long)self.answerId] forKey:@"recordId"];
    //必须
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self.answerList addObject:new];
    self.homeData.answerList = self.answerList;
}

//删除数据
- (void)deleteData{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"删除问卷" message:@"您确定要删除新建的内容吗 ?" preferredStyle:UIAlertControllerStyleAlert];
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                                 if (self.homeData.answerList.count > 0) {
                                    
                                     [self.homeData.answerList removeObjectAtIndex:self.page-2];
                                 }
                                
                                 self.page--;
                                 [self initDataSource];
                                 
                             }];
    UIAlertAction* action1 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {
                              }];
    [alert addAction:action];
    [alert addAction:action1];
    [self presentViewController:alert
                       animated:YES completion:nil];
}

- (void)reloadDataSource{
    
    AnswerListData *answerListData = self.homeData.answerList[self.page-1];
    self.answerTitleView.answerNum.text = [NSString stringWithFormat:@"Q%ld:",(long)self.page];
    self.dataSource = [answerListData.answers mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (AnswerTitleView *)answerTitleView{

    if (!_answerTitleView) {
        _answerTitleView = [[AnswerTitleView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, kScreenHeight*0.08)];
    }
    return _answerTitleView;
}

- (NSMutableArray *)answerList{

    if (!_answerList) {
        _answerList = [NSMutableArray array];
    }
    return _answerList;
}

- (UIButton *)addButton{
    
    if (!_addButton) {
        _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _addButton.frame = CGRectMake(self.tableView.width*0.1, 0, self.tableView.width*0.8, kScreenHeight*0.06);
        [_addButton setTitle:@"添加选项" forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(addAnsweroptions:) forControlEvents:UIControlEventTouchUpInside];
        _addButton.backgroundColor = COLOR_HEX(0x9ECFF7);
        _addButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(17)];
        [_addButton addLineWithCorner:10];
    }
    return _addButton;
}

- (void)addAnsweroptions:(UIButton *)sender{
    
    AnswerData *data = [[AnswerData alloc]init];
    [self.dataSource addObject:data];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataSource{
    
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)addAnswers{

    if (!_addAnswers) {
        _addAnswers = [NSMutableArray array];
    }
    return _addAnswers;
}

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
    cell.isOptions = YES;
    cell.data = data;
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kScreenHeight*0.1;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    if(editingStyle == UITableViewCellEditingStyleDelete){
        
        if (self.dataSource.count > 2) {
            // 从数据源中删除
            [self.dataSource removeObjectAtIndex:indexPath.row];
            // 从列表中删除
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else{
            [[ETMessageView sharedInstance]showMessage:@"不少于两个选项" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
