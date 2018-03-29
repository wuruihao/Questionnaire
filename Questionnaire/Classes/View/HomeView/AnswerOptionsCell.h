//
//  AnswerOptionsCell.h
//  Questionnaire
//
//  Created by Robert on 2018/3/17.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerOptionsCell;

@protocol AnswerOptionsCellDelegate <NSObject>

- (void)cell:(AnswerOptionsCell *)cell didSelectRowAtIndexPath:(NSInteger )index;

@end

@interface AnswerOptionsCell : UITableViewCell

@property (weak, nonatomic) id <AnswerOptionsCellDelegate> delegate;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) AnswerData *data;
@property (assign, nonatomic) BOOL isOptions;

@end
