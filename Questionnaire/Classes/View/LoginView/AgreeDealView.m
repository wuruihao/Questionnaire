//
//  AgreeDealView.m
//  Questionnaire
//
//  Created by Robert on 2018/3/16.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "AgreeDealView.h"

@interface AgreeDealView ()

@property (strong, nonatomic) UIWebView *webView;


@end

@implementation AgreeDealView

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.backgroundColor = [UIColor clearColor];

    self.webView = [[UIWebView alloc] initWithFrame: CGRectMake(0, kScreenWidth*0.035, self.width, self.height-kScreenWidth*0.035)];
    self.webView.scalesPageToFit = YES;
    self.webView.backgroundColor = [UIColor whiteColor];
    
    [self.webView.layer setBorderWidth:1];
    [self.webView.layer setCornerRadius:10];
    [self.webView.layer setMasksToBounds:YES];
    [self.webView.layer setBorderColor: [UIColor whiteColor].CGColor];
    [self addSubview:self.webView];
    [self loadLocalPage:self.webView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(self.width-kScreenWidth*0.035, 0, kScreenWidth*0.07, kScreenWidth*0.07);
    [backButton setImage:[UIImage imageBundleNamed:@"login_close.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
}

- (void)backAction{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(backRegisterView)]) {
        [self.delegate backRegisterView];
    }
}

/**
 加载本地HTML5
 */
- (void)loadLocalPage:(UIWebView *)webView{
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"policy.html" ofType:nil];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //加载图片
    NSString *path = [[[NSBundle mainBundle]bundlePath] stringByAppendingPathComponent:@"policy.html"];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    [webView loadHTMLString:html baseURL:baseURL];
}

@end
