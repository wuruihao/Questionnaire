//
//  NSString+RectString.m
//  CollegeGirl
//
//  Created by 林文华 on 2016/12/17.
//  Copyright © 2016年 林文华. All rights reserved.
//

#import "NSString+RectString.h"

@implementation NSString (RectString)


#pragma mark - 清除path文件夹下缓存大小
+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}

+(NSString *)GetThefilePath:(NSString *)filePath{
    NSString *Path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                           NSUserDomainMask, YES)firstObject]stringByAppendingPathComponent:filePath];
    return Path;
}

+ (void)saveData:(id)data withKey:(NSString *)key{
    NSMutableData *mutableData = [[NSMutableData alloc] init] ;
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData] ;
    [archiver encodeObject:data forKey:key];
    [archiver finishEncoding];
    BOOL success = [mutableData writeToFile:[self GetThefilePath:key] atomically:YES];
    if (!success) {
        //kTipAlert(@"本地缓存失败!");
    }
}

+ (instancetype)loadLocalDataWithKey:(NSString *)key{
    NSData * resultdata = [[NSData alloc] initWithContentsOfFile:[self GetThefilePath:key]];
    NSKeyedUnarchiver *unArchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:resultdata];
    return [unArchiver decodeObjectForKey:key];
}


-(BOOL)containsOperationString {
    if ([self containsString:@"+"] || [self containsString:@"-"]) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isInSameWeekDate:(NSDate *)firstDate nextDate:(NSDate *)nextDate {
    NSDateComponents *firstComponents = [self getComonentsWith:firstDate];
    NSDateComponents *nextComponents = [self getComonentsWith:nextDate];
    if (firstComponents.year != nextComponents.year) {
        return NO;
    }else {
        if (firstComponents.weekOfYear != nextComponents.weekOfYear) {
            return NO;
        }else {
            return YES;
        }
    }
}

+ (NSInteger)getAisaWeekdayWith:(NSDate *)date {
    NSDateComponents *components = [self getComonentsWith:date];
    return components.weekday - 1 == 0 ? 7 : components.weekday - 1;
}

+ (NSInteger)getWeekdayWith:(NSDate *)date {
    NSDateComponents *components = [self getComonentsWith:date];
    return components.weekday;
}

+ (NSDateComponents *)getComonentsWith:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay | NSCalendarUnitWeekOfYear | NSCalendarUnitWeekOfMonth | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond  fromDate:date];
    return components;
}

//提取出请求错误内容
+ (NSString *)tipFromError:(NSError *)error{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"NSLocalizedDescription"]) {
            tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        }else{
            [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
        }
        return tipStr;
    }
    return nil;
}

+(NSString *)base64DecodeString:(NSString *)string

{
    
    //1.将base64编码后的字符串『解码』为二进制数据
    
    NSData *data = [[NSData alloc]initWithBase64EncodedString:string options:0];
    
    //2.把二进制数据转换为字符串返回
    
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
}

+(NSString *)base64EncodeString:(NSString *)string

{
    
    //1.先把字符串转换为二进制数据
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //2.对二进制数据进行base64编码，返回编码后的字符串
    
    return [data base64EncodedStringWithOptions:0];
    
}


//方法：获取字符串的尺寸_height
+ (float)getTextSizeHeight:(NSString*)string UIFont:(int)font Width:(float)width
{
    NSMutableParagraphStyle *paragraph= [[NSMutableParagraphStyle alloc]init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attributeDic = @{NSFontAttributeName: [UIFont systemFontOfSize:font], NSParagraphStyleAttributeName: paragraph};
    CGSize mySize =[string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:nil].size;
    float height= mySize.height;
    return height;
}

//方法：获取字符串的尺寸_width
+ (float)getTextSizeWidth:(NSString*)string UIFont:(int)font  Height:(float)height
{
    NSMutableParagraphStyle *paragraph= [[NSMutableParagraphStyle alloc]init];
    paragraph.alignment = NSLineBreakByWordWrapping;
    NSDictionary *attributeDic = @{NSFontAttributeName: [UIFont systemFontOfSize:font], NSParagraphStyleAttributeName: paragraph};
    CGSize mySize =[string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributeDic context:nil].size;
    float width= mySize.width;
    return width;
}


//验证手机号合法性
- (BOOL)isMobilePhone{
    NSString *pattern = @"^1[3-9]\\d{9}$";
    return [self matchesWithPattern:pattern];
}

- (BOOL)matchesWithPattern:(NSString *)pattern{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    NSArray *result = [regular matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return result.count > 0;
}


//判断内容是否全部为空格  yes 全部为空格  no 不是
+ (BOOL) isEmpty:(NSString *) str {

    if (!str) {
        return true;
    } else {
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];

        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];

        if ([trimedString length] == 0) {
            return true;
        } else {
            return false;
        }
    }
}


+(NSString*)dictionaryToJson:(id)dic

{

    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options: NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}


-(id)JSONValue;
{
    NSData* data = [self dataUsingEncoding:NSUTF8StringEncoding];
    __autoreleasing NSError* error = nil;
    id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (error != nil) return nil;
    return result;
}
//去掉换行和空格
+ (NSString *)removeSpaceAndNewline:(NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

+(NSString *)getAgeFromBirthday:(NSString *)string{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *date = [dateFormatter dateFromString:string];
    NSTimeInterval ageInterval = [[NSDate date] timeIntervalSinceDate:date];
    if (ageInterval < 0 || isnan(ageInterval)) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%ld", (NSInteger)ageInterval/(3600 * 24 * 365)];
}



+(NSString *)detailGetAgeFromBirthday:(NSString *)string{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *date = [dateFormatter dateFromString:string];
    NSTimeInterval ageInterval = [[NSDate date] timeIntervalSinceDate:date];
    if (ageInterval < 0 || isnan(ageInterval)) {
        return @"0";
    }
    return [NSString stringWithFormat:@"%ld", (NSInteger)ageInterval/(3600 * 24 * 365)];
}


+(NSString*)getBirthdayWithAge:(NSString*)age{
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute| NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];

    NSInteger birthday = dateComponent.year - [age integerValue];

    return [NSString stringWithFormat:@"%ld-01-01", birthday];
}


+(NSString *)getSexTypeWithSexString:(NSString*)string{

    return [string isEqualToString:@"1"] ? @"男" : [string isEqualToString:@"2"] ? @"女" : @"未知";
}

+(NSString *)getSexEnglishTypeWithSexString:(NSString*)string{

    return [string isEqualToString:@"1"] ? @"MAN" : [string isEqualToString:@"2"] ? @"WOMEN" : @"UNKNOW";
}


+(NSString *)getSexUploadTypeWithSexString:(NSString*)string{

    return [string isEqualToString:@"男"] ? @"1" : [string isEqualToString:@"女"] ? @"2" : @"3";
}

+ (NSString *)getOnlyMonthAndDayStringWithDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)getToDayStringFromDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)creatNewDateToSecondStringWithDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

+(NSString *)getTimeIntervalWithTime:(NSString *)string{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:string];
    NSTimeInterval ageInterval = [[NSDate date] timeIntervalSinceDate:date];
    if (ageInterval < 0 || isnan(ageInterval)) {
        return @"未知时间";
    }
    NSInteger years = (NSInteger)ageInterval/(3600*24*365);
    NSInteger months = (NSInteger)ageInterval/(3600*24*30);
    NSInteger days = (NSInteger)ageInterval/(3600*24);
    NSInteger hours = (NSInteger)ageInterval/3600;
    NSInteger mins = (NSInteger)ageInterval/60;
    NSInteger seconds = (NSInteger)ageInterval;
    NSInteger timeGap = 0;
    NSInteger type = 0;
    NSArray *timeArr = @[@(years),  @(months),  @(days),  @(hours),  @(mins), @(seconds)];
    for (int i = 0; i < timeArr.count; i++) {
        if ([timeArr[i] integerValue] > 0) {
            timeGap = [timeArr[i] integerValue];
            type = i;
            break;
        }
    }
    NSString *typeString = nil;
    switch (type) {
        case 0:
            typeString = @"年前";
            break;
        case 1:
            typeString = @"个月前";
            break;
        case 2:
            typeString = @"天前";
            break;
        case 3:
            typeString = @"小时前";
            break;
        case 4:
            typeString = @"分钟前";
            break;
        case 5:
            typeString = @"现在";
            break;
    }
    if (type == 5) {
        return typeString;
    }
    return [NSString stringWithFormat:@"%ld%@", timeGap, typeString];
}

@end
