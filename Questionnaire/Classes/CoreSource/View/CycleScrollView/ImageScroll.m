//
//  ImageScroll.m
//  Carcool
//
//  Created by Enjoytouch on 15/8/11.
//  Copyright (c) 2015年 EnjoyTouch. All rights reserved.
//

#import "ImageScroll.h"

@implementation ImageScroll

- (id)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.width = floor(self.width);
        self.mainScorllView = [[CycleScrollView alloc] initWithFrame:frame];
        [self.mainScorllView initWithAnimationDuration:3];
        self.mainScorllView.delegate = self;
        self.mainScorllView.backgroundColor = [UIColor clearColor];
        self.mainScorllView.scrollView.scrollEnabled = NO;
        [self addSubview:self.mainScorllView];
        
        self.isLoad = YES;
    }
    return self;
}

- (void)setContentData:(id)data{
    
    self.mainScorllView.scrollView.scrollEnabled = YES;
    self.dataSource = data;
    if (self.dataSource.count>0){
        
        for (UIImageView *sub in _viewsArray) {
            sub.image = nil;
            [sub removeFromSuperview];
        }
        [_viewsArray removeAllObjects];
        
        self.defaultImg.hidden = YES;
        
        _maxCount = _maxCount > 0 ? _maxCount : (int)self.dataSource.count;
        int loop =  _maxCount;
        
        for (int i = 0; i < loop; i++) {
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.bounds];
            imageView.contentMode = UIViewContentModeScaleToFill;
            imageView.clipsToBounds = YES;
            
            [self.viewsArray addObject:imageView];
            NSString *str = [self.dataSource objectSafetyAtIndex:i];
            if (_isLoad){
                if (![ETRegularUtil isEmptyString:str]){
                    [imageView sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageBundleNamed:@"home_default_banner.png"]];
                }else{
                    [imageView setImage:[UIImage imageBundleNamed:@"home_default_banner.png"]];
                }
             //测试部分
            }else{
                imageView.image = [UIImage imageNamed:str];
            }
        }
        [self.mainScorllView setTotalPagesCount:self.dataSource.count];
        
    }else{
        [self.mainScorllView setTotalPagesCount:0];
    }
}

- (UIView *)fetchContentViewAtIndex:(NSInteger)pageIndex{
    
    return [self.viewsArray objectSafetyAtIndex:pageIndex];
}

- (NSInteger)totalPageCount {
    return self.dataSource.count;
}

- (NSMutableArray *)viewsArray {
    if (_viewsArray == nil) {
        _viewsArray = [NSMutableArray array];
    }
    return _viewsArray;
}

- (void)contentViewDidTap:(NSNumber *)index {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(imageScrollDidClick:)]) {
        
        [self.delegate imageScrollDidClick:index];
    }
}

- (void)dealloc{
    
    for (UIImageView *sub in _viewsArray) {
        sub.image = nil;
        [sub removeFromSuperview];
    }
    self.mainScorllView.delegate = nil;
    [self.mainScorllView.animationTimer invalidate];
    [self.mainScorllView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.delegate = nil;
}
@end
