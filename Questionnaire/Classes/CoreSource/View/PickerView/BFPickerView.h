//
//  BFPickerView.h
//  Crabyter
//
//  Created by Sinyoo on 16/12/7.
//  Copyright © 2016年 microdreams. All rights reserved.
//

#import <UIKit/UIKit.h>

// 选中
typedef void(^pickerViewDidSelectBlock)(NSInteger index);

// cancel
typedef void(^pickerViewCancelBlock)();

@class BFPickerView;
@protocol BFPickerViewDelegate <NSObject>

@optional

- (void)pickerViewCommitAction:(BFPickerView *)view
                          text:(NSString *)text;
@end

@interface BFPickerView : UIView

@property(nonatomic,copy) pickerViewDidSelectBlock didSelectBlock;
@property(nonatomic,copy) pickerViewCancelBlock cancelBlock;
@property(nonatomic,weak) id<BFPickerViewDelegate> delegate;
@property(nonatomic,strong) NSArray *dataSource;
@property(nonatomic) NSInteger selectIndex;

@end
