//
//  StatisticalCell.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "StatisticalCell.h"

@interface StatisticalCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation StatisticalCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = COLOR_HEX(0xe6e6e6).CGColor;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setupSubView];
    }
    return self;
}

- (void)setupSubView{
    
}

- (void)setData:(StatisticalData *)data{

    _data = data;
    
    if (![ETRegularUtil isEmptyString:data.title]) {
        self.titleLabel.text = data.title;
    }else{
        self.titleLabel.text = @"大学生";
    }
    if (![ETRegularUtil isEmptyString:data.picImage]) {
        [self.picImage sd_setImageWithURL:[NSURL URLWithString:data.picImage] placeholderImage:[UIImage imageNamed:@"home_default_pic.png"]];
    }else{
        self.picImage.image = [UIImage imageNamed:@"home_default_pic.png"];
    }
}

@end
