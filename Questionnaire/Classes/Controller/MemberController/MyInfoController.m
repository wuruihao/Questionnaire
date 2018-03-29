//
//  MyInfoController.m
//  038Lottery
//
//  Created by ruihao on 2017/7/13.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "MyInfoController.h"

@interface MyInfoController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoEditDelegate,AlertTextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *snapImage;
@property (weak, nonatomic) IBOutlet UILabel *snapLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexType;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageNum;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@property (nonatomic, copy) NSArray  *uploadImgs;

@property (nonatomic, strong) AlertTextView *alertTextView;

@end

@implementation MyInfoController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.snapLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.nickName.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.nickLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.sexType.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.sexLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.ageNum.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.ageLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    
    self.snapImage.layer.masksToBounds = YES;
    self.snapImage.layer.cornerRadius = 5.0;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[ETMessageView sharedInstance] hideMessage];
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
}

- (void)initData{
    
    //头像
    AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
    if (![ETRegularUtil isEmptyString:file.url]) {
        [self.snapImage sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageBundleNamed:@"member_default.png"]];
    }else{
        self.snapImage.image = [UIImage imageBundleNamed:@"member_default.png"];
    }
    
    //用户名
    NSString *name = [[AVUser currentUser] objectForKey:@"name"];
    if (![ETRegularUtil isEmptyString:name]) {
        self.nickName.text = name;
    }else{
        self.nickName.text = @"未填写";
    }
    
    //性别
    NSString *sex = [[AVUser currentUser] objectForKey:@"sex"];
    if (![ETRegularUtil isEmptyString:sex]) {
        if ([sex isEqualToString:@"0"]) {
            self.sexType.text = @"女";
        }else{
            self.sexType.text = @"男";
        }
    }else{
        self.sexType.text = @"未填写";
    }
    
    //年龄
    NSNumber *age = [[AVUser currentUser] objectForKey:@"age"];
    if (age) {
        self.ageNum.text = [NSString stringWithFormat:@"%d",[age intValue]];
    }else{
        self.ageNum.text = @"未填写";
    }
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)selectMineInformation:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{
            
            [self alertAction];
        }
            break;
        case 1:{
            //昵称
            ChangeNameController *nickName = [[ChangeNameController alloc]init];
            [self.navigationController pushViewController:nickName animated:YES];
            
        }
            break;
        case 2:{
            [self sexAlertAction];
            
        }
            break;
        case 3:{
            [self ageAlertAction];
            
        }
            break;
            
        default:
            break;
    }
}

- (AlertTextView *)alertTextView{

    if (!_alertTextView) {
        _alertTextView = [[AlertTextView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.75, kScreenHeight*0.3)];
        _alertTextView.delegate = self;
    }
    return _alertTextView;
}

- (void)ageAlertAction{

    [UIView pushCustomView:self.alertTextView animation:YES openTap:NO completion:nil];
}

- (void)sureAction{
    
    [self fillAgeData:self.alertTextView.textInput.text];
}

- (void)cancelAction{
 
    [UIView dismissCustomViewWithAnimated:YES completion:nil];
}

- (void)fillAgeData:(NSString *)age{
    
    kWeakSelf;
    [[ETMessageView sharedInstance] showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];
    int ageNum = [age intValue];
    [[AVUser currentUser] setObject:[NSNumber numberWithInt:ageNum] forKey:@"age"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (succeeded) {
            //年龄
            NSNumber *age = [[AVUser currentUser] objectForKey:@"age"];
            if (age) {
                weakSelf.ageNum.text = [NSString stringWithFormat:@"%d",[age intValue]];
            }else{
                weakSelf.ageNum.text = @"未填写";
            }
        }else{
            [[ETMessageView sharedInstance] showMessage:@"请求失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
        [UIView dismissCustomViewWithAnimated:YES completion:nil];
    }];
}

- (void)sexAlertAction{
    
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"男"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 [self fillSexData:@"1"];
                             }];
    UIAlertAction* action1 = [UIAlertAction
                              actionWithTitle:@"女" style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {
                                  [self fillSexData:@"0"];
                              }];
    UIAlertAction* action2 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * _Nonnull action) {
                                  
                              }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert
                       animated:YES completion:nil];
}

- (void)fillSexData:(NSString *)sex{

    kWeakSelf;
    [[ETMessageView sharedInstance] showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];
    
    [[AVUser currentUser] setObject:sex forKey:@"sex"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (succeeded) {
            //性别
            NSString *sex = [[AVUser currentUser] objectForKey:@"sex"];
            if (![ETRegularUtil isEmptyString:sex]) {
                if ([sex isEqualToString:@"0"]) {
                    weakSelf.sexType.text = @"女";
                }else{
                    weakSelf.sexType.text = @"男";
                }
            }else{
                weakSelf.sexType.text = @"未填写";
            }
        }else{
            [[ETMessageView sharedInstance] showMessage:@"请求失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }];
}

#pragma mark - *************PhotoEditDelegate*****************

- (void)completedSelectImage:(NSArray *)images{
    
    _uploadImgs = @[images];
    
    //拿到图片
    UIImage *image = [images firstObject];
    //    NSString *suffix = [images lastObject];
    //    NSString *documentsPath = [NSString stringWithFormat:@"/Documents/snap.%@",suffix];
    //    NSString *path_sandox = NSHomeDirectory();
    //    //设置一个图片的存储路径
    //    NSString *imagePath = [path_sandox stringByAppendingString:documentsPath];
    //    //把图片直接保存到指定的路径（同时应该把图片的路径imagePath存起来，下次就可以直接用来取）
    //    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    
    kWeakSelf;
    [[ETMessageView sharedInstance] showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];
    
    self.view.userInteractionEnabled = NO;
    if (image) {
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        AVFile *file = [AVFile fileWithData:imageData];
        [[AVUser currentUser] setObject:file forKey:@"avatar"];
        [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            weakSelf.view.userInteractionEnabled = YES;
            [[ETMessageView sharedInstance] hideMessage];
            if (succeeded) {
                [[ETMessageView sharedInstance] showMessage:@"上传成功" onView:self.view Type:MESSAGE_ALERT_DELAY];
                //头像
                AVFile *file = [[AVUser currentUser] objectForKey:@"avatar"];
                if (![ETRegularUtil isEmptyString:file.url]) {
                    [weakSelf.snapImage sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageBundleNamed:@"member_default.png"]];
                }else{
                    weakSelf.snapImage.image = [UIImage imageBundleNamed:@"member_default.png"];
                }
            }else{
                [[ETMessageView sharedInstance] showMessage:@"上传失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
            }
        }];
    }
}

- (void)alertAction{
    
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //UIAlertControllerStyleActionSheet:显示在屏幕底部
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"拍照"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 [self openCameraAction];
                             }];
    UIAlertAction* action1 = [UIAlertAction
                              actionWithTitle:@"相册" style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * _Nonnull action) {
                                  /* 相册 */
                                  OnePhotoController *issueVC = [OnePhotoController new];
                                  ETNavigationController *mlNavigationController = [[ETNavigationController alloc]initWithRootViewController:issueVC];
                                  issueVC.delegate = self;
                                  [self.navigationController presentViewController:mlNavigationController animated:YES completion:nil];
                              }];
    UIAlertAction* action2 = [UIAlertAction
                              actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * _Nonnull action) {
                                  
                              }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert
                       animated:YES completion:nil];
    
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //
    //    });
    //
    
}

#pragma mrak - openCameraAction
- (void)openCameraAction{
    //是否获得权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限
        UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:@"无法访问相机.请在'设置->隐私->相机'设置为打开状态." preferredStyle:UIAlertControllerStyleAlert];
        //UIAlertControllerStyleActionSheet:显示在屏幕底部
        //设置按钮
        UIAlertAction *action = [UIAlertAction
                                 actionWithTitle:@"设置"
                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                     NSURL *setUrl = [NSURL URLWithString:@"prefs:root=Privacy"];
                                     [[UIApplication sharedApplication] openURL:setUrl];
                                 }];
        UIAlertAction* action1 = [UIAlertAction
                                  actionWithTitle:@"稍后再说" style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * _Nonnull action) {
                                      
                                      [self dismissViewControllerAnimated:YES completion:nil];
                                  }];
        [alert addAction:action];
        [alert addAction:action1];
        [self presentViewController:alert
                           animated:YES completion:nil];
        return;
    }
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断当前设备是否有照相功能
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //判断如果没有相机就调用图片库
        UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:@"设备不支持照相功能." preferredStyle:UIAlertControllerStyleAlert];
        //UIAlertControllerStyleActionSheet:显示在屏幕底部
        //设置按钮
        UIAlertAction *action = [UIAlertAction
                                 actionWithTitle:@"知道了"
                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 }];
        [alert addAction:action];
        [self presentViewController:alert
                           animated:YES completion:nil];
        return;
    }
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = sourceType;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    UIImage *upImg = [image fixOrientation];
    
    PhotoEditViewController *editVC = [PhotoEditViewController new];
    editVC.delegate = self;
    editVC.upImgs = @[upImg,@"jpeg"];
    ETNavigationController *mlNavigationController = [[ETNavigationController alloc]initWithRootViewController:editVC];
    editVC.delegate = self;
    
    [picker dismissViewControllerAnimated:NO completion:^{
        [self.navigationController presentViewController:mlNavigationController animated:YES completion:nil];
    }];
}

@end
