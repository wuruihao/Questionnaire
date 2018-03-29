//
//  RootController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "RootController.h"

@interface RootController () <ImageScrollDelegate>

@property (nonatomic, strong) ImageScroll *bannerView;

@end

@implementation RootController

static NSString *cellId = @"homeCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    
    [UIView setShadowLayer:self.bannerView];
    [self.view addSubview:self.bannerView];
    
    self.tableView.tableHeaderView = self.bannerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeCell" bundle:nil] forCellReuseIdentifier:cellId];
    self.tableView.backgroundColor = COLOR_HEX(0xeeeeee);
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self updateData];
}

- (void)updateData{
    
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ALERT_DELAY];
    
    kWeakSelf;
    //广告数据
    NSMutableArray *bannerArray = [NSMutableArray array];
    AVQuery *banerQuery = [AVQuery queryWithClassName:@"RH_Banner"];
    [banerQuery whereKey:@"bannerId" equalTo:BidID];
    [banerQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (error) {
//            NSLog(@"%@",[CenterModel showErrorMessage:error]);
        }else{
            for (AVObject *obj in objects) {
                AVFile *imageFile = [obj objectForKey:@"imageFile"];
                if (![ETRegularUtil isEmptyString:imageFile.url]) {
                    [bannerArray safelyAddObject:imageFile.url];
                }
            }
            if (bannerArray.count > 0) {
                [weakSelf.bannerView setContentData:bannerArray];
            }else{
                [weakSelf.bannerView setContentData:@[@"home_default_banner.png",@"home_default_banner.png",@"home_default_banner.png"]];
            }
        }
    }];

    //问卷数据
    AVQuery *dataQuery = [AVQuery queryWithClassName:@"RH_Questionnaire"];
    [dataQuery whereKey:@"questionId" equalTo:BidID];
    [dataQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (error) {
//            NSLog(@"%@",[CenterModel showErrorMessage:error]);
        }else{
            NSMutableArray *datas = [NSMutableArray array];
            for (AVObject *obj in objects) {
                NSString *title = [obj objectForKey:@"title"];
                NSString *userId = [obj objectForKey:@"userId"];
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
                if (![stateType isEqualToString:@"3"]) {
                    HomeData *data = [[HomeData alloc] initWithTitle:title objectId:obj.objectId subTitle:[NSString stringWithFormat:@"%ld",(long)[copies integerValue]] image:imageFile.url time:endDate titleId:@"" stateType:stateType questionType:questionType answerList:answerListArray];
                    [datas addObject:data];
                }
            }
            weakSelf.dataSource = datas;
            [weakSelf.tableView reloadData];
        }
    }];
    
}

- (NSArray *)stringToJSON:(NSString *)jsonStr{
    if (jsonStr) {
        id tmp = [NSJSONSerialization JSONObjectWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        
        if (tmp) {
            if ([tmp isKindOfClass:[NSArray class]]) {
                
                return tmp;
                
            } else if([tmp isKindOfClass:[NSString class]]
                      || [tmp isKindOfClass:[NSDictionary class]]) {
                
                return [NSArray arrayWithObject:tmp];
                
            } else {
                return nil;
            }
        } else {
            return nil;
        }
        
    } else {
        return nil;
    }
}

#pragma mark - getting

//图片广告
- (ImageScroll *)bannerView{
    
    if (!_bannerView) {
        _bannerView = [[ImageScroll alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kFitHeight(350))];
        _bannerView.delegate = self;
        _bannerView.maxCount = 6;
    }
    return _bannerView;
}
#pragma mark - ImageScrollDelegate
/**
 *  广告图片点击事件
 *
 *  @param index 图片坐标位置
 */
- (void)imageScrollDidClick:(NSNumber *)index{
    
    
}

#pragma mark - Table view data source

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
    
    if (![CenterModel isDidMemberLogin]) {
        [[AppDelegate sharedInstance]showLogin];
        return;
    }
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
