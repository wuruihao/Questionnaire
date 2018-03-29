//
//  AnswerData.h
//  Questionnaire
//
//  Created by Robert on 2018/3/17.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerData : NSObject

@property (strong, nonatomic) NSString *num;

@property (strong, nonatomic) NSString *value;

@property (assign, nonatomic) BOOL isSelected;

@end
