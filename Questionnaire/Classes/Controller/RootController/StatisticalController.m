//
//  StatisticalController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "StatisticalController.h"

@interface StatisticalController () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation StatisticalController

static NSString *cellId = @"statisticalCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initCollectionView];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self updateDate];
}

- (void)updateDate{
    
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ALERT_DELAY];
    
    NSMutableArray *categoryArray = [NSMutableArray array];
    AVQuery *query = [AVQuery queryWithClassName:@"RH_Category"];
    [query whereKey:@"categoryId" equalTo:BidID];
    kWeakSelf;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (error) {
//            NSLog(@"%@",[CenterModel showErrorMessage:error]);
        }else{
            for (AVObject *obj in objects) {
                StatisticalData *data = [[StatisticalData alloc]init];
                data.type = [obj objectForKey:@"type"];
                data.total = [obj objectForKey:@"total"];
                data.title = [obj objectForKey:@"categoryTitle"];
                AVFile *image = [obj objectForKey:@"categoryImage"];
                if (![ETRegularUtil isEmptyString:image.url]) {
                    data.picImage = image.url;
                }
                [categoryArray addObject:data];
            }
        }
        weakSelf.dataSource = categoryArray;
        [weakSelf.collectionView reloadData];
    }];

}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)initCollectionView{
    
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"StatisticalCell" bundle:nil]  forCellWithReuseIdentifier:cellId];
}

- (UICollectionView *)collectionView{

    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth*0.5-kFitWidth(22),kScreenWidth*0.5-kFitWidth(22));
        layout.minimumLineSpacing = kFitWidth(14);
        layout.minimumInteritemSpacing = kFitWidth(14);
        layout.sectionInset = UIEdgeInsetsMake(kFitWidth(14), kFitWidth(14), kFitWidth(14), kFitWidth(14));
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-49) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDelegate

- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    StatisticalCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.data = self.dataSource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    StatisticalData *data = self.dataSource[indexPath.row];
    QuestionnaireController *vc = [[QuestionnaireController alloc]init];
    vc.data = data;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
