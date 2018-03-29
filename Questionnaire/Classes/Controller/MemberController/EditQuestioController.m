//
//  EditQuestioController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/18.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "EditQuestioController.h"

@interface EditQuestioController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,PhotoEditDelegate,BFDatePickerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTextFied;
@property (weak, nonatomic) IBOutlet UIButton *selecteDate;
@property (weak, nonatomic) IBOutlet UIButton *iconButton;

@property (strong, nonatomic) BFDatePicker  *datePickerView;
@property (strong, nonatomic) HomeData *homeData;
@property (strong, nonatomic) NSArray *uploadImgs;
@property (strong, nonatomic) UIImage *iocnImage;

@end

@implementation EditQuestioController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.iconButton addLineWithCorner:5];
    [self.selecteDate addLineWithCorner:5];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self.inputTextFied resignFirstResponder];
}

- (IBAction)backAction:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"退出编辑" message:@"您确定要放弃新建的内容吗 ?" preferredStyle:UIAlertControllerStyleAlert];
    //设置按钮
    UIAlertAction *action = [UIAlertAction
                             actionWithTitle:@"确定"
                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)nextQuestionnaire:(UIButton *)sender{
    
    if ([ETRegularUtil isEmptyString:self.inputTextFied.text] || !self.iocnImage || [self.selecteDate.titleLabel.text isEqualToString:@"选取时间"]) {
          [[ETMessageView sharedInstance]showMessage:@"请完善内容" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    self.homeData = [[HomeData alloc]init];
    self.homeData.time = self.selecteDate.titleLabel.text;
    self.homeData.title = self.inputTextFied.text;
    self.homeData.iocnImage = self.iocnImage;
    self.homeData.questionType = @"8";
    EditAnswerController *vc = [[EditAnswerController alloc]init];
    vc.homeData = self.homeData;
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickImage:(UIButton *)sender {
    
    [self.inputTextFied resignFirstResponder];
    [self alertAction];
}
- (IBAction)clickDate:(UIButton *)sender {
    
    [self.inputTextFied resignFirstResponder];
    [UIView popBottomView:self.datePickerView animation:YES];
}

#pragma mark - BFDatePickerDelegate

- (BFDatePicker *)datePickerView{
    
    if (_datePickerView == nil) {
        _datePickerView = [[BFDatePicker alloc]init];
        _datePickerView.delegate = self;
        [_datePickerView setDateMode:UIDatePickerModeDate];
    }
    return _datePickerView;
}

//取消时间的回调
- (void)pickerViewCancelAction:(BFDatePicker *)view{
    
}

//点击时间的回调
- (void)pickerViewWilldismiss:(BFDatePicker *)view targetDate:(NSString *)selectDateString{
    
    [self.selecteDate setTitle:[self mapToYmdTime:selectDateString] forState:UIControlStateNormal];
    [self.selecteDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (NSString *)mapToYmdTime:(NSString *)ymdHms{
    
    NSArray *ymd = [ymdHms componentsSeparatedByString:@" "];
    
    return ymd[0];
}

#pragma mark - UITextFieldDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//对应第三方键盘收键盘方法
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
    }
    
    NSString *str = nil;
    if (range.length == 0) {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }else{
        str = [textField.text substringToIndex:range.location];
    }
    if ([str length] >= 20) {
        textField.text = [str length] == 20 ? str:textField.text;
        return NO;
    }
    return YES;
}

#pragma mark - PhotoEditDelegate

- (void)alertAction{
    
    UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
}

#pragma mrak - openCameraAction
- (void)openCameraAction{
    //是否获得权限
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied){
        //无权限
        UIAlertController*alert = [UIAlertController alertControllerWithTitle:nil message:@"无法访问相机.请在'设置->隐私->相机'设置为打开状态." preferredStyle:UIAlertControllerStyleAlert];
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

- (void)completedSelectImage:(NSArray *)images{
    
    _uploadImgs = @[images];
    
    //拿到图片
    UIImage *image = [images firstObject];
    self.iocnImage = image;
    [self.iconButton setImage:image forState:UIControlStateNormal];
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
