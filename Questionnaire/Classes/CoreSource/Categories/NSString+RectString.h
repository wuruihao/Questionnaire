//
//  NSString+RectString.h
//  CollegeGirl
//
//  Created by 林文华 on 2016/12/17.
//  Copyright © 2016年 林文华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (RectString)
+ (float)getTextSizeHeight:(NSString*)string UIFont:(int)font Width:(float)width;
+ (float)getTextSizeWidth:(NSString*)string UIFont:(int)font  Height:(float)height;


/** 转base64码 */
+(NSString *)base64EncodeString:(NSString *)string;
/** base64解码 */
+(NSString *)base64DecodeString:(NSString *)string;
/** 是否包含运算符 */
- (BOOL)containsOperationString;
/** 验证手机号合法性 */
- (BOOL)isMobilePhone;
/** 提取数请求报错内容 */
+ (NSString *)tipFromError:(NSError *)error;

/** 判断内容是否全部为空格  yes 全部为空格  no 不是 */
+ (BOOL) isEmpty:(NSString *) str;

/** json对象转字符串 */
+(NSString*)dictionaryToJson:(id)dic;
/** 字符串转数组或字典 */
-(id)JSONValue;
/** 去掉换行和空格 */
+ (NSString *)removeSpaceAndNewline:(NSString *)str;
/** 判断是否含有emoji */
+ (BOOL)stringContainsEmoji:(NSString *)string;
/** 上传页面得到年龄 */
+ (NSString*)getAgeFromBirthday:(NSString*)string;
/** 详情页面得到年龄 */
+ (NSString *)detailGetAgeFromBirthday:(NSString *)string;
/** 得到英文别 */
+ (NSString *)getSexEnglishTypeWithSexString:(NSString*)string;
/** 得到性别 */
+ (NSString *)getSexTypeWithSexString:(NSString*)string;
/** 得到距离现在的时间 */
+ (NSString *)getTimeIntervalWithTime:(NSString*)string;
/** 创建只有日和月的时间字符串 */
+ (NSString *)getOnlyMonthAndDayStringWithDate:(NSDate *)date;
/** 创建精确到天时间字符串 */
+ (NSString *)getToDayStringFromDate:(NSDate *)date;
/** 创建精确到秒时间字符串 */
+ (NSString *)creatNewDateToSecondStringWithDate:(NSDate*)date;
/** 反导性别 */
+ (NSString *)getSexUploadTypeWithSexString:(NSString*)string;
/** 反导出生日期 */
+ (NSString*)getBirthdayWithAge:(NSString*)age;
/** 反导出欧洲星期几 */
+ (NSInteger)getWeekdayWith:(NSDate*)date;
/** 反导出亚洲星期几 */
+ (NSInteger)getAisaWeekdayWith:(NSDate *)date;
/** 判断是否在同一个星期内 */
+ (BOOL)isInSameWeekDate:(NSDate *)firstDate nextDate:(NSDate *)nextDate;
/** 等到日期的详细信息 */
+ (NSDateComponents *)getComonentsWith:(NSDate *)date;
/** 创建本地缓存路径 */
+(NSString *)GetThefilePath:(NSString *)filePath;
/** 归档 */
+ (void)saveData:(id)data withKey:(NSString *)key;
/** 解档 */
+ (instancetype)loadLocalDataWithKey:(NSString *)key;
/**清除path文件夹下缓存大小*/
+ (BOOL)clearCacheWithFilePath:(NSString *)path;



@end
