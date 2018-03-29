//
//  IssueController.h
//  JiBu
//
//  Created by yizheming on 16/4/11.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "PhotoEditViewController.h"
#import "BackEditViewController.h"
#define SettingCamera 10102

@interface OnePhotoController : UIViewController

@property (nonatomic, weak) id<PhotoEditDelegate> delegate;
@property (nonatomic, weak) id<BackEditDelegate> bdelegate;

@property (nonatomic,assign) BOOL isScale;

@end
