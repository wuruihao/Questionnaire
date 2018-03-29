//
//  PhotoEditViewController.m
//  JiBu
//
//  Created by Administrator on 16/4/15.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "BackEditViewController.h"
#import "AppDelegate.h"

#define BrcodeH ceil(kScreenHeight*0.7) //扫描框大小
#define BrcodeW ceil(kScreenWidth*0.7) //扫描框大小
#define BrcodeX ceil(kScreenWidth*0.15)  //扫描框x位置
#define BrcodeY ceil((kScreenHeight*0.3)*.48) //扫描框y位置

@interface BackEditViewController ()<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong)UIImageView *imagePanel;
@property (nonatomic, strong)UIPinchGestureRecognizer *pinchRecognizer;
@property (nonatomic, strong)UIPanGestureRecognizer   *panRecognizer;
@property (weak, nonatomic) IBOutlet UIView *cotrolView;

@end

@implementation BackEditViewController{
    
    CGFloat _lastScale;
    CGFloat _firstX;
    CGFloat _firstY;
}

- (void)viewDidLoad {
   
    [super viewDidLoad];
   
    self.imagePanel.image = [_upImgs firstObject];
    [self setupCut];
    [self.view bringSubviewToFront:_cotrolView];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (IBAction)cancelAction:(UIButton *)sender {
    
      [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)cutAction:(id)sender {
    
    CGFloat scale = self.imagePanel.image.size.height/self.imagePanel.height;
    CGFloat cropW = scale*BrcodeW;
    CGFloat cropH = scale*BrcodeH;

    CGFloat cropX = -(BrcodeX - self.imagePanel.left)*scale;
    CGFloat cropY = -(BrcodeY - self.imagePanel.top)*scale;
    
    if (cropX>0) {
        cropX = 0.0;
    }
    if (cropY>0) {
        cropY = 0.0;
    }
    
    @weakify(self);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *cropImg = [weak_self.imagePanel.image crop:CGRectMake(cropX, cropY, cropW, cropH)];
        NSString *type = [_upImgs lastObject];
        NSArray *newUp = @[cropImg,type];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weak_self.delegate&&[weak_self.delegate respondsToSelector:@selector(completedSelectImage:)]) {
                [weak_self.delegate completedSelectImage:newUp];
            }
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

#pragma  mark - ***********Cut Main Method***********
/* 图片 控件 */
- (UIImageView *)imagePanel{
    if(!_imagePanel){
        _imagePanel = [UIImageView new];
        _imagePanel.contentMode = UIViewContentModeScaleAspectFit;
        _imagePanel.backgroundColor = [UIColor redColor];
    }
    [self.view insertSubview:_imagePanel atIndex:0];
    return _imagePanel;
}

- (void)setupCut{

    [self fixTheCropFrameOrigin:YES];

    //最上部view
    UIView* upView = [ETUIUtil drawViewWithFrame:CGRectMake(0, 0, kScreenWidth, BrcodeY) BackgroundColor:MarkBackColor];
    [self.view addSubview:upView];
    
    //左侧的view
    UIView *leftView = [ETUIUtil drawViewWithFrame:CGRectMake(0, BrcodeY, BrcodeX, BrcodeH) BackgroundColor:MarkBackColor];
    [self.view addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [ETUIUtil drawViewWithFrame:CGRectMake(BrcodeX+BrcodeW, BrcodeY, BrcodeX, BrcodeH) BackgroundColor:MarkBackColor];
    [self.view addSubview:rightView];
    
    //底部view
    UIView *downView = [ETUIUtil drawViewWithFrame:CGRectMake(0, BrcodeY+BrcodeH, kScreenWidth, kScreenHeight - (BrcodeY+BrcodeH)) BackgroundColor:MarkBackColor];
    [self.view addSubview:downView];
    
   //推荐趣处禁止缩放
    if (self.isScale) {
        
        _pinchRecognizer = nil;
        [self.view removeGestureRecognizer:_pinchRecognizer];
        
    }else{
        
        _pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
        [self.view addGestureRecognizer:_pinchRecognizer];
    
    }
   
    
    _panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [_panRecognizer setMinimumNumberOfTouches:1];
    [_panRecognizer setMaximumNumberOfTouches:3];
    [self.view addGestureRecognizer:_panRecognizer];
}

// 缩放
- (void)scale:(id)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan||[(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged){
        CGFloat scale = 0.0;
        if (_lastScale>0) {
            scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
        }else{
            scale = [(UIPinchGestureRecognizer*)sender scale];
        }
        
        CGAffineTransform currentTransform = self.imagePanel.transform;
        CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
        
        [self.imagePanel setTransform:newTransform];
        
        if (newTransform.a>=1) {
            [self.imagePanel setTransform:newTransform];
        }else{
            [self.imagePanel setTransform:CGAffineTransformIdentity];
        }
        
        //大小变化但不可移出
        [self fixTheCropFrameOrigin:NO];
        _lastScale = [(UIPinchGestureRecognizer*)sender scale];
        
    }
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded){
        _lastScale = 1.0;
        return;
    }
}

// 移动
- (void)move:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.view];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [self.imagePanel center].x;
        _firstY = [self.imagePanel center].y;
    }
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateChanged){
        
        translatedPoint = CGPointMake(_firstX + translatedPoint.x, _firstY + translatedPoint.y);
        
        //位置变化但不可移出
        if (self.imagePanel.width*.5 + BrcodeX<translatedPoint.x) {
            translatedPoint = CGPointMake(self.imagePanel.width*.5 + BrcodeX, translatedPoint.y);
        }
        if(self.imagePanel.height*.5 + BrcodeY<translatedPoint.y){
            translatedPoint = CGPointMake(translatedPoint.x, self.imagePanel.height*.5 + BrcodeY);
        }
        
        if (translatedPoint.x + self.imagePanel.width*.5<BrcodeX + BrcodeW) {
            
            translatedPoint = CGPointMake((BrcodeX + BrcodeW - self.imagePanel.width*.5), translatedPoint.y);
        }
        
        if(translatedPoint.y + self.imagePanel.height*.5<BrcodeH + BrcodeY){
            translatedPoint = CGPointMake(translatedPoint.x, (BrcodeY + BrcodeH - self.imagePanel.height*.5));
        }
        
        [self.imagePanel setCenter:translatedPoint];
        
    }
}

- (void)fixTheCropFrameOrigin:(BOOL)origin{
    
    if (origin) {
        
        CGSize imgeSize = _imagePanel.image.size;
        //起始位置
        if(imgeSize.height/imgeSize.width>(kScreenHeight/kScreenWidth)){
            _imagePanel.width = BrcodeW;
            _imagePanel.height = (BrcodeW*imgeSize.height)/imgeSize.width;

        }else{
            _imagePanel.height = BrcodeH;
            _imagePanel.width = BrcodeH*imgeSize.width/imgeSize.height;
        }
        _imagePanel.center = CGPointMake(BrcodeX+BrcodeW*.5, BrcodeY+BrcodeH*.5);
    }else{
        
        //位置变化但不可移出
        if (self.imagePanel.left>BrcodeX) {
            self.imagePanel.left = BrcodeX;
        }
        
        if(self.imagePanel.top> BrcodeY){
            self.imagePanel.top = BrcodeY;
        }
        
        if (self.imagePanel.right<BrcodeX + BrcodeW) {
            self.imagePanel.right = BrcodeX + BrcodeW;
        }
        
        if(self.imagePanel.bottom<BrcodeH + BrcodeY){
            self.imagePanel.bottom = BrcodeH + BrcodeY;
        }
    }
}

- (void)dealloc{
    
    _imagePanel.image = nil;
    [_imagePanel removeFromSuperview];
    _imagePanel = nil;
    _pinchRecognizer = nil;
    _panRecognizer = nil;
}

@end

