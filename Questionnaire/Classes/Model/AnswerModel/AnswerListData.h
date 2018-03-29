//
//  AnswerListData.h
//  Questionnaire
//
//  Created by Robert on 2018/3/17.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerListData : NSObject

@property (assign, nonatomic) NSInteger answerId;

@property (strong, nonatomic) NSArray *answers;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) NSInteger selectedIndex;

@property (assign, nonatomic) BOOL isAnswered;

@end
