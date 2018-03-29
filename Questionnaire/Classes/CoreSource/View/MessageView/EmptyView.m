//
//  EmptyView.m
//  User3.0_YuShang
//
//  Created by Enjoytouch on 16/7/5.
//  Copyright © 2016年 enjoytouch.com.cn. All rights reserved.
//

#import "EmptyView.h"
@interface EmptyView()

@end

@implementation EmptyView

- (id)initWithFrame:(CGRect)frame WithoutSomething:(NSString *)name{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = COLOR_HEX(0xe7e7e7);
        self.emptyImg = [[UIImageView alloc]init];
        self.emptyImg.frame = CGRectMake(0, kFitHeight(186), kFitWidth(188),kFitWidth(180));
        self.emptyImg.left = (kScreenWidth - self.emptyImg.width)*0.5;
        self.emptyImg.image = [UIImage imageBundleNamed:@"home_empty.png"];
        [self addSubview:self.emptyImg];
        
        self.label = [[UILabel alloc]init];
        self.label.frame = CGRectMake(0, self.emptyImg.bottom +kFitHeight(55),0, kScreenWidth *0.1);
        self.label.text = name;
        self.label.font = [UIFont fontWithName:TextFont size:kSize(17)];
        self.label.textColor = COLOR_HEX(0xbfbfbf);
        self.label.textAlignment = NSTextAlignmentCenter;
        self.label.width = [self.label.text safelySizeWithFont:[UIFont fontWithName:TextFont size:kSize(23)] constrainedToSize:CGSizeMake(kScreenWidth, self.label.height)].width;
        self.label.left = (kScreenWidth - self.label.width)*0.5;
        [self addSubview:self.label];
    }
    return self;
}


@end
