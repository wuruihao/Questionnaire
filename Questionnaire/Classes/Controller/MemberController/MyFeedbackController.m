//
//  MyFeedbackController.m
//  Questionnaire
//
//  Created by Robert on 2018/3/16.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "MyFeedbackController.h"

@interface MyFeedbackController ()

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation MyFeedbackController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.titleTextView addLineWithCorner:10];
    [self.saveButton addLineWithCorner:10];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.titleTextView becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self.titleTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitFeedbackAction:(UIButton *)sender {
    
    kWeakSelf;
    [[ETMessageView sharedInstance]showMessage:MESSAGE_Loading onView:self.view Type:MESSAGE_ANIMATION];
    
    AVObject *object = [[AVObject alloc] initWithClassName:@"Feedback"];
    [object setObject:self.titleTextView.text forKey:@"content"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [[ETMessageView sharedInstance] hideMessage];
        if (succeeded) {
            [[ETMessageView sharedInstance] showMessage:@"上传成功" onView:self.view Type:MESSAGE_ALERT_DELAY];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        }else{
            [[ETMessageView sharedInstance] showMessage:@"上传失败" onView:self.view Type:MESSAGE_ALERT_DELAY];
        }
    }];
     
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

@end
