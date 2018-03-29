//
//  CycleScrollView.h
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView

@property (assign) id delegate;
@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , readonly) UIScrollView *scrollView;

- (void)configContentViews;

- (void)setTotalPagesCount:(NSInteger)totalPagesCount;
/**
 初始化

 @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动
 */
- (void)initWithAnimationDuration:(NSTimeInterval)animationDuration;
/**
 数据源：获取总的page个数
 **/

@end

@protocol CycleScrollViewDelegate <NSObject>

@optional
- (NSInteger)totalPageCount;
- (UIView *)fetchContentViewAtIndex:(NSInteger)pageIndex;
- (void)contentViewDidTap:(NSNumber *)index;

@end
