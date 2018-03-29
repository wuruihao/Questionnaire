//
//  CustomTabBarController.m
//  UITabarButtonAnimation
//
//  Created by fc_curry on 2017/5/17.
//  Copyright © 2017年 fc_curry. All rights reserved.
//

#import "CustomTabBarController.h"

@interface CustomTabBarController ()
{
    NSInteger _currentIndex;
}
@end

#define BarTitleColor [UIColor colorWithHex:0xbfbfbf alpha:1]
#define BarTitleSelColor [UIColor colorWithHex:0x459DF5 alpha:1]

@implementation CustomTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBar.translucent = NO;
        self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor colorWithHex:0xFFFFFF alpha:0.5]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.tintColor = BarTitleSelColor;
}
- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}
//初始化布局
- (void)setupView{
    
    {
        RootController *controller = [[RootController alloc] init];
        ETNavigationController *navi = [[ETNavigationController alloc]initWithRootViewController:controller];
        navi.tag = 0;
        navi.navigationBarHidden = YES;
        navi.tabBarItem = [self tabBarItemWithImgName:@"tab_home" Title:@"问卷大厅"];
        [self addChildViewController:navi];
    }
    {
        StatisticalController *controller = [[StatisticalController alloc] init];
        ETNavigationController *navi = [[ETNavigationController alloc]initWithRootViewController:controller];
        navi.tag = 1;
        navi.navigationBarHidden = YES;
        navi.tabBarItem = [self tabBarItemWithImgName:@"tab_all" Title:@"问卷分类"];
        [self addChildViewController:navi];
    }
    {
        MemberController *controller = [[MemberController alloc] init];
        ETNavigationController *navi = [[ETNavigationController alloc]initWithRootViewController:controller];
        navi.tag = 2;
        navi.navigationBarHidden = YES;
        navi.tabBarItem = [self tabBarItemWithImgName:@"tab_member" Title:@"个人中心"];
        [self addChildViewController:navi];
    }
    self.selectedIndex = 0;
}

//设置背景图片
- (void)setupTabBarBackgroundImage {
    
    UIImageView *dlineImgv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 49)];
    dlineImgv.image = GRBackItemImage;
    dlineImgv.contentMode = UIViewContentModeScaleToFill;
    [self.tabBar addSubview:dlineImgv];
        
}

#pragma mark -  ****************TabbarItem设置**********************
- (UITabBarItem *)tabBarItemWithImgName:(NSString *)imgName Title:(NSString *)title{
    
    UIColor *textColor = BarTitleColor;
    UIColor *textSelectedColor = BarTitleSelColor;
    UIImage *tabImg = [UIImage imageBundleNamed:[NSString stringWithFormat:@"%@.png",imgName]];
    UIImage *tabSelectedImg= [UIImage imageBundleNamed:[NSString stringWithFormat:@"%@_sel.png",imgName]];
    UITabBarItem *tabItem = [[UITabBarItem alloc]initWithTitle:title
                                                         image:[self getTabBarItemImage:tabImg]
                                                 selectedImage:[self getTabBarItemImage:tabSelectedImg]];
    
    [tabItem setTitlePositionAdjustment:UIOffsetMake(0, -2.0f)];
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor,NSFontAttributeName:[UIFont fontWithName:TextFont size:kSize(11)]} forState:UIControlStateNormal];
    [tabItem setTitleTextAttributes:@{NSForegroundColorAttributeName:textSelectedColor,NSFontAttributeName:[UIFont fontWithName:TextFont size:kSize(11)]} forState:UIControlStateSelected];
    return tabItem;
}
- (UIImage *)getTabBarItemImage:(UIImage *)image{
    
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    return image;
}

- (void)selectedItemWithIndex:(NSInteger)selectIndex{
    
    UITabBarItem *item = [self.tabBar.items objectAtIndex:selectIndex];
    for (UITabBarItem *other in self.tabBar.items) {
        if (![other isEqual:item]) {
            
            [other setTitleTextAttributes:@{NSForegroundColorAttributeName:BarTitleColor,NSFontAttributeName:[UIFont fontWithName:TextFont size:kSize(12)]}
                                 forState:UIControlStateNormal];
        }else{
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName:BarTitleSelColor,NSFontAttributeName:[UIFont fontWithName:TextFont size:kSize(12)]}
                                forState:UIControlStateNormal];
        }
    }
}

- (void)selectedControllerWithIndex:(NSInteger)selectIndex{
    
    [self selectedItemWithIndex:selectIndex];
    
    [self setSelectedIndex:selectIndex];
}

@end
