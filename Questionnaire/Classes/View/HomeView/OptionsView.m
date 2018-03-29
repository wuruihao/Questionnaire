//
//  OptionsView.m
//  Questionnaire
//
//  Created by Robert on 2018/3/18.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "OptionsView.h"

@interface OptionsView ()

@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@end

@implementation OptionsView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self = [[[NSBundle mainBundle] loadNibNamed:@"OptionsView" owner:nil options:nil] lastObject];
        self.frame = frame;
        
        [self setup];
        
        //注册观察键盘的变化
//        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(transformView:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor whiteColor];
    self.inputTextField.font = [UIFont fontWithName:TextFont size:kSize(15)];
}

@end
