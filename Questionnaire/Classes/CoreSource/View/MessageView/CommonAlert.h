//
//  CommonAlert.h
//  Carcool
//
//  Created by yizheming on 15/11/23.
//  Copyright © 2015年 EnjoyTouch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommonAlert;

@protocol CommonAlertDelegate <NSObject>

@optional

- (void)itemCancel:(CommonAlert *)alert;
- (void)itemCertain:(CommonAlert *)alert;

@end

@interface CommonAlert : UIView

@property (nonatomic,weak) id <CommonAlertDelegate> delegate;

- (id)initWithMessage:(NSString *)message withBtnTitles:(NSArray *)titles;//通用

- (void)hiddenView;
- (void)showInWindow;

@end


