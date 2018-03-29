//
//  HomeData.h
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeData : NSObject

@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *titleId;
@property (strong, nonatomic) NSString *questionType;
@property (strong, nonatomic) NSString *stateType;
@property (strong, nonatomic) NSMutableArray *answerList;


@property (strong, nonatomic) UIImage *iocnImage;

- (instancetype)initWithTitle:(NSString *)title
                     objectId:(NSString *)objectId
                     subTitle:(NSString *)subTitle
                        image:(NSString *)image
                         time:(NSString *)time
                      titleId:(NSString *)titleId
                    stateType:(NSString *)stateType
                 questionType:(NSString *)questionType
                   answerList:(NSMutableArray *)answerList;

@end
