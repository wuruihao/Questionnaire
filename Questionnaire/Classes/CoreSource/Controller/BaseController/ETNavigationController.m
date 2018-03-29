//
//  KKNavigationController.m
//  TS
//
//  Created by Coneboy_K on 13-12-2.
//  Copyright (c) 2013年 Coneboy_K. All rights reserved.  MIT
//  WELCOME TO MY BLOG  http://www.coneboy.com
//

#import "ETNavigationController.h"

@interface ETNavigationController (){
    
    CGPoint startTouch;
    
    UIImageView *lastScreenShotView;
    UIView *blackMask;
    
}

@property (nonatomic,retain) UIView *backgroundView;
@property (nonatomic,retain) NSMutableArray *screenShotsList;

@property (nonatomic,assign) BOOL isMoving;

@end

@implementation ETNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
        self.canDragBack = YES;
        [self setNavigationBarHidden:YES];
        
    }
    return self;
}

//支持旋转
- (BOOL)shouldAutorotate{
    
    return NO;
}

////横屏
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
//- (NSUInteger)supportedInterfaceOrientations
//#else
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//#endif
//{
//    if ([self.topViewController isKindOfClass:[PlayRoomController class]]||[self.topViewController isKindOfClass:[BroadcastRoomController class]]) {
//        return [self.topViewController supportedInterfaceOrientations];
//    }else{
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}
////开始的方向 重要
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    if ([self.topViewController isKindOfClass:[PlayRoomController class]]||[self.topViewController isKindOfClass:[BroadcastRoomController class]]) {
//         return [self.topViewController preferredInterfaceOrientationForPresentation];
//    }else{
//        return UIInterfaceOrientationPortrait;
//    }
//}

- (void)dealloc{
    
    self.screenShotsList = nil;
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    //navi bar 属性设置
    [self.navigationBar setBackgroundImage:GRBackItemImage forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil];
    self.navigationBar.translucent = NO;
    
    
    //添加手势
    UIImageView *shadowImageView = [[UIImageView alloc]initWithImage:[UIImage imageBundleNamed:@"leftside_shadow_bg"]];
    shadowImageView.frame = CGRectMake(-10, 0, 10, XNaviHeight);
    [self.view addSubview:shadowImageView];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                                                action:@selector(paningGestureReceive:)];
    [recognizer delaysTouchesBegan];
    recognizer.delegate = self;
    [self.view addGestureRecognizer:recognizer];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    [self.screenShotsList addObject:[self capture]];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated{
    
    [self.screenShotsList removeLastObject];
    [self.navigationController setNavigationBarHidden:YES];
    return [super popViewControllerAnimated:animated];
}

#pragma mark - Utility Methods -

- (UIImage *)capture{
    
    UIImage * img;
    if ([self.visibleViewController isKindOfClass:[RootController class]]) {
        
//        CustomTabBarController *tabVC = [[AppDelegate sharedInstance]tabBarController];
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }else{

        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        
        img = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return img;
}

- (void)moveViewWithX:(float)x{
    
    x = x>kScreenWidth?kScreenWidth:x;
    x = x<0?0:x;
    
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    
    float alpha = 0.4 - (x/800);
    
    blackMask.alpha = alpha;
    
    CGFloat aa = fabs(startBackViewX)/kkBackViewWidth;
    CGFloat y = x*aa;
    
    CGFloat lastScreenShotViewHeight = kkBackViewHeight;
    
    //TODO: FIX self.edgesForExtendedLayout = UIRectEdgeNone  SHOW BUG
    /**
     *  if u use self.edgesForExtendedLayout = UIRectEdgeNone; pls add
     
     if (!iOS7) {
     lastScreenShotViewHeight = lastScreenShotViewHeight - 20;
     }
     *
     */
    [lastScreenShotView setFrame:CGRectMake(startBackViewX+y,
                                            0,
                                            kkBackViewWidth,
                                            lastScreenShotViewHeight)];
    [self.backgroundView removeFromSuperview];
   
    [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];

    
    if (!self.backgroundView.superview) {
        [self.backgroundView removeFromSuperview];
        [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
    }
}



- (BOOL)isBlurryImg:(CGFloat)tmp{
    
    return YES;
}

#pragma mark - Gesture Recognizer -

- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer{
    
    if (self.viewControllers.count <= 1 || !self.canDragBack) return;
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;
        
        if (!self.backgroundView){
            
            CGRect frame = self.view.frame;
            
            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            [self.view.superview insertSubview:self.backgroundView belowSubview:self.view];
            
            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
            blackMask.backgroundColor = [UIColor blackColor];
            [self.backgroundView addSubview:blackMask];
        }
        
        self.backgroundView.hidden = NO;
        
        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
        
        
        UIImage *lastScreenShot = [self.screenShotsList lastObject];
        
        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
        
        startBackViewX = startX;
        [lastScreenShotView setFrame:CGRectMake(startBackViewX,
                                                lastScreenShotView.frame.origin.y,
                                                lastScreenShotView.frame.size.height,
                                                lastScreenShotView.frame.size.width)];
        
        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
        
    }else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        if (touchPoint.x - startTouch.x > 50){
            
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:kScreenWidth];
            } completion:^(BOOL finished) {
                
                [self popViewControllerAnimated:NO];
                CGRect frame = self.view.frame;
                frame.origin.x = 0;
                self.view.frame = frame;
                
                _isMoving = NO;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                _isMoving = NO;
                self.backgroundView.hidden = YES;
            }];
            
        }
        return;
        
    }else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            [self moveViewWithX:0];
        } completion:^(BOOL finished) {
            _isMoving = NO;
            self.backgroundView.hidden = YES;
        }];
        
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if (_canDragBack) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint origin= [pan translationInView:self.view];
        
        return origin.x < 0 ? NO:YES;
    }else{
        return NO;
    }
}


@end



