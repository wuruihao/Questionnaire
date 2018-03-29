//
//  AlertTextView.h
//  Questionnaire
//
//  Created by Robert on 2018/3/18.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertTextViewDelegate <NSObject>

- (void)sureAction;

- (void)cancelAction;

@end

@interface AlertTextView : UIView

@property (weak, nonatomic) id <AlertTextViewDelegate> delegate;

@property (strong, nonatomic) UITextField *textInput;

@end
