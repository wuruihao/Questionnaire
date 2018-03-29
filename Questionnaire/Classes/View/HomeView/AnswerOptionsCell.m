//
//  AnswerOptionsCell.m
//  Questionnaire
//
//  Created by Robert on 2018/3/17.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "AnswerOptionsCell.h"

@interface AnswerOptionsCell () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UIImageView *optionImage;
@property (weak, nonatomic) IBOutlet UIButton *action;

@end

@implementation AnswerOptionsCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.titleText.font = [UIFont fontWithName:TextFont size:kSize(15)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)setData:(AnswerData *)data{
    
    _data = data;
    
    if (self.isOptions) {
        self.titleText.placeholder = @"请输入选项";
        self.titleText.enabled = YES;
        if (![ETRegularUtil isEmptyString:data.value]) {
            self.titleText.text = data.value;
        }else{
            self.titleText.text = @"";
        }
        self.titleText.hidden = NO;
        self.action.hidden = YES;
    }else{
        self.titleText.enabled = NO;
        self.action.hidden = NO;
        if (![ETRegularUtil isEmptyString:data.num]) {
            
        }
        if (data.isSelected) {
            self.optionImage.image = [UIImage imageBundleNamed:@"login_option_sel.png"];
            self.titleText.textColor = COLOR_HEX(0x9ECFF7);
        }else{
            self.optionImage.image = [UIImage imageBundleNamed:@"login_option.png"];
            self.titleText.textColor = COLOR_HEX(0x000000);
        }
        
        if (![ETRegularUtil isEmptyString:data.value]) {
            
            self.titleText.text = data.value;
        }else{
            self.titleText.text = @"选项";
        }
    }
}

- (IBAction)clickCellAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didSelectRowAtIndexPath:)]) {
        [self.delegate cell:self didSelectRowAtIndexPath:self.index];
    }
}

#pragma mark - ***************UITextFieldDelegate******************

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

//Add by Yizheming (对应第三方键盘收键盘方法)
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)titleTextFieldDidChange{
    
    self.data.value = self.titleText.text;
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
}

@end
