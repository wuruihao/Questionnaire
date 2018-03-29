//
//  MoreController.m
//  038Lottery
//
//  Created by ruihao on 2017/7/11.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "MoreController.h"

@interface MoreController ()

@property (weak, nonatomic) IBOutlet UILabel *cleanLabel;
@property (weak, nonatomic) IBOutlet UILabel *weLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@end

@implementation MoreController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.weLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    self.cleanLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
    
    [self.logoutButton addLineWithCorner:10];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)moreOptionsAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 0:{//清楚缓存
            UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"清楚缓存" message:@"您确定要清楚缓存 ?" preferredStyle:UIAlertControllerStyleAlert];
            //UIAlertControllerStyleActionSheet:显示在屏幕底部
            //设置按钮
            UIAlertAction *action = [UIAlertAction
                                     actionWithTitle:@"确定"
                                     style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                         
                                         [[ETMessageView sharedInstance] showMessage:@"清楚缓存成功" onView:self.view Type:MESSAGE_ALERT_DELAY];
                                     }];
            UIAlertAction* action1 = [UIAlertAction
                                      actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction * _Nonnull action) {
                                          
                                          [self dismissViewControllerAnimated:YES completion:nil];
                                      }];
            [alert addAction:action];
            [alert addAction:action1];
            [self presentViewController:alert
                               animated:YES completion:nil];
        }
            break;
        case 1:{//关于我们
            AboutUsController *aboutUsVC = [[AboutUsController alloc]init];
            [self.navigationController pushViewController:aboutUsVC animated:YES];
        }
            break;
        case 2:{
            
        }
            break;
        case 3:{
                        UIAlertController*alert = [UIAlertController alertControllerWithTitle:@"退出账号" message:@"您确定要退出此账号?" preferredStyle:UIAlertControllerStyleAlert];
                        //UIAlertControllerStyleActionSheet:显示在屏幕底部
                        //设置按钮
                        UIAlertAction *action = [UIAlertAction
                                                 actionWithTitle:@"确定"
                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
                                                     [self loginOut];
                                                 }];
                        UIAlertAction* action1 = [UIAlertAction
                                                  actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * _Nonnull action) {
            
                                                      [self dismissViewControllerAnimated:YES completion:nil];
                                                  }];
                        [alert addAction:action];
                        [alert addAction:action1];
                        [self presentViewController:alert
                                           animated:YES completion:nil];
        }
                        break;
        default:
            break;
    }
}

- (void)loginOut{
    
    [[ETMessageView sharedInstance] hideMessage];
    [CenterModel memberLogout];
    [[[AppDelegate sharedInstance] tabBarController] selectedControllerWithIndex:0];
}

@end
