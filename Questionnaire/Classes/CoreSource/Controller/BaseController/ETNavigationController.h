//
//  ETNavigationController.h
//  Bike
//
//  Created by yizheming on 16/3/9.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define kkBackViewHeight [UIScreen mainScreen].bounds.size.height
#define kkBackViewWidth [UIScreen mainScreen].bounds.size.width

#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

// 背景视图起始frame.x
#define startX 0;

@interface ETNavigationController : UINavigationController<UIGestureRecognizerDelegate>{
    CGFloat startBackViewX;
}

// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;
//add by scx  ---  用于区别显示登录界面
@property (nonatomic, assign) NSInteger tag;

@end
