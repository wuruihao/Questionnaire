//
//  UILabel+Custom.m
//  HongFigure
//
//  Created by Robert on 2017/8/15.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "UILabel+Custom.h"

@implementation UILabel (Custom)

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font{

    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    label.text = text;
    label.textColor = textColor;
    label.font = font;
    
    return label;
}

@end
