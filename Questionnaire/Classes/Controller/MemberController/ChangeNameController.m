//
//  ChangeNameController.m
//  038Lottery
//
//  Created by ruihao on 2017/7/14.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "ChangeNameController.h"

@interface ChangeNameController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation ChangeNameController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.nameTextField.font = [UIFont fontWithName:TextFont size:kSize(16)];    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.nameTextField becomeFirstResponder];
    
    //用户名
    NSString *name = [[AVUser currentUser] objectForKey:@"name"];
    if (![ETRegularUtil isEmptyString:name]) {
        self.nameTextField.text = name;
    }else{
        self.nameTextField.text = @"未填写";
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[ETMessageView sharedInstance] hideMessage];
    [self.nameTextField resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)completeAction:(UIButton *)sender {
    
    NSString *name = [[AVUser currentUser] objectForKey:@"name"];
    if ([self.nameTextField.text isEqualToString:name]) {
        [[ETMessageView sharedInstance] showMessage:@"请修改昵称" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    if ([ETRegularUtil isEmptyString:self.nameTextField.text]) {
        [[ETMessageView sharedInstance] showMessage:@"修改信息不能为空" onView:self.view Type:MESSAGE_ALERT_DELAY];
        return;
    }
    [self updateUserInfo];
}

#pragma mark - NetworkManagerDelegate

- (void)updateUserInfo{
    
    [[ETMessageView sharedInstance] showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];
    
    [[AVUser currentUser] setObject:self.nameTextField.text forKey:@"name"];
    [[AVUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (succeeded) {
                [[ETMessageView sharedInstance] showMessage:@"修改成功" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }else{
            [[ETMessageView sharedInstance] showMessage:@"请求失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
    
}

#pragma mark - ***************UITextFieldDelegate******************
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

//Add by Yizheming (对应第三方键盘收键盘方法)
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
    if ([str length] >= 15) {
        
        textField.text = [str length] == 15 ? str:textField.text;
        return NO;
    }
    return YES;
}

@end
