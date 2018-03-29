//
//  HomeCell.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "HomeCell.h"

@interface HomeCell ()

@property (weak, nonatomic) IBOutlet UILabel *background;

@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation HomeCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
//    [self.picImage addLineWithCorner:5];
//    [UIView setShadowLayer:self.picImage];
    self.background.hidden = NO;
    self.titleLabel.font = [UIFont fontWithName:TextFont size:kSize(16)];
    self.subTitleLabel.font = [UIFont fontWithName:TextFont size:kSize(13)];
    self.timeLabel.font = [UIFont fontWithName:TextFont size:kSize(13)];
    self.stateLabel.font = [UIFont fontWithName:TextFont size:kSize(13)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)setData:(HomeData *)data{
  
    _data = data;
    
    //正常状态
    if ([data.stateType isEqualToString:@"1"]){
        self.stateLabel.text = @"";
        self.background.backgroundColor = [UIColor clearColor];
        [self setHomeData:data];
        
    }else if ([data.stateType isEqualToString:@"2"]) {
        
        self.stateLabel.text = @"已完成";
        self.stateLabel.textColor = COLOR_HEX(0xFF2600);
        self.background.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.1];
        [self setHomeData:data];
        
    }else if ([data.stateType isEqualToString:@"3"]) {
        self.stateLabel.text = @"审核中";
        self.stateLabel.textColor = COLOR_HEX(0x9ECFF7);
        self.background.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.1];
        [self setHomeData:data];
    }
}

- (void)setHomeData:(HomeData *)data{
    
    if (![ETRegularUtil isEmptyString:data.title]) {
        self.titleLabel.text = data.title;
    }else{
        self.titleLabel.text = @"大学生调查问卷";
    }
    
    if (![ETRegularUtil isEmptyString:data.subTitle]) {
        self.subTitleLabel.text = [NSString stringWithFormat:@"已收集:%@份",data.subTitle];
    }else{
        self.subTitleLabel.text = @"已收集:2份";
    }
    
    if (![ETRegularUtil isEmptyString:data.time]) {
        self.timeLabel.text = [NSString stringWithFormat:@"截止时间:%@",data.time];
    }else{
        self.timeLabel.text = @"截止时间:2018-06-06";
    }
    
    if (![ETRegularUtil isEmptyString:data.image]) {
        [self.picImage sd_setImageWithURL:[NSURL URLWithString:data.image] placeholderImage:[UIImage imageNamed:@"home_default_image.png"]];
    }else{
        self.picImage.image = [UIImage imageNamed:@"home_default_image.png"];
    }
}

@end
