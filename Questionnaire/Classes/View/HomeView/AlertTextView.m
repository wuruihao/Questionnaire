//
//  AlertTextView.m
//  Questionnaire
//
//  Created by Robert on 2018/3/18.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "AlertTextView.h"

@interface AlertTextView () <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *sureButton;
@property (strong, nonatomic) UIButton *cancelButton;

@end

@implementation AlertTextView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        
        //注册观察键盘的变化
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    [self addLineWithCorner:10];
    
    [self addSubview:self.titleLabel];
    self.textInput.top = self.titleLabel.bottom+self.height*0.03;
    [self addSubview:self.textInput];
    self.cancelButton.left = self.width*0.015;
    self.cancelButton.bottom = self.height-self.width*0.01;
    [self addSubview:self.cancelButton];
    self.sureButton.left = self.cancelButton.right+self.width*0.01;
    self.sureButton.top = self.cancelButton.top;
    [self addSubview:self.sureButton];
}
//键盘回收
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for(UIView *view in self.subviews){
        [view resignFirstResponder];
    }
}

//移动UIView
- (void)transformView:(NSNotification *)aNSNotification{
    
    //获取键盘弹出前的Rect
    NSValue *keyBoardBeginBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect = [keyBoardBeginBounds CGRectValue];
    
    //获取键盘弹出后的Rect
    NSValue *keyBoardEndBounds = [[aNSNotification userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect  endRect = [keyBoardEndBounds CGRectValue];
    
    //获取键盘位置变化前后纵坐标Y的变化值
    CGFloat deltaY = endRect.origin.y - beginRect.origin.y + kScreenHeight*0.1;
    NSLog(@"看看这个变化的Y值:%f",deltaY);
    //在0.25s内完成self.view的Frame的变化，等于是给self.view添加一个向上移动deltaY的动画
    [UIView animateWithDuration:0.25f animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y+deltaY, self.frame.size.width, self.frame.size.height)];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//对应第三方键盘收键盘方法
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        
    }
    
    NSString *str = nil;
    if (range.length == 0) {
        str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    }else{
        str = [textField.text substringToIndex:range.location];
    }
    if ([str length] >= 3) {
        textField.text = [str length] == 3 ? str:textField.text;
        return NO;
    }
    return YES;
}

- (UITextField *)textInput{

    if (!_textInput) {
        _textInput = [[UITextField alloc] initWithFrame:CGRectMake(self.width*0.05, 0, self.width*0.9, self.height*0.28)];
        _textInput.borderStyle = UITextBorderStyleRoundedRect;
        _textInput.placeholder = @"不超过3位";
        _textInput.font = [UIFont fontWithName:TextFont size:kSize(17)];
        _textInput.textColor = [UIColor blackColor];
        _textInput.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textInput.keyboardType = UIKeyboardTypeNumberPad;
        _textInput.returnKeyType = UIReturnKeyDone;
        _textInput.delegate = self;
    }
    return _textInput;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFrame:CGRectMake(0, 0, self.width, self.height*0.3) text:@"请输入年龄" textColor:[UIColor blackColor] font:[UIFont fontWithName:TextFont size:kSize(20)]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)sureButton{
    
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.frame = CGRectMake(0, 0, self.width*0.48, self.height*0.25);
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureButton addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
        [_sureButton addLineWithCorner:5];
        _sureButton.backgroundColor = COLOR_HEX(0x9ECFF7);
        _sureButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(17)];
    }
    return _sureButton;
}

- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, 0, self.width*0.48, self.height*0.25);
         [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addLineWithCorner:5];
        _cancelButton.backgroundColor = COLOR_HEX(0x9ECFF7);
        _cancelButton.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(17)];
    }
    return _cancelButton;
}

- (void)sureAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sureAction)]) {
        [self.delegate sureAction];
    }
}

- (void)cancelAction:(UIButton *)sender{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelAction)]) {
        [self.delegate cancelAction];
    }
}

@end
