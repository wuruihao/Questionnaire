//
//  UIButton+Custom.m
//  HongFigure
//
//  Created by Robert on 2017/8/15.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "UIButton+Custom.h"

@implementation UIButton (Custom)

+ (UIButton *)buttonWithFrame:(CGRect)frame title:(NSString *)title iconName:(NSString *)name target:(id)target action:(SEL)action tag:(NSInteger)tag{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageBundleNamed:name] forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}


@end
