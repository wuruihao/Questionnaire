//
//  PopupView.m
//  ZhiYuan
//
//  Created by Omiyang on 13-6-15.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import "ETMessageView.h"

@implementation ETMessageView
@synthesize backView = _backView;
@synthesize spinner = _spinner;
@synthesize messageLabel = _messageLabel;
@synthesize timer = _timer;
@synthesize animalImgV = _animalImgV;


//单例定位模型
+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static ETMessageView *sharedInstance = nil;
    dispatch_once(&pred, ^{
        CGRect rect = CGRectMake((kScreenWidth-ET_MESSVIEW_WIDTH)/2, kScreenHeight*.4, ET_MESSVIEW_WIDTH, ET_MESSVIEW_HEIGHT);
        sharedInstance = [[ETMessageView alloc] initWithFrame:rect];
        [sharedInstance addSubview:sharedInstance.backView];
        sharedInstance.messageLabel.frame = CGRectMake(40, 10, ET_MESSVIEW_WIDTH - 40 -10, 20);
        [sharedInstance addSubview:sharedInstance.messageLabel];
    });
    return sharedInstance;
}


- (UIView *)backView {
    if (_backView == nil) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        _backView = [[UIView alloc] initWithFrame:frame];
        _backView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.8f];
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 10;
    }
    return _backView;
}

- (UIImageView *)animalImgV{
    if (_animalImgV == nil) {
        _animalImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kFitHeight(55), kFitHeight(55))];
        
    }
    return _animalImgV;
}

- (UIActivityIndicatorView *)spinner {
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    }
    return _spinner;
}

- (UILabel *)messageLabel {
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
    }
    return _messageLabel;
}

- (void)cancelHiddenDuration {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)showMessage:(NSString *)mess onView:(UIView *)view Type:(MESSAGETYPE)type{
    
    switch (type) {
            //提示框文字信息
        case MESSAGE_ALERT:{
            
            [self showMessage:mess onView:view];
        }
            break;
            //提示框文字带动画
        case MESSAGE_ANIMATION:{
            
            [self showSpinnerMessage:mess onView:view];
            //            [self onlyShowAnimalImageView:view];
            
        }
            break;
            //提示框文字信息延迟时间消失
        case MESSAGE_ALERT_DELAY:{
            
            [self showMessage:mess onView:view];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
        }
            break;
            //提示框文字带动画延迟时间消失
        case MESSAGE_ANIMATION_DELAY:{
            
            [self showSpinnerMessage:mess onView:view];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)showMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration{
    
    [self showMessage:mess onView:view];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
}

- (void)showMessage:(NSString *)mess onView:(UIView *)view{
    
    _backView.hidden = NO;
    self.height = ET_MESSVIEW_HEIGHT;
    self.width = ET_MESSVIEW_WIDTH;
    _messageLabel.hidden = NO;
    
    [self cancelHiddenDuration];
    
    CGSize showSize,textSize;
    if (_spinner) {
        [self.spinner removeFromSuperview];
        self.spinner = nil;
    }
    showSize = CGSizeMake(ET_MESSVIEW_WIDTH_MAX-20, 1000);
    
    textSize = [mess safelySizeWithFont:self.messageLabel.font constrainedToSize:showSize];
    
    if (textSize.width>ET_MESSVIEW_WIDTH) {
        
        [self setSize:CGSizeMake(textSize.width+20, ET_MESSVIEW_HEIGHT)];
    }
    [self setCenterX:kScreenWidth*.5];
    
    self.messageLabel.numberOfLines = textSize.height/self.messageLabel.font.lineHeight;
    [self.messageLabel setSize:textSize];
    self.messageLabel.text = mess;
    
    if (self.messageLabel.width < showSize.width) {
        [self.messageLabel setCenterX:self.width/2];
        [self.backView setSize:self.frame.size];
    }
    
    if (self.messageLabel.height > ET_MESSVIEW_HEIGHT-20) {
        self.height = self.messageLabel.height + 20;
        [self.backView setSize:self.frame.size];
    }
    [self.messageLabel setCenterY:self.height/2];
    
    self.hidden = NO;
    if (self.superview == nil) {
        [view addSubview:self];
    }
    
}

#pragma mark - **********Spinner************
- (void)showSpinnerMessage:(NSString *)mess onView:(UIView *)view withDuration:(NSTimeInterval)duration{
    
    [self showSpinnerMessage:mess onView:view];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration target:self selector:@selector(hideMessage) userInfo:nil repeats:NO];
}

- (void)showSpinnerMessage:(NSString *)mess onView:(UIView *)view{
    
    _backView.hidden = NO;
    self.height = ET_MESSVIEW_HEIGHT;
    self.width = ET_MESSVIEW_WIDTH;
    _messageLabel.hidden = NO;
    
    [self cancelHiddenDuration];
    CGSize showSize,textSize;
    showSize = CGSizeMake(ET_MESSVIEW_WIDTH_MAX-50, 1000);
    [self.spinner startAnimating];
    [self addSubview:self.spinner];
    
    textSize = [mess safelySizeWithFont:self.messageLabel.font constrainedToSize:showSize];
    if (textSize.width>ET_MESSVIEW_WIDTH) {
        [self setSize:CGSizeMake(textSize.width+50, ET_MESSVIEW_HEIGHT)];
    }
    [self setCenterX:kScreenWidth*.5];
    
    self.messageLabel.numberOfLines = textSize.height/self.messageLabel.font.lineHeight;
    [self.messageLabel setSize:textSize];
    self.messageLabel.text = mess;
    
    if (self.messageLabel.width < showSize.width) {
        [self.messageLabel setCenterX:self.width/2];
        [self.messageLabel setCenterX:self.messageLabel.center.x+10];
        [self.spinner setCenterX:self.messageLabel.left-20];
        [self.backView setSize:self.frame.size];
    }
    
    if (self.messageLabel.height > ET_MESSVIEW_HEIGHT-50) {
        self.height = self.messageLabel.height + 20;
        [self.backView setSize:self.frame.size];
    }
    
    [self.messageLabel setCenterY:self.height/2];
    [self.spinner setCenterY:self.messageLabel.center.y];
    
    self.hidden = NO;
    
    if (self.superview == nil) {
        [view addSubview:self];
    }
}


- (void)onlyShowAnimalImageView:(UIView *)view{
    [_spinner stopAnimating];
    _backView.hidden = YES;
    _messageLabel.hidden = YES;
    [self setFrame:CGRectMake((kScreenWidth-ET_MESSVIEW_WIDTH)/2, kScreenHeight*.4, ET_MESSVIEW_WIDTH, ET_MESSVIEW_HEIGHT)];
    
    [self addSubview:self.animalImgV];
    if (self.superview == nil) {
        [view addSubview:self];
    }
    self.animalImgV.center = CGPointMake(ET_MESSVIEW_WIDTH*0.5, ET_MESSVIEW_WIDTH*0.5);
    
    // 加载所有的动画图片
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i<=12; i++) {
        NSString *filename = [NSString stringWithFormat:@"loading_message_%d",i];
        UIImage *image = [UIImage imageBundleNamed:filename];
        [images safelyAddObject:image];
    }
    
    // 设置动画图片
    self.animalImgV.animationImages = images;
    self.animalImgV.animationDuration = 1.0;//设置动画时间
    self.animalImgV.animationRepeatCount = 0;//设置动画次数 0 表示无限
    // 开始动画
    [self.animalImgV startAnimating];
    
    self.hidden = NO;
}

- (void)hideMessage {
    
//    [self cancelHiddenDuration];
    
    if (_spinner) {
        [_spinner removeFromSuperview];
        _spinner = nil;
    }
    if (_animalImgV) {
        [_animalImgV stopAnimating];
        [_animalImgV removeFromSuperview];
        _animalImgV = nil;
    }
    [self removeFromSuperview];
    self.hidden = YES;
}

@end
