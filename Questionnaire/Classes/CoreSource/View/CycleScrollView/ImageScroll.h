//
//  ImageScroll.h
//  Carcool
//
//  Created by Enjoytouch on 15/8/11.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CycleScrollView.h"

@class ImageScroll;

@protocol ImageScrollDelegate <NSObject>

- (void)imageScrollDidClick:(NSNumber *)index;

@end

@interface ImageScroll : UIView <CycleScrollViewDelegate>

@property (weak,nonatomic) id <ImageScrollDelegate> delegate;
@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSMutableArray *viewsArray;
@property (strong,nonatomic) CycleScrollView *mainScorllView;

@property (assign,nonatomic) int maxCount;

@property (nonatomic, assign) BOOL  isLoad;//区分 是否 已 请求数据
@property (nonatomic, strong) UIImageView *defaultImg;

- (void)setContentData:(id)data;

@end

