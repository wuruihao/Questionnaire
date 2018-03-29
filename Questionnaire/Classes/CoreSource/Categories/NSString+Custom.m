//
//  NSString+Custom.m
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "NSString+Custom.h"
#import <CommonCrypto/CommonDigest.h>

#define kFocoValidationIPLassMaxLength 1000
#define KPhoneLength 11
@implementation NSString (Custom)

- (NSString *)stringByDeletingInlegalCharacters
{
    NSMutableString *result = [NSMutableString string];
    for (int i=0; i<[self length]; i++) {
        unichar c = [self characterAtIndex:i];
        if ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9')) {
            [result appendString:[NSString stringWithCharacters:&c length:1]];
        }
    }
    return [NSString stringWithString:result];
}

- (NSUInteger)ASCIILength
{
    NSUInteger count = 0;
    for (int i=0; i<[self length]; i++) {
        unichar c= [self characterAtIndex:i];
        if(c <= 255) {  //the Xcode warning is wrong.
            count++;
        } else {
            count += 2;
        }
    }
    return count;
}

- (BOOL)isEmpty
{
    if (self && ![@"" isEqualToString:self]) {
        return [self length] == 0;
    }
    return YES;
}

- (NSString *)ucfirst {
    
    if (self) {
        if (self.length>1) {
            NSString *first = [self substringToIndex:1];
            NSString *other = [self substringFromIndex:1];
            return [NSString stringWithFormat:@"%@%@", [first uppercaseString], other];
        }
        else {
            return [self uppercaseString];
        }
    }
    return nil;
}

- (CGSize)safelySizeWithFont:(UIFont *)font {
    if (self && self.length > 0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        return [self sizeWithAttributes:attribute];
    }
    return CGSizeMake(0, 0);
}

- (CGSize)safelySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size {
    if (self && self.length > 0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        return [self boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes:attribute
                                  context:nil].size;
    }
    return CGSizeMake(0, 0);
}

- (CGSize)safelySizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size options:(NSStringDrawingOptions)options {
    if (self && self.length > 0) {
        NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        return [self boundingRectWithSize:size
                                  options:options
                               attributes:attribute
                                  context:nil].size;
    }
    return CGSizeMake(0, 0);
}

- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)stringWithBool:(BOOL)boolean {
    return [NSString stringWithFormat:@"%@",[NSNumber numberWithBool:boolean]];
}

+ (NSString *)removeLastOneChar:(NSString*)origin{
    
    NSString* cutted;
    if([origin length] > 0){
        cutted = [origin substringToIndex:([origin length]-1)];// 去掉最后一个","
    }else{
        cutted = origin;
    }
    return cutted;
}


//正则表达式过滤
- (BOOL)isMatchedWithPattern:(NSString*)pattern {
    NSError* error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                           options:0
                                                                             error:&error];
    NSRange range = [regex rangeOfFirstMatchInString:self
                                             options:0
                                               range:NSMakeRange(0, [self length])];
    return (range.location == 0 && range.length == [self length]) ? YES : NO;
}

- (BOOL)isValidNumber{
    static NSString* pattern = @"^[0-9]*$";
    BOOL result = NO;
    result = [self isMatchedWithPattern:pattern];
    return result;
}


- (BOOL)isValidEmail {
    // RF2822準拠(domain-literalは除く)のパターン
    static NSString* pattern = @"^(?:(?:(?:(?:[a-zA-Z0-9_!#\\$\%&'*+/=?\\^`{}~|\\-]+)(?:\\.(?:[a-zA-Z0-9_!#\\$\%&'*+/=?\\^`{}~|\\-]+))*)|(?:\"(?:\\[^\r\n]|[^\\\"])*\")))\\@(?:(?:(?:[a-zA-Z0-9_!#\\$\%&'*+/=?\\^`{}~|\\-]+)(?:\\.(?:[a-zA-Z0-9_!#\\$\%&'*+/=?\\^`{}~|\\-]+))*))$";
    
    BOOL result = NO;
    if([self length] > 0 && [self length] <= kFocoValidationIPLassMaxLength){
        result = [self isMatchedWithPattern:pattern];
    }
    return result;
}

- (BOOL)isValidPhone{
    static NSString* pattern = @"^(1[0-9][0-9])\\d{8}$";
    BOOL result = NO;
    if([self length] == KPhoneLength){
        result = [self isMatchedWithPattern:pattern];
    }
    return result;
}

- (BOOL)isValidRecommend{
    
    static NSString* pattern = @"^([a-zA-Z0-9_]){6}$";
    BOOL result = NO;
    if([self length] == KPhoneLength){
        result = [self isMatchedWithPattern:pattern];
    }
    return result;
}


- (BOOL)isValidPassword {
    static NSString* pattern = @"[a-zA-Z0-9~!#\\$^&*+;:?/|{}\\.=_,-~@%()]{6,15}";
    
    BOOL result = NO;
    if([self length] > 0 && [self length] <= kFocoValidationIPLassMaxLength){
        result = [self isMatchedWithPattern:pattern];
    }
    return result;
}

- (BOOL)isValidCode
{
    BOOL result = NO;
    
    if (self.length == 6)
    {
        result = YES;
    }
    
    return result;
}
- (NSString *)filterChar{
    
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"</p>"];
    NSString *tempString = [[self componentsSeparatedByCharactersInSet: set]componentsJoinedByString: @""];
    return tempString;
}
//普通字符串转换为十六进制的。
+ (NSString *)hexStringFromString:(NSString *)string{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}

- (BOOL)isChinesecharacter{
    if (self.length == 0) {
        return NO;
    }
    unichar c = [self characterAtIndex:0];
    if (c >=0x4E00 && c <=0x9FA5){
        return YES;
        //汉字
    }else{
        return NO;
        //英文
    }
}
//计算汉字的个数
- (NSInteger)chineseCountOfString{
    int ChineseCount = 0;
    if (self.length == 0){
        return 0;
    }
    for (int i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5){
            ChineseCount++ ;
            //汉字
        }
    }    return ChineseCount;
}
//计算字母的个数
- (NSInteger)characterCountOfString{
    int characterCount = 0;
    if (self.length == 0) {
        return 0;
    }
    for (int i = 0; i<self.length; i++) {
        unichar c = [self characterAtIndex:i];
        if (c >=0x4E00 && c <=0x9FA5){
            
        }else{
            characterCount++;
            //英文
        }
    }    return characterCount;
}



@end
