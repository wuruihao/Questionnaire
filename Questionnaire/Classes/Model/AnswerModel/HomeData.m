//
//  HomeData.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "HomeData.h"

@implementation HomeData

- (instancetype)initWithTitle:(NSString *)title
                     objectId:(NSString *)objectId
                     subTitle:(NSString *)subTitle
                        image:(NSString *)image
                         time:(NSString *)time
                      titleId:(NSString *)titleId
                    stateType:(NSString *)stateType
                 questionType:(NSString *)questionType
                   answerList:(NSMutableArray *)answerList{
    
    if (self = [super init]) {
        _title = title;
        _objectId = objectId;
        _subTitle = subTitle;
        _image = image;
        _time = time;
        _titleId = titleId;
        _stateType = stateType;
        _questionType = questionType;
        _answerList = answerList;
    }
    return self;
}

@end
