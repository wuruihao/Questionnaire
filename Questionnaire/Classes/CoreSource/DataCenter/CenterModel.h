//
//  CenterModel.h
//  Questionnaire
//
//  Created by Robert on 2018/3/16.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CenterModel : NSObject

@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *sex;
@property (strong, nonatomic) NSString *age;
@property (strong, nonatomic) NSString *xueli;


//判断是否登录
+ (BOOL)isDidMemberLogin;

//判断程序第一次安装启动
+ (BOOL)isFirstLaunch;

+ (BOOL)getFirst;

+ (void)memberLogout;

+ (NSString *)showErrorMessage:(NSError *)error;

@end
