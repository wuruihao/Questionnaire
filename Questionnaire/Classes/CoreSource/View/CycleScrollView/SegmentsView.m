//
//  SegmentsView.m
//  038Lottery
//
//  Created by ruihao on 2017/7/24.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "SegmentsView.h"

@interface SegmentsView () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *slider;
@property (nonatomic, weak) UIScrollView *topBarScroll;
@property (nonatomic, assign) CGFloat btnWidth;
@property (nonatomic, strong) NSArray *barArrays;
@property (nonatomic, strong) NSMutableArray *barItems;

@end

@implementation SegmentsView

- (instancetype)initWithFrame:(CGRect)frame barTitle:(NSArray *)barTitle{
    
    if(self = [super initWithFrame:frame]){
        
        _barArrays = barTitle;
        
        //添加上面的导航条
        [self addTopBar];
        //添加滑块
        [self addSliderView];
    }
    return self;
}
- (void)addSliderView{
    
    if(self.barArrays.count == 0) return;
    
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(0,41,self.btnWidth, 3)];
    slider.backgroundColor = self.sliderColor;
    [self.topBarScroll addSubview:slider];
    self.slider = slider;
}
- (void)addTopBar{
    
    if(self.barArrays.count == 0) return;
    NSUInteger count = self.barArrays.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height)];
    scrollView.backgroundColor = self.topBarColor;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    self.topBarScroll = scrollView;
    self.topBarScroll.delegate = self;
    [self addSubview:self.topBarScroll];
    
    if(count <= 5){
        self.btnWidth = kScreenWidth / count;
    }else{
        self.btnWidth = kScreenWidth / 5.0;
    }
    //添加button
    for (int i = 0; i < count; i++){
        NSString *title = self.barArrays[i];
        UIButton *item = [[UIButton alloc]initWithFrame:CGRectMake(i*self.btnWidth, 0, self.btnWidth, self.topBarScroll.height)];
        item.tag = i+1;
        item.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(15)];
        [item setTitleColor:self.btnTextNomalColor forState:UIControlStateNormal];
        [item setTitleColor:self.btnTextSeletedColor forState:UIControlStateSelected];
        [item setTitle:title forState:UIControlStateNormal];
        [item addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.barItems addObject:item];
        [self.topBarScroll addSubview:item];
        if(i == 0){
            item.selected = YES;
        }
    }
    self.topBarScroll.contentSize = CGSizeMake(self.btnWidth *count, 0);
}
- (void)click:(UIButton *)sender{
    
    for (UIButton *item in self.barItems) {
        if (item == sender) {
            sender.selected = YES;
        }else{
            item.selected = NO;
        }
    }
    self.slider.left = sender.left;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickSegmentsItem:)]) {
        [self.delegate clickSegmentsItem:sender.tag];
    }
    
}
//判断是否切换导航条按钮的状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}
- (UIColor *)sliderColor{
    
    if(_sliderColor == nil){
        _sliderColor = COLOR_HEX(0xFA6E00);
    }
    return  _sliderColor;
}
- (UIColor *)btnTextNomalColor{
    
    if(_btnTextNomalColor == nil){
        _btnTextNomalColor = COLOR_HEX(0x4c4c4c);;
    }
    return _btnTextNomalColor;
}
- (UIColor *)btnTextSeletedColor{
    
    if(_btnTextSeletedColor == nil){
        _btnTextSeletedColor = COLOR_HEX(0xFA6E00);
    }
    return _btnTextSeletedColor;
}
- (UIColor *)topBarColor{
    
    if(_topBarColor == nil){
        _topBarColor = [UIColor clearColor];
    }
    return _topBarColor;
}
- (NSMutableArray *)barItems{
    
    if (!_barItems) {
        _barItems = [NSMutableArray array];
    }
    return _barItems;
}

@end
