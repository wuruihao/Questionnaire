//
//  QuestionCell.m
//  WHQuestionnaire
//
//  Created by 林文华 on 2018/3/16.
//  Copyright © 2018年 林文华. All rights reserved.
//

#import "QuestionCell.h"

@interface QuestionCell ()

@property (weak, nonatomic) IBOutlet UIImageView *endImageV;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation QuestionCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundColor = COLOR_HEX(0xEDEEEF);
}

- (void)configureWithItem:(AVObject *)item{
    
    AVFile *file      = [item objectForKey:@"image"];
    AVFile *image     = [item objectForKey:@"imagelb"];
    NSString *title   = [item objectForKey:@"title"];
    NSString *date    = [item objectForKey:@"date"];
    NSString *desc    = [item objectForKey:@"desc"];
    if (desc) {
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.dateLabel setTextColor:COLOR_HEX(0x333333)];
    }else {
        [self.titleLabel setTextColor:COLOR_HEX(0x999999)];
        [self.dateLabel setTextColor:COLOR_HEX(0x999999)];
        
    }
    NSString *subString = desc ? desc : date;
    self.titleLabel.text = title;
    self.dateLabel.text = [NSString stringWithFormat:@"%@", subString];
    [self.endImageV sd_setImageWithURL:[NSURL URLWithString:image.url] placeholderImage:[UIImage imageBundleNamed:@"home_default_image.png"]];
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:file.url] placeholderImage:[UIImage imageBundleNamed:@"home_default_image.png"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

@end
