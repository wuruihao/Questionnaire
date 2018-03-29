//
//  AnswerTitleView.m
//  Questionnaire
//
//  Created by Robert on 2018/3/19.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "AnswerTitleView.h"

@interface AnswerTitleView () <UITextFieldDelegate>

@end

@implementation AnswerTitleView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    
    [self addSubview:self.answerNum];
    self.answerTitle.left = self.answerNum.right;
    self.answerTitle.width = self.width-self.answerNum.right-kScreenWidth*0.05;
    [self addSubview:self.answerTitle];
}

- (UILabel *)answerNum{
    
    if (!_answerNum) {
        _answerNum = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.05, 0, kScreenWidth*0.1, self.height)];
        _answerNum.text = @"Q1:";
        _answerNum.textColor = [UIColor blackColor];
        _answerNum.font = [UIFont fontWithName:TextFont size:kSize(20)];
    }
    return _answerNum;
}

- (UITextField *)answerTitle{
    
    if (!_answerTitle) {
        _answerTitle = [[UITextField alloc] initWithFrame:CGRectMake(0, self.answerNum.top, 0, self.answerNum.height)];
        _answerTitle.borderStyle = UITextBorderStyleNone;
        _answerTitle.placeholder = @"请输入问卷题目";
        _answerTitle.font = [UIFont fontWithName:TextFont size:kSize(17)];
        _answerTitle.textColor = [UIColor blackColor];
        _answerTitle.clearButtonMode = UITextFieldViewModeWhileEditing;
        _answerTitle.keyboardType = UIKeyboardTypeDefault;
        _answerTitle.returnKeyType = UIReturnKeyDone;
        _answerTitle.delegate = self;
    }
    return _answerTitle;
}

@end
