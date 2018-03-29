//
//  CommonAlert.m
//  Carcool
//
//  Created by yizheming on 15/11/23.
//  Copyright © 2015年 EnjoyTouch. All rights reserved.
//

#import "CommonAlert.h"
#define AlertH  CGRectGetHeight(CGRectMake(0, 0, 250, 45))
#define AlertW  CGRectGetWidth(CGRectMake(0, 0, 250, 45))
#define Color05 [UIColor colorWithHex:0xea852a alpha:1]
#define Color18 [UIColor colorWithHex:0x1C1C1C alpha:0.8]

typedef enum : NSUInteger {
    ModifyPassword = 11
} CommonAlertType;

@interface CommonAlert ()

@property (nonatomic,strong) NSMutableArray *itemArray;
@property (nonatomic,strong) NSMutableArray *itemData;

@end

@implementation CommonAlert{
    NSArray *_titleArr;
    UIView *panel;
    UILabel *mess;
    UIImageView *lineImgV;
    CommonAlertType _type;
}

- (id)initWithMessage:(NSString *)message withBtnTitles:(NSArray *)titles{
    UIInterfaceOrientation sataus=[UIApplication sharedApplication].statusBarOrientation;
    if(sataus==UIInterfaceOrientationPortrait){
        self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }else{
        self = [super initWithFrame:CGRectMake(0, 0,kScreenHeight, kScreenWidth)];
    }
    if (self) {
        NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
        for (id item in subviews) {
            if ([item isKindOfClass:[CommonAlert class]]) {
                [item removeFromSuperview];
            }
        }
        _titleArr = titles;
        //1.背景
        [self setBackgroundColor:[UIColor blackColor]];
        //2.主视图
        panel = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, AlertW, AlertH) BackgroundColor:[UIColor whiteColor]];
        [panel setClipsToBounds:YES];
        [self addSubview:panel];
        
        //3.标题及内容
        mess = [ETUIUtil drawLabelInView:panel Frame:CGRectMake(15, 0, AlertW *0.9, AlertH) Font:[UIFont fontWithName:@"Helvetica-Bold" size:16] Text:message Color:[UIColor whiteColor]];
        mess.numberOfLines = 0;
    }
    return self;
}
- (NSMutableArray *)itemArray{
    
    if (!_itemArray) {
        _itemArray = [NSMutableArray array];
    }
    return _itemArray;
}
- (NSMutableArray *)itemData{
    
    if (!_itemData) {
        _itemData = [@[@"0",@"0",@"0",@"0"] mutableCopy];
    }
    return _itemData;
}
- (void)showInWindow{
    
    for (UIView *item in [UIApplication sharedApplication].keyWindow.subviews) {
        if ([item isKindOfClass:[self class]]) {
            CommonAlert *sub = (CommonAlert *)item;
            sub.delegate = nil;
            [sub removeFromSuperview];
        }
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    }];
}
- (void)hiddenView{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [panel removeFromSuperview];
        for (id sub in panel.subviews) {
            [sub removeFromSuperview];
        }
        panel = nil;
        [self removeFromSuperview];
    }];
}

- (void)chooseAction{
    
    [UIView animateWithDuration:1 animations:^{
        self.alpha = .0;
    } completion:^(BOOL finished) {
        [mess removeFromSuperview];
        [panel removeFromSuperview];
        [self removeFromSuperview];
        mess = nil;
        panel = nil;
    }];
}

- (void)itemCancelAction{
    
    [self removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemCancel:)]) {
        [self.delegate self];
    }
}

- (void)itemCertainAction{
    
    if (_type != ModifyPassword) {
        [self removeFromSuperview];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemCertain:)]) {
        [self.delegate self];
    }
}

@end
