//
//  UIViewController+mainAction.m
//  Bike
//
//  Created by Enjoytouch on 16/4/21.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

@implementation UIViewController (mainAction)

//提示框
- (void)showCertainAlertWithMessage:(NSString *)message{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}


//提示框
- (void)showAlertWithMessage:(NSString *)message{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    [alert show];
    
}

//有确定和取消按钮
- (void)showAlertWithMessage:(NSString *)message tag:(NSInteger)tag{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    alert.tag = tag;
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [textField resignFirstResponder];
            
        }
        [self performCancelActionWithTag:alertView.tag];
        
    }
    
    
    if (buttonIndex == 1) {
        if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput) {
            UITextField *textField = [alertView textFieldAtIndex:0];
            [textField resignFirstResponder];
            if (alertView.tag==666666) {
                //修改昵称
                [self performInputNickNameAlertViewWitnSureAction:textField.text];
                
            }else{
                
                //其他
                [self performInputAlertViewWitnSureAction:textField.text];
            }
            
            
        }else{
            
            [self performSureActionWithTag:alertView.tag];
            
        }
        
    }
    
}

- (void)performCancelActionWithTag:(NSInteger )tag{}
- (void)performSureActionWithTag:(NSInteger )tag{}
- (void)performInputNickNameAlertViewWitnSureAction:(NSString *)text{}
- (void)performInputAlertViewWitnSureAction:(NSString *)text{}
@end
