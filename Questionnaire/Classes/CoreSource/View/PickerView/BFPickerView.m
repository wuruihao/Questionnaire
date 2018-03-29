//
//  BFPickerView.m
//  Crabyter
//
//  Created by Sinyoo on 16/12/7.
//  Copyright © 2016年 microdreams. All rights reserved.
//


#define kSCWIDTH [[UIScreen mainScreen] bounds].size.width
#define kSCHEIGHT [[UIScreen mainScreen] bounds].size.height


#import "BFPickerView.h"
#import "UIView+Line.h"

@interface BFPickerView() <UIPickerViewDataSource,UIPickerViewDelegate>
{
    UIPickerView            *_pickerView;
}

@end

@implementation BFPickerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createPickerView];
    }
    
    return self;
}

- (void)createPickerView
{
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
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0,self.frame.size.height-176+20, self.frame.size.width, 176)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:_pickerView];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_pickerView reloadAllComponents];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    _selectIndex = selectIndex;
}

- (void)clickCancel:(UIBarButtonItem *)button
{
    if (_cancelBlock) {
        _cancelBlock();
    }
    
    [UIView dismissBottomViewWithAnimated:YES];
}

- (void)clickSure:(UIBarButtonItem *)button
{
    if (_didSelectBlock) {
        _didSelectBlock(_selectIndex);
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerViewCommitAction:text:)]) {
        [self.delegate pickerViewCommitAction:self text:[self.dataSource objectAtIndex:_selectIndex]];
    }
    [UIView dismissBottomViewWithAnimated:YES];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return _dataSource.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return kSCWIDTH;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 44;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return _dataSource[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _selectIndex = row;
}

@end
