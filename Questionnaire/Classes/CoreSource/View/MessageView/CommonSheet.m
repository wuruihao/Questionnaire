//
//  ActionSheet.m
//  XingPin
//
//  Created by Enjoytouch on 14-11-28.
//  Copyright (c) 2014年 EnjoyTouch. All rights reserved.
//

#import "CommonSheet.h"

@implementation CommonSheet

- (id)initWithDelegate:(id)delegate{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

- (void)setupWithShare{
    
    /****************Mark层******************/
    self.markView = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) BackgroundColor:MarkBackColor];
    self.markView.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self.markView addGestureRecognizer:tapGesture];
    [self addSubview:self.markView];
    
    
    /***********提示view中的控件**********/
    self.messageView = [[BlurView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth,kFitHeight(458))];
    [self addSubview:[self messageView]];
    
    //背景
    UIImageView *imageBg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.messageView.width,self.messageView.height)];
    imageBg.image = [[UIImage imageBundleNamed:@"home_share_bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(8, 9, 8, 9) resizingMode:UIImageResizingModeStretch];
    imageBg.userInteractionEnabled = YES;
    imageBg.backgroundColor = MarkBackColor;
    [self.messageView addSubview:imageBg];
    
    CGFloat spacing = (kScreenWidth-kFitWidth(100)*4)/5;
    UIFont *font = [UIFont fontWithName:TextFont size:kSize(15)];
    
    //微信好友
    UIButton *one = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(spacing,kFitHeight(55),kFitWidth(100),kFitWidth(100)) IconName:@"Login_wechat.png" Target:self Action:@selector(shareAction:) Tag:1];
    
    UILabel *labelOne =[ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0,one.bottom+kFitHeight(20), 0, kFitHeight(30)) Font:font Text:@"微信"];
    labelOne.width = [labelOne.text safelySizeWithFont:labelOne.font constrainedToSize:CGSizeMake(kFitWidth(200), labelOne.height)].width;
    labelOne.left = one.center.x-labelOne.width*0.5;
    labelOne.textColor = TextColor;
    labelOne.textAlignment = NSTextAlignmentCenter;
    
    //微信朋友圈
    UIButton *two = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(one.right+spacing,one.top,one.width,one.height) IconName:@"Login_fx-pyq.png" Target:self Action:@selector(shareAction:) Tag:2];
    
    UILabel *labelTwo = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0,two.bottom+kFitHeight(20),0, labelOne.height) Font:font Text:@"朋友圈"];
    labelTwo.width = [labelTwo.text safelySizeWithFont:labelTwo.font constrainedToSize:CGSizeMake(kFitWidth(200), labelTwo.height)].width;
    labelTwo.left = two.center.x-labelTwo.width*0.5;
    labelTwo.textColor = TextColor;
    labelTwo.textAlignment = NSTextAlignmentCenter;
    
    //QQ
    UIButton *three = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(two.right+spacing ,one.top,one.width,one.height) IconName:@"Login_qq.png" Target:self Action:@selector(shareAction:) Tag:4];
    UILabel *labelThree = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0,three.bottom+kFitHeight(20),0,labelOne.height) Font:font Text:@"QQ"];
    labelThree.width = [labelThree.text safelySizeWithFont:labelThree.font constrainedToSize:CGSizeMake(kFitWidth(200), labelThree.height)].width;
    labelThree.left = three.center.x-labelThree.width*0.5;
    labelThree.textColor = TextColor;
    labelThree.textAlignment = NSTextAlignmentCenter;
    
    //新浪微博
    UIButton *four = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(three.right+spacing ,one.top,one.width,one.height) IconName:@"Login_weibo.png" Target:self Action:@selector(shareAction:) Tag:3];
    UILabel *labelFour = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0,four.bottom+kFitHeight(20),0,labelOne.height) Font:font Text:@"微博"];
    labelFour.width = [labelFour.text safelySizeWithFont:labelFour.font constrainedToSize:CGSizeMake(kFitWidth(200), labelFour.height)].width;
    labelFour.left = four.center.x-labelFour.width*0.5;
    labelFour.textColor = TextColor;
    labelFour.textAlignment = NSTextAlignmentCenter;
    
    //取消
    UIButton *cancel = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, self.messageView.height - kFitHeight(158), kFitWidth(605),kFitHeight(90)) title:@"取消分享" titleColor:MainColor Target:self Action:@selector(shareAction:)];
    cancel.left = self.messageView.width*0.5-cancel.width*0.5;
    cancel.backgroundColor = COLOR_HEX(0x9BCDF3);
    [cancel.titleLabel setFont:[UIFont fontWithName:TextFont size:kSize(20)]];
    cancel.clipsToBounds = YES;
    cancel.layer.cornerRadius = 5.0;
    cancel.tag = 5;
}


- (void)shareAction:(UIButton *)button{
    
    if (button.tag == 5) {
        [self cancelAction];
    }else{
        
        [self removeFromSuperview];
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareChaining:)]) {
            [self.delegate shareChaining:button];
        }
    }
    
}


- (void)setupWithTitles:(NSArray *)titles{
    /******************判断无标题***************/
    CGFloat MainH =0;
    self.sheets = [NSMutableArray arrayWithArray:titles];
    if ([ETRegularUtil isEmptyString:titles[0]]) {
        [self.sheets removeObjectAtIndex:0];
        MainH= ([self.sheets count]+1)*kFitHeight(115)+8;
        
    }else{
        MainH= [self.sheets count]*kFitHeight(115)+kFitHeight(120)+8;
    }
    /****************Mark层******************/
    self.markView = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) BackgroundColor:MarkBackColor];
    self.markView.alpha = 0;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelAction)];
    [self.markView addGestureRecognizer:tapGesture];
    [self addSubview:self.markView];
    
    /***********提示view中的控件**********/
    [self setMessageView:[BlurView new]];
    [[self messageView] setFrame:CGRectMake(0, kScreenHeight, kScreenWidth, MainH)];
    [self addSubview:[self messageView]];
    
    CGFloat messH = 0;
    for (int i = 0; i<[self.sheets count]; i++) {
        
        if (i==0&&![ETRegularUtil isEmptyString:titles[0]]) {
            UILabel *title = [ETUIUtil drawLabelInView:self.messageView Frame:CGRectMake(0, 0, self.messageView.width, kFitHeight(120)) Font:[UIFont fontWithName:TextFont size:kSize(13)] Text:self.sheets[0] Color:TextColor];
            [title setNumberOfLines:0];
            [title setTextAlignment:NSTextAlignmentCenter];
            [ETUIUtil drawCustomImgViewInView:self.messageView Frame:CGRectMake(0, 0, self.messageView.width, kFitHeight(120)) BundleImgName:@"sheet_normal.png"];
            messH = kFitHeight(120);
        }else{
            
            CGFloat margin = i*kFitHeight(115);
            if (messH>0) {
                margin = (i-1)*kFitHeight(115)+ messH;
            }
            
            //分割线
            UIView *line = [ETUIUtil drawViewWithFrame:CGRectMake(0, margin, self.messageView.width, .5) BackgroundColor:[UIColor colorWithHex:0xDEDEDD alpha:1]];
            [self.messageView addSubview:line];
            //sheetBt
            UIButton *sheetBt = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, margin+0.5, self.messageView.width, kFitHeight(115)) title:self.sheets[i] titleColor:COLOR_HEX(0x0080FF) Target:self Action:@selector(sheetBtClickedAction:)];
            //有提示信息则tag退1
            if (messH>0) {
                sheetBt.tag = i-1;
            }else{
                sheetBt.tag = i;
            }
            [sheetBt setBackgroundImage:[UIImage imageBundleNamed:@"sheet_normal.png"] forState:UIControlStateNormal];
            [sheetBt setBackgroundImage:[UIImage imageBundleNamed:@"sheet_highlight.png"] forState:UIControlStateHighlighted];
            [sheetBt.titleLabel setFont:[UIFont fontWithName:TextFont size:kSize(20)]];
            if (_itemColor) {
                [sheetBt setTitleColor:_itemColor forState:UIControlStateNormal];
            }
        }
    }
    UIView *lastLine = [ETUIUtil drawViewWithFrame:CGRectMake(0, MainH-kFitHeight(115)-8, self.messageView.width, 8) BackgroundColor:[UIColor colorWithHex:0x000000 alpha:.1]];
    [self.messageView addSubview:lastLine];
    
    /********************取消控件*********************/
    self.cancelBtn = [ETUIUtil drawButtonInView:self.messageView Frame:CGRectMake(0, MainH-kFitHeight(115), kScreenWidth, kFitHeight(115)) title:@"取消" titleColor:COLOR_HEX(0x0080FF) Target:self Action:@selector(cancelAction)];
    [self.cancelBtn setBackgroundImage:[UIImage imageBundleNamed:@"sheet_normal.png"] forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:[UIImage imageBundleNamed:@"sheet_highlight.png"] forState:UIControlStateHighlighted];
    [self.cancelBtn.titleLabel setFont:[UIFont fontWithName:TextFont size:kSize(20)]];
    /***********************************************/
    
    
}

- (void)showInView:(UIView *)view{
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 1.0;
        self.markView.height = kScreenHeight - self.messageView.height;
        self.messageView.top = kScreenHeight - self.messageView.height;
    }];
}

- (void)cancelAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.markView.alpha = 0.0;
        self.markView.height = kScreenHeight;
        self.messageView.top = kScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)sheetBtClickedAction:(UIButton *)sender{
    
    [self removeFromSuperview];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commonSheetClickedIndex:SheetTag:)]) {
        [self.delegate commonSheetClickedIndex:[NSNumber numberWithInteger:sender.tag]  SheetTag:[NSNumber numberWithInteger:self.sheetTag]];
    }
}

@end
