//
//  NSDate+TKCategory.h
//  GymboreeCOS
//
//  Created by mac on 14-5-9.
//
//

#import <Foundation/Foundation.h>


struct TKDateInformation {
	NSInteger day;
	NSInteger month;
	NSInteger year;
	
	NSInteger weekday;
	
	NSInteger minute;
	NSInteger hour;
	NSInteger second;
	
};
typedef struct TKDateInformation TKDateInformation;

/** Additional functionality for `NSDate`. */
@interface NSDate (TKCategory)

- (NSDate *)previousMonth;
- (NSDate *) nextMonth;

- (NSDate *)previousYear;

// 月份
- (NSInteger)monthIndex;

- (NSString *)hourMins;

/**
 *  判断两个日期是否是同一天
 *
 *  @param anotherDate 另一个日期
 *
 *  @return YES：是同一天，NO：不是同一天
 */
- (BOOL)isSameDay:(NSDate *)anotherDate;

/**
 *  判断当前日期是否是今天
 *
 *  @return YES：是今天，NO：不是今天
 */
- (BOOL)isToday;

/**
 *  两个日期之间相差的天数
 *
 *  @param date 另一个日期
 *
 *  @return 整型，天数
 */
- (NSInteger)daysBetweenDate:(NSDate *)date;

/**
 *  当前日期＋天数＝ 另一个日期
 *
 *  @param days 天数
 *
 *  @return 另一个日期
 */
- (NSDate *)dateByAddingDays:(NSUInteger)days;

/**
 *  几个月后的日期
 *
 *  @param monthes 月数
 *
 *  @return 另一个日期
 */
- (NSDate *)dateByAddingMonthes:(NSUInteger)monthes;

/**
 *  几周后的日期
 *
 *  @param weeks 周数
 *
 *  @return 另一个日期
 */
- (NSDate *)dateByAddingWeeks:(NSUInteger)weeks;

/**
 *  当前日期的月份
 *
 *  @return 月份，例如：2015/08 中的08
 */
- (NSString *)monthString;

/**
 *  当前日期的年份
 *
 *  @return 年份，例如：2015/08 中的2015
 */
- (NSString *)yearMonthString;

/**
 *  当前日期的日期
 *
 *  @return 日期，例如：2015/08/01 中的01
 */
- (NSString *)dayValue;

- (NSString *)weekString;

/**
 *  当前日期是否早于目标日期
 *
 *  @param date 目标日期
 *
 *  @return YES：当前日期早于目标日期，NO：当前日期晚于或者等于目标日期
 */
- (BOOL)isEarlyFromDate:(NSDate *)date;

// 比targetDate要晚
- (BOOL)isLateFromDate:(NSDate *)targetDate;

- (NSString *)stringWithDateFormatter:(NSString *)formatter;

+ (NSDate *)dateFromString:(NSString *)string
             dateFormatter:(NSString *)formatter;


// 比较两个日期是否在同一周，comdat是需要比较的日期
+ (BOOL)isAweek:(NSDate *)date compareDate:(NSDate *)comDate;

// 是否是前一个月
- (BOOL)isPreviousMonth:(NSDate *)date;

// 是否是下一个月
- (BOOL)isNextMonth:(NSDate *)date;

// 是同一个月
- (BOOL)isSameYearAndMonth:(NSDate *)anotherDate;

@end
