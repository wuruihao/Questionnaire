//
//  ActionSheet.h
//  XingPin
//
//  Created by Enjoytouch on 14-11-28.
//  Copyright (c) 2014年 EnjoyTouch. All rights reserved.
//

/**********XPActionSheet教程************
##### 实例化方法 ####
-(id)initWithDelegate:(id)delegate itemTitles:(NSArray *)titles;
 
 delegate:委托对象
 titles:所有messageView中的sheetBt名称(包含标题title,而且title.text = titles[0];如果titles[0]=@""的话，则无标题)
 
##### 协议委托方法 ####
- (void)xpActionSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag;
 
 sheetTag:不必须设置的参数，但是当一个Controller中需要实例化多个XPActionSheet时，需要actionsheet.sheetTag = 2来在委托方法中
 区分是那个对象执行了该协议方法
 index:区分是该actionsheet对象中的点击事件的sheet的标签；
 
**************************************/


#import <UIKit/UIKit.h>
#import "BlurView.h"
@protocol CommonSheetDelegate <NSObject>

@optional

- (void)commonSheetClickedIndex:(NSNumber *)index SheetTag:(NSNumber *)tag;
- (void)shareChaining:(UIButton *)btn;

@end

@interface CommonSheet : UIView
@property (strong) BlurView *messageView;
@property (strong) UIView *markView;
@property (strong) UIButton *cancelBtn;
@property (strong) NSMutableArray *sheets;
@property (strong) UIColor *itemColor;

@property (weak) id<CommonSheetDelegate> delegate;
@property (assign, nonatomic) NSInteger sheetTag;

- (void)showInView:(UIView *)view;
-(id)initWithDelegate:(id)delegate;
- (void)setupWithTitles:(NSArray *)titles;
- (void)setupWithShare;

@end

