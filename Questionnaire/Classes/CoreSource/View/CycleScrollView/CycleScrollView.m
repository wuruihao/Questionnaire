//
//  CycleScrollView.m
//  PagedScrollView
//
//  Created by 陈政 on 14-1-23.
//  Copyright (c) 2014年 Apple Inc. All rights reserved.
//

#import "CycleScrollView.h"
#import "NSTimer+Addition.h"
@interface CycleScrollView () <UIScrollViewDelegate>

@property (nonatomic , assign) NSInteger currentPageIndex;
@property (nonatomic , assign) NSInteger totalPageCount;
@property (nonatomic , strong) NSMutableArray *contentViews;
@property (nonatomic , strong) UIScrollView *scrollView;
//@property (nonatomic , strong) NSTimer *animationTimer;
@property (nonatomic , assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *roundLabel;
@property (nonatomic, strong) UIView *roundView;

@end

@implementation CycleScrollView

- (void)setTotalPagesCount:(NSInteger)totalPagesCount
{
    _totalPageCount = totalPagesCount;
    if (_totalPageCount > 0) {
        
        if (_totalPageCount>1) {
            [self configContentViews];
            self.scrollView.scrollEnabled = YES;
            [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        }
        else {
            [self onlyOneImageconfigContentViews];
            self.scrollView.scrollEnabled = NO;
            [self.animationTimer invalidate];
        }
    }
    else {
        self.scrollView.scrollEnabled = NO;
    }
    _pageControl.numberOfPages = _totalPageCount;
}

- (void)initWithAnimationDuration:(NSTimeInterval)animationDuration
{
    // Initialization code
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.scrollView.autoresizingMask = 0xFF;
    self.scrollView.contentMode = UIViewContentModeCenter;
    self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
    self.scrollView.pagingEnabled = YES;
    [self.scrollView setBounces:YES];
    [self addSubview:self.scrollView];
    self.currentPageIndex = 0;
    
    if (animationDuration > 0.0) {
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                               target:self
                                                             selector:@selector(animationTimerDidFired:)
                                                             userInfo:nil
                                                              repeats:YES];
        [self.animationTimer pauseTimer];
        CGRect rect = self.bounds;
        rect.origin.y = rect.size.height - 30;
        rect.size.height = 30;
        _pageControl = [[UIPageControl alloc] initWithFrame:rect];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:0x459DF5 alpha:0.5];
        _pageControl.pageIndicatorTintColor = [UIColor colorWithHex:0xeeeeee alpha:0.3];

        [self addSubview:_pageControl];

    }
}

#pragma mark -
#pragma mark - 私有函数
- (void)onlyOneImageconfigContentViews{
    
    UIView *contentView = [self.delegate fetchContentViewAtIndex:0];
    contentView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
    [contentView addGestureRecognizer:tapGesture];
    CGRect rightRect = contentView.frame;
    rightRect.origin = CGPointMake(0, 0);
    contentView.frame = rightRect;
    [self.scrollView addSubview:contentView];

    [_scrollView setContentOffset:CGPointMake(0, 0)];
    
}
- (void)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        
        contentView.frame = rightRect;
        [self.scrollView addSubview:contentView];
    }
    if (counter==1) {
        [_scrollView setContentOffset:CGPointMake(0, 0)];
    }
    else {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    
    _pageControl.currentPage = _currentPageIndex;
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex];
    if (self.contentViews == nil) {
        self.contentViews = [@[] mutableCopy];
    }
    [self.contentViews removeAllObjects];
    
    
    if (self.totalPageCount==2) {
        if (previousPageIndex>=0) {
            
            UIImageView *rear = (UIImageView *)[self.delegate fetchContentViewAtIndex: rearPageIndex];
            UIImageView *previous = [[UIImageView alloc]initWithFrame:rear.frame];
            previous.image = rear.image;
            [self.contentViews addObject: (UIView *)previous];
        }
        [self.contentViews addObject: [self.delegate fetchContentViewAtIndex: _currentPageIndex]];
        if (rearPageIndex>=0)
        {
            [self.contentViews addObject: [self.delegate fetchContentViewAtIndex: rearPageIndex]];
        }

    }else{
    
        if (previousPageIndex>=0) {
            
            [self.contentViews addObject: [self.delegate fetchContentViewAtIndex: previousPageIndex]];
        }
        [self.contentViews addObject: [self.delegate fetchContentViewAtIndex: _currentPageIndex]];
        if (rearPageIndex>=0)
        {
            [self.contentViews  addObject: [self.delegate fetchContentViewAtIndex: rearPageIndex]];
        }
        
    }
    self.roundLabel.text=[NSString stringWithFormat:@"%ld/%ld",self.currentPageIndex+1,(long)self.totalPageCount];
   

}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
    
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.animationTimer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.totalPageCount!=1) {
        int contentOffsetX = scrollView.contentOffset.x;
        
        if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
            [self configContentViews];
        }
        if(contentOffsetX <= 0) {
            self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
            [self configContentViews];
        }
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tap{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(contentViewDidTap:)]) {
        [self.delegate contentViewDidTap:[NSNumber numberWithInteger:self.currentPageIndex]];
    }
}

//-(void)dealloc{
//    
//    [_animationTimer invalidate];
//    _animationTimer = nil;
//   
//}
@end
