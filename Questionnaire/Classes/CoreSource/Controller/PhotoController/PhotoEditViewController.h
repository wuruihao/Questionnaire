//
//  PhotoEditViewController.h
//  JiBu
//
//  Created by Administrator on 16/4/15.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoEditViewController;
@protocol PhotoEditDelegate <NSObject>

- (void)completedSelectImage:(NSArray *)images;

@end

@interface PhotoEditViewController : UIViewController
@property (nonatomic, weak) id<PhotoEditDelegate> delegate;
@property (nonatomic, copy) NSArray *upImgs;
@property (nonatomic,assign) BOOL isScale;

@end


