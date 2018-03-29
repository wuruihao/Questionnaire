//
//  UIColor+Custom.m
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "UIColor+Custom.h"

@implementation UIColor (Custom)

//UIColor *blueColor = [UIColor colorWithHex:0x0174AC alpha:1];
+ (UIColor *) colorWithHex:(uint) hex alpha:(CGFloat)alpha
{
    int red, green, blue;
    
    blue = hex & 0x0000FF;
    green = ((hex & 0x00FF00) >> 8);
    red = ((hex & 0xFF0000) >> 16);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
