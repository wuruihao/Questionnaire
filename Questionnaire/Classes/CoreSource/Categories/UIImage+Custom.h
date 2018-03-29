//
//  UIImage+Custom.h
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Custom)

/*
 * 按照Rect截取Image里一块生成新的image
 */
- (UIImage *)getSubImage:(CGRect)rect;

/*
 * 获取图片内存大小
 */
- (size_t)imageBytesSize;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)imageCropToSize:(CGSize)targetSize;

- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

+ (UIImage *)imageBundleNamed:(NSString *)filename;

+ (UIImage *)imagePlayBundleName:(NSString *)filename;

//切图
- (UIImage*)crop:(CGRect)rect;

- (UIImage *)imageThemeChangeWithColor:(UIColor *)color;


//合并图层
+(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2 withRect:(CGRect)rect;

//截屏 并 保存到照片库
+ (UIImage *) screenCaptureInView:(UIView *)view;

//test
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect ;

//高斯模糊
+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
