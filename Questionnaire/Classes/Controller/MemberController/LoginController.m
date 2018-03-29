//
//  LoginController.m
//  038Lottery
//
//  Created by ruihao on 2017/7/10.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "LoginController.h"

@interface LoginController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.loginButton addLineWithCorner:10];
    self.phoneNum.font  = [UIFont fontWithName:TextFont size:kSize(16)];
    self.password.font = [UIFont fontWithName:TextFont size:kSize(16)];
    self.loginButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(18)];
    self.forgetButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
}
- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    [self.phoneNum becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    
    [[ETMessageView sharedInstance] hideMessage];
    
    [self.phoneNum resignFirstResponder];
    [self.password resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)registerUserAction:(UIButton *)sender {
    
    RegisterController *registerVC = [[RegisterController alloc]init];
    
    [self.navigationController pushViewController:registerVC animated:YES];
}
- (IBAction)loginAction:(UIButton *)sender {
    
    if ([ETRegularUtil isEmptyString:self.phoneNum.text]) {
        [[ETMessageView sharedInstance]showMessage:@"请输入用户名" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if ([ETRegularUtil isEmptyString:self.password.text]) {
        [[ETMessageView sharedInstance]showMessage:@"请输入密码" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    
    [self.password resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Login onView:self.view Type:MESSAGE_ANIMATION];
    
    [self loginUser];
}

- (void)loginUser{
    
    kWeakSelf;
    NSString *username = self.phoneNum.text;
    NSString *password = self.password.text;
    if (username && password) {
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            [[ETMessageView sharedInstance]hideMessage];
            if (error) {
                [[ETMessageView sharedInstance]showMessage:[CenterModel showErrorMessage:error] onView:weakSelf.view Type:MESSAGE_ALERT_DELAY];
            }else {
                
                [[ETMessageView sharedInstance]showMessage:MESSAGE_Login_Successful onView:weakSelf.view Type:MESSAGE_ALERT_DELAY];
                
                //快速创建
                [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLogin"];
                //必须
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [[ETMessageView sharedInstance]hideMessage];
                    ETNavigationController* navi = (ETNavigationController *)weakSelf.navigationController;
                    if (navi.tag == 1001) {
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                        [[[AppDelegate sharedInstance]tabBarController] selectedControllerWithIndex:2];
                    }else{
                        [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    }
                });
            }
        }];
    }
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

- (void)loginTextFieldDidChange{

    if (self.password.text.length > 20) {
        self.password.text = [self.password.text substringToIndex:20];
    }
}

@end
