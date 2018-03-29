//
//  IssueController.m
//  JiBu
//
//  Created by yizheming on 16/4/11.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

@interface OnePhotoController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *naviTitleItem;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *allGroups;
@property (nonatomic, strong) ALAssetsLibrary*library ;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *naviHeight;

@property (nonatomic, assign) BOOL firstIn;
@end

@implementation OnePhotoController

- (instancetype)init{
    self = [super init];
    if (self) {
        _firstIn = YES;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.naviHeight.constant = XNaviHeight;
    
    [self setCollectionViewFlowLayout];

    @weakify(self);
    [ETPhotoUtil getImagesFromALAssetsLibraryCompletion:^{
        //设置collectionView
        weak_self.allGroups = [[ETPhotoUtil sharedInstance] allPhotos];
        dispatch_async(dispatch_get_main_queue(), ^{
            weak_self.naviTitleItem.text = [[ETPhotoUtil sharedInstance] cameraRoll];
            [weak_self.collectionView reloadData];
            if ([weak_self.allGroups count] == 0) {
                [self isAuthorizationStatus];
            }
        });
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
//    if (self.allGroups.count>0&&_firstIn) {
//        NSIndexPath *indexPath= [NSIndexPath indexPathForRow:(self.allGroups.count -1) inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
//        _firstIn = NO;
//    }
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Main Method
- (NSMutableArray *)allGroups{
    if (_allGroups == nil) {
        _allGroups = [NSMutableArray array];
    }
    return _allGroups;
}

- (void)setCollectionViewFlowLayout{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((kScreenWidth -30)*.25,(kScreenWidth -30)*.25);
    layout.minimumLineSpacing = 6;
    layout.minimumInteritemSpacing = 6;
    layout.sectionInset = UIEdgeInsetsMake(10, 6, 10, 6);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[PhotoSampleItem class] forCellWithReuseIdentifier:@"collectionView"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(44 , 0, 0, 0);
    [self.view insertSubview:self.collectionView atIndex:0];
}

- (IBAction)cancelAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.allGroups.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotoSampleItem *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        ALAsset *alaset = [self.allGroups objectSafetyAtIndex:indexPath.row];
        //获取到媒体的类型
        NSString *type = [alaset valueForProperty:ALAssetPropertyType];
        UIImage *image = nil;
        
        if ([self currentDeviceIsIpad]){
            //获取到相片、视频的缩略图
            ALAssetRepresentation *representation = [alaset defaultRepresentation];
            image = [UIImage imageWithCGImage:representation.fullResolutionImage scale:representation.scale orientation:(UIImageOrientation)representation.orientation];
        }else{
            //获取到相片、视频的缩略图
            CGImageRef cgImage = [alaset aspectRatioThumbnail];
            image = [UIImage imageWithCGImage:cgImage];
        }
        
        //媒体类型是相片
        if ([type isEqualToString:ALAssetTypePhoto]){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.imageView.image=image;
            });
        }
    });
    
    return cell;

}

- (BOOL)currentDeviceIsIpad{
    NSString* strDevice = [[UIDevice currentDevice].model substringToIndex:4];
    if ([strDevice isEqualToString:@"iPad"]) {
        return YES;
    } else {
        return NO;
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ALAsset *alasset = nil;
    alasset = [self.allGroups objectSafetyAtIndex:indexPath.row];
    NSArray *item= [UIImage getHeadMetaFromAlasset:alasset];
    
    if(self.delegate){
        PhotoEditViewController *editVC = [PhotoEditViewController new];
        editVC.delegate = self.delegate;
        editVC.upImgs = item;
        editVC.isScale = self.isScale;
        [self.navigationController pushViewController:editVC animated:YES];
    }
    if(self.bdelegate){
        BackEditViewController *editVC = [BackEditViewController new];
        editVC.delegate = self.bdelegate;
        editVC.upImgs = item;
        editVC.isScale = self.isScale;
        [self.navigationController pushViewController:editVC animated:YES];
    }
}

#pragma  mark - **********ALAssetsGroup DataSource*************
- (void)isAuthorizationStatus{
    // 获取当前应用对照片的访问授权状态
    ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
    // 如果没有获取访问授权，或者访问授权状态已经被明确禁止，则显示提示语，引导用户开启授权
    if (authorizationStatus == ALAuthorizationStatusRestricted || authorizationStatus == ALAuthorizationStatusDenied) {
        // 展示提示语
        NSDictionary *mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
        CommonAlert * alertView  = [[CommonAlert alloc]initWithMessage:[NSString stringWithFormat:@"请在设备的\"设置-隐私-相机\"选项中，允许%@访问你的手机相机", appName] withBtnTitles:@[@"知道了"]];
        [[UIApplication sharedApplication].keyWindow addSubview:alertView];
    }
}


@end
