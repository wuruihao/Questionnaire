//
//  CoreHeader.h
//  GlobalNovel
//
//  Created by ruihao on 2017/7/3.
//  Copyright © 2017年 gv576m@163.com. All rights reserved.
//

#ifndef CoreHeader_h
#define CoreHeader_h

#define kLocalString(string) NSLocalizedString(string, nil)

#define MAINCOLOR [UIColor colorWithHex:0xff8706 alpha:0.5]
#define MAINCOLORA(a) [UIColor colorWithHex:0xff8706 alpha:a]
#define BLACKCOLOR [UIColor colorWithHex:0x000000 alpha:0.3]
#define BLACKCOLORA(a) [UIColor colorWithHex:0x000000 alpha:a]

//系统头文件
#import <MJRefresh/MJRefresh.h>
#import "UIImageView+WebCache.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import <math.h>
#import "AppDelegate.h"

//分类
#import "NSArray+Safety.h"
#import "NSMutableArray+Custom.h"
#import "NSObject+CurrentController.h"
#import "NSString+Custom.h"
#import "NSString+RectString.h"
#import "UIButton+Custom.h"
#import "UIColor+Custom.h"
#import "UIImage+Custom.h"
#import "UIImage+FixOrientation.h"
#import "UIImageView+ScrollBar.h"
#import "UILabel+Custom.h"
#import "UIView+Line.h"
#import "UIViewController+mainAction.h"

//ObjectMapping
#import "ObjectMapping.h"
#import "ObjectMappingLoader.h"
#import "ObjectMappingEntity.h"

//BaseData
#import "CoreDataManager.h"

//工具
#import "ETUIUtil.h"
#import "ETDateUtil.h"
#import "FilePathUtil.h"
#import "ETRegularUtil.h"
#import "ETDataTransUtil.h"

//Controller
#import "CustomTabBarController.h"
#import "ETNavigationController.h"
#import "ShowWaterfallLayout.h"
#import "AlbumController.h"
#import "BackEditViewController.h"
#import "OnePhotoController.h"
#import "PhotoEditViewController.h"
#import "PreviewController.h"
#import "ETRefreshTableViewController.h"

//View
#import "CenterModel.h"

#import "ETPhotoUtil.h"
#import "PhotoItem.h"
#import "PhotoSampleItem.h"
#import "PreviewItem.h"

#import "ImageScroll.h"

#import "BlurView.h"
#import "CommonAlert.h"
#import "CommonSheet.h"
#import "EmptyView.h"
#import "ETMessageView.h"
#import "WJTextView.h"

#import "BFDatePicker.h"
#import "BFPickerView.h"
#import "NSDate+TKCategory.h"


#define kStatusBarAndNaviBarH 64

//返回数据成功
#define successFlag @"0"

#define GRBackItemImage [UIImage imageBundleNamed:@"bar_background.png"]

#define COLOR_HEX(value) [UIColor colorWithHex:value alpha:1]

#define MarkBackColor [UIColor colorWithHex:0x000000 alpha:0.5]
#define TextColor [UIColor colorWithHex:0x747474 alpha:1]
#define MainColor [UIColor whiteColor]
#define BlackColor [UIColor blackColor]

// 取消粘贴第一响应
#define KWBCancelPaste @"textlabelcancelpaseter"

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define iPhone4 ([[UIScreen mainScreen] bounds].size.height == 480 || [[UIScreen mainScreen] bounds].size.height == 960)

#define iPhone5 ([[UIScreen mainScreen] bounds].size.height == 568 || [[UIScreen mainScreen] bounds].size.height == 1136)

#define iPhoneX ((kScreenHeight == 812.0f)? YES : NO)
#define XNaviHeight (iPhoneX ? 88 : 64)
#define XTabBarHeight (iPhoneX ? 83 : 49)
#define XSafeHeight (iPhoneX ? 34 : 0)

#define WHAspectRatio 131/174
#define HWAspectRatio 174/131

#define TextFont @"stkaiti"
#define kFitHeight(value) (iPhone4? (kScreenHeight/960*value):(kScreenHeight/1334*value))
#define kFitWidth(value) (iPhone4? (kScreenWidth/750*value):(kScreenWidth/750*value))

#define kBoldFitSize(size) [UIFont boldSystemFontOfSize:size*kScreenHeight/667]
#define kFontSize(value)   [UIFont systemFontOfSize:kScreenHeight/667*value]
#define kFontSize(value)   [UIFont systemFontOfSize:kScreenHeight/667*value]
#define kSize(value) (kScreenHeight/667*value)

//UIFontWeightUltraLight  - 超细字体
//UIFontWeightThin  - 纤细字体
//UIFontWeightLight  - 亮字体
//UIFontWeightRegular  - 常规字体
//UIFontWeightMedium  - 介于Regular和Semibold之间
//UIFontWeightSemibold  - 半粗字体
//UIFontWeightBold  - 加粗字体
//UIFontWeightHeavy  - 介于Bold和Black之间
//UIFontWeightBlack  - 最粗字体(理解)

#define FontL(s)             [UIFont systemFontOfSize:s weight:UIFontWeightLight]
#define FontR(s)             [UIFont systemFontOfSize:s weight:UIFontWeightRegular]
#define FontB(s)             [UIFont systemFontOfSize:s weight:UIFontWeightBold]
#define FontT(s)             [UIFont systemFontOfSize:s weight:UIFontWeightThin]
#define Font(s)              FontL(s)

#if DEBUG
#	define DLog(fmt, ...) NSLog((@"%s #%d " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

//版本比较
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define MESSAGE_Loading   @"加载中..."
#define MESSAGE_Login     @"正在登录中…"
#define MESSAGE_Register  @"正在注册中…"
#define MESSAGE_Login_Successful    @"登录成功"
#define MESSAGE_Register_Successful @"注册成功"
#define MESSAGE_Login_Failure       @"登录失败"
#define MESSAGE_Register_Failure    @"注册失败"

//转化为weak对象（block循环引用使用时）
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;

#define strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;

#endif


