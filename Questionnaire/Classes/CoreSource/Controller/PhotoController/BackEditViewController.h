//
//  PhotoEditViewController.h
//  JiBu
//
//  Created by Administrator on 16/4/15.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BackEditViewController;
@protocol BackEditDelegate <NSObject>
- (void)completedSelectImage:(NSArray *)images;

@end

@interface BackEditViewController : UIViewController
@property (nonatomic, weak) id<BackEditDelegate> delegate;
@property (nonatomic, copy) NSArray *upImgs;
@property (nonatomic,assign) BOOL isScale;

@end


