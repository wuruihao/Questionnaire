//
//  RegisterController.m
//  038Lottery
//
//  Created by ruihao on 2017/7/10.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController () <AgreeDealViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *passwords;
@property (weak, nonatomic) IBOutlet UITextField *nickName;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *optionButton;
@property (weak, nonatomic) IBOutlet UIButton *agreementButton;

@property (strong, nonatomic) AgreeDealView *agreeDealView;

@end

@implementation RegisterController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.registerButton addLineWithCorner:10];
    
    self.phoneNum.font = [UIFont fontWithName:TextFont size:kSize(16)];
    self.passwords.font = [UIFont fontWithName:TextFont size:kSize(16)];
    self.nickName.font = [UIFont fontWithName:TextFont size:kSize(16)];
    self.agreementButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(16)];
    self.registerButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(18)];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [self.phoneNum becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
      [[ETMessageView sharedInstance] hideMessage];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    [self.phoneNum resignFirstResponder];
    [self.passwords resignFirstResponder];
    [self.nickName resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectedOption:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.agreementButton.selected = sender.selected;
}
- (IBAction)seeAgreeDeal:(UIButton *)sender {
    
    [self.passwords resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [self.nickName resignFirstResponder];
    [UIView pushCustomView:self.agreeDealView animation:YES openTap:YES completion:nil];
}

- (IBAction)registerAction:(UIButton *)sender {
    
    if ([ETRegularUtil isEmptyString:self.phoneNum.text]) {
        [[ETMessageView sharedInstance]showMessage:@"请输入用户名" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if ([ETRegularUtil isEmptyString:self.passwords.text]) {
        [[ETMessageView sharedInstance]showMessage:@"请输入密码" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if (self.passwords.text.length < 6) {
        [[ETMessageView sharedInstance]showMessage:@"请设置6-20位密码" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if ([ETRegularUtil isEmptyString:self.nickName.text]) {
        [[ETMessageView sharedInstance]showMessage:@"请再次输入密码" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if (![self.nickName.text isEqualToString:self.passwords.text]) {
        [[ETMessageView sharedInstance]showMessage:@"两次密码不一致" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if (!self.optionButton.selected) {
        [[ETMessageView sharedInstance]showMessage:@"请查看并同意注册协议" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    [self.passwords resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [self.nickName resignFirstResponder];
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Register onView:self.view Type:MESSAGE_ANIMATION];
    [self registerUser];
}

- (void)registerUser{
    
    kWeakSelf;
    NSString *username = self.phoneNum.text;
    NSString *password = self.passwords.text;
    if (username && password) {
        AVUser *user = [AVUser user];
        user.username = username;
        user.password = password;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            [[ETMessageView sharedInstance]hideMessage];
            if (succeeded) {
                [[ETMessageView sharedInstance]showMessage:MESSAGE_Register_Successful onView:weakSelf.view Type:MESSAGE_ALERT_DELAY];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }else{
                [[ETMessageView sharedInstance]showMessage:[CenterModel showErrorMessage:error] onView:weakSelf.view Type:MESSAGE_ALERT_DELAY];
            }
        }];
    }
}

#pragma mark - getting

- (AgreeDealView *)agreeDealView{
    
    if (!_agreeDealView) {
        _agreeDealView = [[AgreeDealView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth*0.8, kScreenHeight*0.75)];
        _agreeDealView.delegate = self;
    }
    return _agreeDealView;
}

- (void)backRegisterView{
 
    [UIView dismissCustomViewWithAnimated:YES completion:nil];
}

#pragma mark - ***************UITextFieldDelegate******************
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

//Add by Yizheming (对应第三方键盘收键盘方法)
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    return YES;
}

- (void)registerTextFieldDidChange{
    
    if (self.passwords.text.length > 20) {
        self.passwords.text = [self.passwords.text substringToIndex:20];
        [self.nickName becomeFirstResponder];
    }
    if (self.nickName.text.length > 20) {
        self.nickName.text = [self.nickName.text substringToIndex:20];
    }
}

@end
