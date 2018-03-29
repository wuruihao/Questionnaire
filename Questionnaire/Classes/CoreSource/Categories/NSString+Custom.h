//
//  NSString+Custom.h
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

- (NSString *)stringByDeletingInlegalCharacters;
- (NSUInteger)ASCIILength;
- (BOOL)isEmpty;

- (CGSize)safelySizeWithFont:(UIFont *)font;
- (CGSize)safelySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
- (CGSize)safelySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size options:(NSStringDrawingOptions )options;

- (NSString *)ucfirst;
- (NSString *) md5;

+ (NSString *)stringWithBool:(BOOL)boolean;
//去除最后一个字符
+ (NSString *)removeLastOneChar:(NSString*)origin;

//正则表达式过滤
- (BOOL)isValidNumber;

- (BOOL)isValidEmail;

- (BOOL)isValidPhone;

- (BOOL)isValidPassword;

- (BOOL)isValidRecommend;

- (BOOL)isValidCode;

- (NSString *)filterChar;

+ (NSString *)hexStringFromString:(NSString *)string;

//计算字母的个数
- (NSInteger)characterCountOfString;

//计算汉字的个数
- (NSInteger)chineseCountOfString;

- (BOOL)isChinesecharacter;

@end
