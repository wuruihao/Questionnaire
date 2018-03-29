//
//  UIButton+Custom.h
//  HongFigure
//
//  Created by Robert on 2017/8/15.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Custom)


+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title iconName:(NSString *)name target:(id)target action:(SEL)action tag:(NSInteger)tag;

@end
