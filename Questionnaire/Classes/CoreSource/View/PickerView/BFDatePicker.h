//
//  BFDatePicker.h
//  GymboreeCOS
//
//  Created by mac on 14-5-16.
//
//

#import <UIKit/UIKit.h>

@class BFDatePicker;
@protocol BFDatePickerDelegate <NSObject>

@optional
/**
 *  pickerView点击选中数据隐藏
 *
 *  @param view   对应的View
 *  @param selectDateString 点击的数据
 */
- (void)pickerViewWilldismiss:(BFDatePicker *)view
                       targetDate:(NSString *)selectDateString;

/**
 * pickerView cancel点击
 *
 *  @param view 对应的View
 */
- (void)pickerViewCancelAction:(BFDatePicker *)view;

@end

@interface BFDatePicker : UIView

@property(nonatomic) UIDatePickerMode dateMode;

@property(nonatomic,weak)id<BFDatePickerDelegate> delegate;

@property(nonatomic,strong) UITextField *targetTextField;

@property(nonatomic,strong)NSDate *currentDate;

@property(nonatomic) NSInteger customIndex;

@property(nonatomic) UIDatePicker *datePicker;

- (NSDate *)selectedDate;

- (void)setMaxDate:(NSDate *)date;

- (void)setMinDate:(NSDate *)date;

@end

