//
//  EmptyView.h
//  User3.0_YuShang
//
//  Created by Enjoytouch on 16/7/5.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

@interface EmptyView : UIView

@property(nonatomic,strong) UIImageView *emptyImg;
@property(nonatomic,strong) UILabel *label;

- (id)initWithFrame:(CGRect)frame WithoutSomething:(NSString *)name;

@end
