//
//  UIView+Line.m
//
//
//
//  Copyright © 2015年 cathy. All rights reserved.
//

#import "UIView+Line.h"
#import "AppDelegate.h"

CGFloat const MENU_SLIDE_ANIMATION_DURATION  = 0.15;
enum
{
    kTagForBackgroundView = 2321,
    kTagForToBottomView,
    kTagCustomBackgroundView,
    kTagForToCustomView
};

@implementation UIView (Expense)
//添加旋转动画
- (void)setRotatingAnimation:(BOOL)isClockwise time:(NSInteger)time{
    
    CABasicAnimation *animation =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //默认是顺时针效果，若将fromValue和toValue的值互换，则为逆时针效果
    if (isClockwise == YES) {
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue =  [NSNumber numberWithFloat: M_PI *2];
    }else{
        animation.toValue = [NSNumber numberWithFloat:0.f];
        animation.fromValue =  [NSNumber numberWithFloat: M_PI *2];
    }
    animation.duration  = 3;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = MAXFLOAT;
    //如果这里想设置成一直自旋转，可以设置为MAXFLOAT，否则设置具体的数值则代表执行多少次
    [self.layer addAnimation:animation forKey:@"RotatingAnimation"];
    if (time == 0) {
        return;
    }
    __block NSTimer *stimer = [NSTimer scheduledTimerWithTimeInterval:time repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSLog(@"timer:%f",timer.timeInterval);
        [self removeRotatingAnimation];
        [stimer invalidate];
    }];
}
//移除旋转动画
- (void)removeRotatingAnimation{
    
    [self.layer removeAnimationForKey:@"RotatingAnimation"];

    [UIView dismissCustomViewWithAnimated:YES completion:nil];
}
//跳动的动画
- (void)setJumpupAnimation{
    
    CGFloat duration = 1.5;
    CGFloat height = 5;
    
    CAKeyframeAnimation * animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    CGFloat currentTy = self.transform.ty;
    animation.autoreverses = YES;
    animation.duration = duration;
    animation.values = @[@(currentTy), @(currentTy - height/4), @(currentTy-height/4*2), @(currentTy-height/4*3), @(currentTy - height), @(currentTy-height/4*3), @(currentTy -height/4*2), @(currentTy - height/4), @(currentTy)];
    animation.keyTimes = @[ @(0), @(0.1), @(0.2), @(0.3), @(0.5), @(0.7), @(0.8), @(0.9), @(1) ];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.repeatCount = HUGE_VALF;
    [self.layer addAnimation:animation forKey:@"kViewShakerAnimationKey"];
}
//中间扩散的动画
- (CAEmitterLayer *)setCenterHeartLayerWithFrame:(CGRect)rect{
    
    CAEmitterLayer *centerHeartLayer = [CAEmitterLayer layer];
    centerHeartLayer.emitterShape = kCAEmitterLayerCircle;
    centerHeartLayer.emitterMode = kCAEmitterLayerOutline;
    centerHeartLayer.renderMode = kCAEmitterLayerOldestFirst;
    centerHeartLayer.emitterPosition = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
    centerHeartLayer.emitterSize = rect.size;
    centerHeartLayer.birthRate = 1;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.contents = (__bridge id _Nullable)[UIImage imageNamed:@"icon_bubble_01.png"].CGImage;
    cell.lifetime = 15;
    cell.birthRate = 10;
    cell.scale = 0.1;
    cell.scaleSpeed = -0.02;
    //    cell.alphaSpeed = -1;
    cell.velocity = 10;
    centerHeartLayer.emitterCells = @[cell];
    [self.layer addSublayer:centerHeartLayer];
    return centerHeartLayer;
}


//飘落的动画
- (CAEmitterLayer *)setEmitterLayerWithFrame:(CGRect)rect {
    
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = CGPointMake(rect.origin.x + rect.size.width/2.0, rect.origin.y + rect.size.height/2.0);
    emitter.emitterSize = rect.size;
    emitter.birthRate = 1;
    emitter.renderMode = kCAEmitterLayerOldestFirst;
    emitter.emitterShape = kCAEmitterLayerSphere;
    emitter.emitterMode = kCAEmitterLayerOutline;
    
    CAEmitterCell *cell1 = [CAEmitterCell emitterCell];
    UIImage *flower1 = [UIImage imageNamed:@"icon_bubble_01.png"];
    cell1.contents = (__bridge id _Nullable)(flower1.CGImage);
    //    cell1.emissionLongitude =  0;
    //    cell1.emissionRange = M_PI * 2;
    cell1.scale = 0.1;
    cell1.lifetime = 20;
    cell1.velocity = 20;
    cell1.velocityRange = 5;
    //    cell1.yAcceleration = 5;
    cell1.alphaSpeed = -0.02;
    cell1.spin = M_PI_2;
    cell1.spinRange = M_PI_4/2.0;
    cell1.birthRate = 1;
    
    CAEmitterCell *cell2 = [CAEmitterCell emitterCell];
    UIImage *flower2 = [UIImage imageNamed:@"icon_bubble_01.png"];
    cell2.contents = (__bridge id _Nullable)(flower2.CGImage);
    //    cell2.emissionLongitude = 0;
    //    cell2.emissionRange = M_PI * 2;
    cell2.scale = 0.1;
    cell2.lifetime = 20;
    cell2.velocity = 20;
    cell2.velocityRange = 5;
    //    cell2.yAcceleration = 5;
    cell2.alphaSpeed = -0.02;
    cell2.spin = M_PI_2;
    cell2.spinRange = M_PI_4/2.0;
    cell2.birthRate = 1;
    
    emitter.emitterCells = @[cell1, cell2];
    [self.layer addSublayer:emitter];
    
    return emitter;
}
//变大变小的动画
- (void)getBiggerAndSmaller:(BOOL)repeat{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.duration = 0.5;
    animation.autoreverses = YES;
    if (repeat) {
        animation.repeatCount = HUGE_VALF;
    }else{
        animation.repeatCount = 1;
    }
    animation.fromValue = [NSNumber numberWithFloat:1];
    animation.toValue = [NSNumber numberWithFloat:1.3];
    [self.layer addAnimation:animation forKey:nil];
}

//晃动的动画
- (void)addShakeAnimation:(BOOL)repeat{
    
    CAKeyframeAnimation *keyFrame = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyFrame.duration = 0.5;
    keyFrame.autoreverses = YES;
    if (repeat) {
        keyFrame.repeatCount = HUGE_VALF;
    }else{
        keyFrame.repeatCount = 1;
    }
    CGFloat x = self.layer.position.x;
    keyFrame.values = @[@(x - 3), @(x - 3), @(x + 2), @(x - 2), @(x + 1), @(x - 1), @(x + 3), @(x - 3)];
    [self.layer addAnimation:keyFrame forKey:@"shake"];
}
//移除晃动的动画
- (void)removeShakeAnimation{
    
    [self.layer removeAnimationForKey:@"shake"];
}
//加返回动画
+ (void)setPopAnimation:(UIView *)view{
    
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"pageUnCurl";
//    transition.subtype = @"fromRight";
    transition.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:transition forKey:nil];
}

//加跳转动画
+ (void)setPushAnimation:(UIView *)view{
    
    //@"cube" @"moveIn" @"reveal" @"fade"(default) @"pageCurl" @"pageUnCurl" @"suckEffect" @"rippleEffect" @"oglFlip"
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = @"pageCurl";
//    transition.subtype = @"fromLeft";
    transition.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:transition forKey:nil];
}
//自定义弹出画面
+ (void)pushCustomView:(UIView *)view animation:(BOOL)animated openTap:(BOOL)openTap completion:(void(^)(void))completion{
    
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    CGFloat kSCWIDTH = [[UIScreen mainScreen] bounds].size.width;
    CGFloat kSCHEIGHT = [[UIScreen mainScreen] bounds].size.height;
    
    if (animated) {
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.5;
        transition.type = @"rippleEffect";
        transition.subtype = @"fromTop";
        transition.fillMode = kCAFillModeForwards;
        [window.layer addAnimation:transition forKey:nil];
    }
    
    UIView *backgroundView = [window viewWithTag:kTagCustomBackgroundView];
    if (backgroundView == nil) {
        backgroundView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCWIDTH, kSCHEIGHT)];
        [backgroundView setBackgroundColor:BLACKCOLORA(0.5)];
        
        if (openTap == YES) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissCustomView:)];
            [backgroundView addGestureRecognizer:tapGesture];
        }
        
        backgroundView.tag = kTagCustomBackgroundView;
        [window addSubview:backgroundView];
    }
    
    if ([window viewWithTag:kTagForToCustomView] == nil) {
        CGRect bottomRect = view.frame;
        bottomRect.origin.y = (kSCHEIGHT -  bottomRect.size.height )  / 2;
        bottomRect.origin.x = (kSCWIDTH -  bottomRect.size.width )  / 2;
        [view setFrame:bottomRect];
        
        [view setTag:kTagForToCustomView];
        [window addSubview:view];
    }
}

+ (void)dismissCustomView:(UITapGestureRecognizer *)gesture{
    
    [UIView dismissCustomViewWithAnimated:YES completion:nil];
}
//自定义消失
+ (void)dismissCustomViewWithAnimated:(BOOL)animated completion:(void(^)(void))completion{
    
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    
    UIView *view = [window viewWithTag:kTagForToCustomView];
    
    if (view) {
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if (animated) {
                CATransition *transition = [CATransition animation];
                transition.duration = 0.5;
                transition.type = @"rippleEffect";
                transition.subtype = @"fromBottom";
                transition.fillMode = kCAFillModeForwards;
                [window.layer addAnimation:transition forKey:nil];
            }
        } completion:^(BOOL finished) {
            [[window viewWithTag:kTagCustomBackgroundView] removeFromSuperview];
            [view removeFromSuperview];
        }];
    }
}
//加毛玻璃
+ (void)setBlurEffectView:(UIView *)view frame:(CGRect)frame{
    
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = frame;
    //    effectView.backgroundColor = BLACKCOLOR;
    [view addSubview:effectView];
}
//加背景
+ (void)setBackView:(UIView *)view frame:(CGRect)frame{
    
    UIView *backView = [[UIView alloc]initWithFrame:frame];
    backView.backgroundColor = BLACKCOLOR;
    [view addSubview:backView];
}
//加阴影
+ (void)setShadowLayer:(UIView *)view{
    
    //加阴影
    view.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
    view.layer.shadowOffset = CGSizeMake(0,4);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = 0.5;//阴影透明度，默认0
    view.layer.shadowRadius = 3;//阴影半径，默认3
}

- (void)addLineWithCorner:(CGFloat)corner{
    
    [self.layer setBorderWidth:0.5];
    [self.layer setCornerRadius:corner];
    [self.layer setMasksToBounds:YES];
    [self.layer setBorderColor: COLOR_HEX(0xbfbfbf).CGColor];
}

// 从底部弹出画面
+ (void)popBottomView:(UIView *)bottomView animation:(BOOL)animated
{
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    CGFloat kSCWIDTH = [[UIScreen mainScreen] bounds].size.width;
    CGFloat kSCHEIGHT = [[UIScreen mainScreen] bounds].size.height;
    
    //    toView.topNavigationController = self;
    UIView *backgroundView = [window viewWithTag:kTagForBackgroundView];
    if (backgroundView == nil) {
        backgroundView =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, kSCWIDTH, kSCHEIGHT)];
        [backgroundView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissBottomView:)];
        [backgroundView addGestureRecognizer:tapGesture];
        backgroundView.tag = kTagForBackgroundView;
        [window addSubview:backgroundView];
    }
    
    if ([window viewWithTag:kTagForToBottomView] == nil) {
        CGRect bottomRect = bottomView.frame;
        bottomRect.origin.y = kSCHEIGHT;
        bottomRect.origin.x = (kSCWIDTH -  bottomRect.size.width )  / 2;
        [bottomView setFrame:bottomRect];
        
        [bottomView setTag:kTagForToBottomView];
        [window addSubview:bottomView];
    }
    
    
    
    CGFloat time = 0;
    if (animated) {
        time = MENU_SLIDE_ANIMATION_DURATION;
    }
    
    [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        CGRect bottomRect = bottomView.frame;
        bottomRect.origin.y = kSCHEIGHT - bottomRect.size.height;
        [bottomView setFrame:bottomRect];
        
    } completion:^(BOOL finished) {
        
    }];
}

// 隐藏
+ (void)dismissBottomViewWithAnimated:(BOOL)animated
{
    CGFloat time = 0;
    if (animated) {
        time = MENU_SLIDE_ANIMATION_DURATION;
    }
    
    AppDelegate *delegate  = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIWindow *window = delegate.window;
    
    UIView *view = [window viewWithTag:kTagForToBottomView];
    
    CGFloat kSCHEIGHT = [[UIScreen mainScreen] bounds].size.height;
    if (view) {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            CGRect bottomRect = view.frame;
            bottomRect.origin.y = kSCHEIGHT;
            [view setFrame:bottomRect];
            
        } completion:^(BOOL finished) {
            [[window viewWithTag:kTagForBackgroundView] removeFromSuperview];
            [view removeFromSuperview];
        }];
    }
}

+ (void)dismissBottomView:(UITapGestureRecognizer *)gesture
{
    [UIView dismissBottomViewWithAnimated:YES];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += [view left];
    }
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)ttScreenY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += [view top];
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewX {
    CGFloat x = 0;
    for (UIView* view = self; view; view = view.superview) {
        x += [view left];
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            x -= scrollView.contentOffset.x;
        }
    }
    
    return x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)screenViewY {
    CGFloat y = 0;
    for (UIView* view = self; view; view = view.superview) {
        y += [view top];
        
        if ([view isKindOfClass:[UIScrollView class]]) {
            UIScrollView* scrollView = (UIScrollView*)view;
            y -= scrollView.contentOffset.y;
        }
    }
    return y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGRect)screenFrame {
    return CGRectMake([self screenViewX], [self screenViewY], [self width], [self height]);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)origin {
    return self.frame.origin;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)size {
    return self.frame.size;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView* child in self.subviews) {
        UIView* it = [child descendantOrSelfWithClass:cls];
        if (it)
            return it;
    }
    
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)removeAllSubviews {
    while (self.subviews.count) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGPoint)offsetFromView:(UIView*)otherView {
    CGFloat x = 0, y = 0;
    for (UIView* view = self; view && view != otherView; view = view.superview) {
        x += [view left];
        y += [view top];
    }
    return CGPointMake(x, y);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIViewController*)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
+ (instancetype)viewFromNib {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil][0];
}
- (void)cleanSawtooth {
    self.layer.borderWidth = 2;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    
    self.layer.shouldRasterize = YES;
    
    for (UIView *child in self.subviews) {
        [child cleanSawtooth];
    }
}

@end
