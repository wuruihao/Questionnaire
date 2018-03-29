//
//  WJTextView.m
//  WJTextView
//
//  Created by 高文杰 on 16/3/1.
//  Copyright © 2016年 高文杰. All rights reserved.
//

#import "WJTextView.h"

@interface WJTextView ()

@property (nonatomic,weak) UILabel *placehoderLabel;

@end

@implementation WJTextView



- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        UILabel *placehoderLabel = [[UILabel alloc]init];
        placehoderLabel.numberOfLines = 0;
        [self addSubview:placehoderLabel];
        self.placehoderLabel = placehoderLabel;
        self.placehoderColor = [UIColor whiteColor];
        self.font = [UIFont systemFontOfSize:14];
        [self initNotification];
    }
    return self;
}

- (void)textDidChange{
    
    self.placehoderLabel.hidden = self.text.length != 0;
    
    if ([self.text isChinesecharacter] == NO){
        
        NSInteger count =  [self.text characterCountOfString];
        if (self.textDelegate && [self.textDelegate respondsToSelector:@selector(textDidChangeNumber:)]) {
            [self.textDelegate textDidChangeNumber:count];
        }
    }
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setFont:(UIFont *)font{
    
    [super setFont:font];
    self.placehoderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setPlacehoderColor:(UIColor *)placehoderColor{
    
    _placehoderColor = placehoderColor;
    self.placehoderLabel.textColor = placehoderColor;
}

- (void)setIsAutoHeight:(BOOL)isAutoHeight{
    
    _isAutoHeight = isAutoHeight;
    [self setNeedsLayout];
}

- (void)setPlacehoder:(NSString *)placehoder{
    
    _placehoder = [placehoder copy];
    self.placehoderLabel.text = placehoder;
    [self setNeedsLayout];
}
- (void)initNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark - 键盘监听
- (void)keyboardChange:(NSNotification *)notification{
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    CGRect frameOfMess = self.frame;
    if (notification.name == UIKeyboardWillShowNotification){
        
        //        //添加后光标定位在最尾部
        //        //slectedRange是一个结构，表示位置和长度，后面的NSMakeRange同样
        //        //NSUInteger 表示无符号的整型，但用下面两行设置无效，因为selectedRange是一个属性，可以获得值也可以赋值但不是方法不可以操作滚动动作
        //        NSUInteger len1 = self.text.length - 1;
        //        NSRange selectedRange = NSMakeRange(len1, 0);
        //        //需要用一下滚动操作的方法，并且把selectedRange属性值作为Range值传递进去
        //        //不满意的是每次新添加后它都要从Top滚动到尾部，感觉怪怪的
        //        [self scrollRangeToVisible:selectedRange];
        
        if (self.bottom > keyboardEndFrame.origin.y) {
            frameOfMess.size.height = kScreenHeight - 64 - kScreenHeight*0.02 - kScreenHeight*0.05 - kScreenHeight*0.1 - keyboardEndFrame.size.height;
            self.frame = frameOfMess;
        }
    }else{
        frameOfMess.size.height = kScreenHeight - 64 - kScreenHeight*0.02 - kScreenHeight*0.05 - kScreenHeight*0.1 - keyboardEndFrame.size.height;
        self.frame = frameOfMess;
    }
    
    [self layoutIfNeeded];
    [UIView commitAnimations];
    
    
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
//        [self pinglun];
//        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
//    }
//
//    return YES;
//}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.placehoderLabel.top = 10;
    self.placehoderLabel.left = 10;
    self.placehoderLabel.width = kScreenWidth - 20;
    self.placehoderLabel.height = [self.placehoder safelySizeWithFont:self.placehoderLabel.font constrainedToSize:CGSizeMake(self.width, MAXFLOAT)].height;
    //    CGFloat textHeight = [self.text safelySizeWithFont:self.font constrainedToSize:CGSizeMake(self.width, MAXFLOAT)].height;
    //
    //    if (textHeight > kScreenHeight*0.5 && self.isAutoHeight) {
    //        self.frame = CGRectMake(self.left, self.top, self.width, textHeight+kScreenHeight*0.02);
    //    }
}


- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


@end
