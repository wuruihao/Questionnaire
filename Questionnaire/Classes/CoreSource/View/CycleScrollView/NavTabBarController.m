//
//  NavTabBarController.m
//  038Lottery
//
//  Created by ruihao on 2017/7/24.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#import "NavTabBarController.h"

#define DCScreenW    [UIScreen mainScreen].bounds.size.width
#define DCScreenH    [UIScreen mainScreen].bounds.size.height

@interface NavTabBarController () <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *slider;
@property (nonatomic, weak) UIButton *oldBtn;
@property (nonatomic, weak) UIScrollView *contentView;
@property (nonatomic, weak) UIScrollView *topBar;

@property (nonatomic, assign) CGFloat btnWidth ;
@property (nonatomic, strong) NSArray *viewArrays;

@end

@implementation NavTabBarController

- (UIColor *)sliderColor{
    
    if(_sliderColor == nil){
        _sliderColor = COLOR_HEX(0xdfaf63);
    }
    return  _sliderColor;
}
- (UIColor *)btnTextNomalColor{
    
    if(_btnTextNomalColor == nil){
        _btnTextNomalColor = [UIColor whiteColor];
    }
    return _btnTextNomalColor;
}
- (UIColor *)btnTextSeletedColor{
    
    if(_btnTextSeletedColor == nil){
        _btnTextSeletedColor = COLOR_HEX(0xdfaf63);;
    }
    return _btnTextSeletedColor;
}
- (UIColor *)topBarColor{
    
    if(_topBarColor == nil){
        _topBarColor = [UIColor clearColor];
    }
    return _topBarColor;
}
- (instancetype)initWithSubViewControllers:(NSArray *)subViewControllers{
    
    if(self = [super init]){
        
        _viewArrays = subViewControllers;
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //添加上面的导航条
    [self addTopBar];
    
    //添加子控制器
    [self addVCView];
    
    //添加滑块
    [self addSliderView];
    
    
}
- (void)addSliderView{
    
    if(self.viewArrays.count == 0) return;
    
    UIView *slider = [[UIView alloc]initWithFrame:CGRectMake(0,41,self.btnWidth, 3)];
    slider.backgroundColor = self.sliderColor;
    [self.topBar addSubview:slider];
    self.slider = slider;
}
- (void)addTopBar{
    
    if(self.viewArrays.count == 0) return;
    NSUInteger count = self.viewArrays.count;
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, DCScreenW, 44)];
    scrollView.backgroundColor = self.topBarColor;
    self.topBar = scrollView;
    //    self.topBar.bounces = NO;
    [self.view addSubview:self.topBar];
    
    if(count <= 5){
        self.btnWidth = DCScreenW / count;
    }else{
        self.btnWidth = DCScreenW / 5.0;
    }
    //添加button
    for (int i=0; i<count; i++){
        UIViewController *vc = self.viewArrays[i];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*self.btnWidth, 0, self.btnWidth, 44)];
        btn.tag = 10000+i;
        btn.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(16)];
        [btn setTitleColor:self.btnTextNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.btnTextSeletedColor forState:UIControlStateSelected];
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.topBar addSubview:btn];
        if(i == 0)
        {
            btn.selected = YES;
            //默认one文字放大
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.oldBtn = btn;
        }
    }
    self.topBar.contentSize = CGSizeMake(self.btnWidth *count, 0);
}
- (void)addVCView{
    
    UIScrollView *contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0+44, DCScreenW, DCScreenH -44)];
    self.contentView = contentView;
    self.contentView.bounces = NO;
    contentView.delegate = self;
    contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:contentView];
    
    NSUInteger count = self.viewArrays.count;
    for (int i=0; i<count; i++) {
        UIViewController *vc = self.viewArrays[i];
        [self addChildViewController:vc];
        vc.view.frame = CGRectMake(i*DCScreenW, 0, DCScreenW, DCScreenH -44);
        [contentView addSubview:vc.view];
    }
    contentView.contentSize = CGSizeMake(count*DCScreenW, DCScreenH-44);
    contentView.pagingEnabled = YES;
}
- (void)click:(UIButton *)sender{
    
    if(sender.selected) return;
    self.oldBtn.selected = NO;
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.contentView.contentOffset = CGPointMake((sender.tag - 10000)*DCScreenW, 0);
        sender.transform = CGAffineTransformMakeScale(1.1, 1.1);
    }];
    self.oldBtn.transform = CGAffineTransformIdentity;
    self.oldBtn = sender;
    
    //判断导航条是否需要移动
    CGFloat maxX = CGRectGetMaxX(self.slider.frame);
    if(maxX >=DCScreenW  && sender.tag != self.viewArrays.count + 10000 - 1){
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(maxX - DCScreenW + self.btnWidth, 0);
        }];
    }else if(maxX < DCScreenW){
        [UIView animateWithDuration:0.3 animations:^{
            self.topBar.contentOffset = CGPointMake(0, 0);
        }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //滑动导航条
    self.slider.frame = CGRectMake(scrollView.contentOffset.x / DCScreenW *self.btnWidth , 41, self.btnWidth, 3);
}
//判断是否切换导航条按钮的状态
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGFloat offX =  scrollView.contentOffset.x;
    int tag = (int)(offX /DCScreenW + 0.5) + 10000;
    UIButton *btn = [self.view viewWithTag:tag];
    if(tag != self.oldBtn.tag)
    {
        [self click:btn];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
