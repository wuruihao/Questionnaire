//
//  UserAnswerData.h
//  Questionnaire
//
//  Created by Robert on 2018/3/21.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAnswerData : NSObject

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *questionId;
@property (strong, nonatomic) NSString *isComplete;

@end
