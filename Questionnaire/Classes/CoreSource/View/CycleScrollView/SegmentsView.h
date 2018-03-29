//
//  SegmentsView.h
//  038Lottery
//
//  Created by ruihao on 2017/7/24.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SegmentsViewDelegate <NSObject>

- (void)clickSegmentsItem:(NSInteger)index;

@end

@interface SegmentsView : UIView

- (instancetype)initWithFrame:(CGRect)frame barTitle:(NSArray *)barTitle;
@property(nonatomic, copy) UIColor *btnTextNomalColor;
@property(nonatomic, copy) UIColor *btnTextSeletedColor;
@property(nonatomic, copy) UIColor *sliderColor;
@property(nonatomic, copy) UIColor *topBarColor;
@property(nonatomic, weak) id <SegmentsViewDelegate> delegate;

@end
