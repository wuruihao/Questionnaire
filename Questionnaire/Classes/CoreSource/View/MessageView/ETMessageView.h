//
//  PopupView.h
//  ZhiYuan
//
//  Created by Omiyang on 13-6-15.
//  Copyright (c) 2013年 Omiyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, MESSAGETYPE){
    
    //提示框文字信息
    MESSAGE_ALERT = 0,
    //提示框文字带动画
    MESSAGE_ANIMATION,
    //提示框文字信息延迟时间消失
    MESSAGE_ALERT_DELAY,
    //提示框文字带动画延迟时间消失
    MESSAGE_ANIMATION_DELAY,
};

#define ET_MESSVIEW_WIDTH 160
#define ET_MESSVIEW_WIDTH_MAX 240
#define ET_MESSVIEW_HEIGHT 44
@interface ETMessageView : UIView

@property (retain, nonatomic) UIView *backView;
@property (retain, nonatomic) UIActivityIndicatorView *spinner;
@property (retain, nonatomic) UILabel *messageLabel;
@property (nonatomic, retain) UIImageView *animalImgV;
@property (retain, nonatomic) NSTimer *timer;
@property (retain, nonatomic) UIImageView *image;

+ (id)sharedInstance;

- (void)showMessage:(NSString *)mess onView:(UIView *)view Type:(MESSAGETYPE)type;

- (void)hideMessage;

@end
