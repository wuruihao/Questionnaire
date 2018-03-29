//
//  AgreeDealView.h
//  Questionnaire
//
//  Created by Robert on 2018/3/16.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AgreeDealViewDelegate <NSObject>

- (void)backRegisterView;

@end

@interface AgreeDealView : UIView

@property (weak, nonatomic) id <AgreeDealViewDelegate> delegate;

@end
