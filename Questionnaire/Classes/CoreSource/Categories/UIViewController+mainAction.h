//
//  UIViewController+mainAction.h
//  Bike
//
//  Created by Enjoytouch on 16/4/21.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewController (mainAction)<UIAlertViewDelegate>

//确定提示框
- (void)showCertainAlertWithMessage:(NSString *)message;
//取消提示框
- (void)showAlertWithMessage:(NSString *)message;
//有确定和取消按钮
- (void)showAlertWithMessage:(NSString *)message tag:(NSInteger)tag;

//确定&&取消回调方法
- (void)performCancelActionWithTag:(NSInteger )tag;
- (void)performSureActionWithTag:(NSInteger )tag;
- (void)performInputNickNameAlertViewWitnSureAction:(NSString *)text;
- (void)performInputAlertViewWitnSureAction:(NSString *)text;
@end



