//
//  BFDatePicker.m
//  GymboreeCOS
//
//  Created by mac on 14-5-16.
//
//

#import "BFDatePicker.h"
#import "UIView+Line.h"
#import "NSDate+TKCategory.h"

#define YYYYMMSeperator   @"yyyy-MM"
#define hhmmFomater     @"HH:mm"
#define YYMMDDHHMMFomatter @"yyyy-MM-dd HH:mm:ss"

#define yymmddFomatter   @"yyyy-MM-dd"
#define yyyyMMddhhmmss   @"yyyy-MM-dd hh:mm:ss"
#define kSCWIDTH [[UIScreen mainScreen] bounds].size.width
#define kSCHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface BFDatePicker()
{
    NSString        *_selectDateString;
}

@end

@implementation BFDatePicker

// Are you sure you want to delete this record?按钮
-(void)clickSure:(id)sender
{
    [self setTextFieldValue];
    
    if ([_delegate respondsToSelector:@selector(pickerViewWilldismiss:targetDate:)]) {
        [_delegate pickerViewWilldismiss:self targetDate:_selectDateString];
    }
    
    [self closeView];
}

- (void)setTextFieldValue
{
    if (_dateMode == UIDatePickerModeDate) {
        _selectDateString = [_datePicker.date stringWithDateFormatter:yyyyMMddhhmmss];
    } else if (_dateMode == UIDatePickerModeTime) {
        NSString *hourString = [_datePicker.date stringWithDateFormatter:hhmmFomater];
        _selectDateString = hourString;
    } else {
        _selectDateString = [_datePicker.date stringWithDateFormatter:YYMMDDHHMMFomatter];
    }
    
    _targetTextField.text = _selectDateString;
}

// cancel按钮
-(void)clickCancel:(id)sender
{
    _targetTextField.text = @"";
    if ([_delegate respondsToSelector:@selector(pickerViewCancelAction:)]) {
        [_delegate pickerViewCancelAction:self];
    }
    
    [self closeView];
}

- (void)closeView
{
    [UIView dismissBottomViewWithAnimated:YES];
}

//数据初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        [self createDatePickerView];
        // Initialization code
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createDatePickerView];
    }
    return self;
}

- (void)createDatePickerView{
    
    CGRect  frame  = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-200, kSCWIDTH, 200);
    [self setFrame:frame];
    
    UIToolbar   *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(10,0, kSCWIDTH - 20, 44)];
    UIBarButtonItem  *cancel = [[UIBarButtonItem alloc] initWithTitle:@"cancel" style:UIBarButtonItemStylePlain target:self action:@selector(clickCancel:)];
    [cancel setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    UIBarButtonItem  *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
    UIBarButtonItem  *sure = [[UIBarButtonItem alloc] initWithTitle:@"sure" style:UIBarButtonItemStylePlain target:self action:@selector(clickSure:)];
    [sure setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} forState:UIControlStateNormal];
    
    [toolBar setItems:@[cancel,fixedSpace,sure]];
    toolBar.barTintColor = [UIColor whiteColor];
    [self addSubview:toolBar];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0,self.frame.size.height-176+20, self.frame.size.width, 176)];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中
    _datePicker.locale = locale;
    [_datePicker addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setBackgroundColor:[UIColor whiteColor]];;
    [self addSubview:_datePicker];
}

- (void)setCurrentDate:(NSDate *)currentDate
{
    _currentDate = currentDate;
    _datePicker.date = currentDate;
}

- (void)setMaxDate:(NSDate *)date
{
    [_datePicker setMaximumDate:date];
}

- (void)setMinDate:(NSDate *)date
{
    [_datePicker setMinimumDate:date];
}

- (void)setDateMode:(UIDatePickerMode)dateMode
{
    _dateMode = dateMode;
    [_datePicker setDatePickerMode:dateMode];
}

- (void)valueChange:(UIDatePicker *)picker
{
    [self setTextFieldValue];
}

- (NSDate *)selectedDate
{
    return _datePicker.date;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
