//
//  CenterModel.m
//  Questionnaire
//
//  Created by Robert on 2018/3/16.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "CenterModel.h"

@implementation CenterModel

- (void)setUserName:(NSString *)userName{
    
    _userName = userName;
}

+ (BOOL)isDidMemberLogin{
    
    //初始化用户信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *isLogin = [userDefaults objectForKey:@"isLogin"];
    //这里判空避免拿不到数据 崩溃
    if (![ETRegularUtil isEmptyString:isLogin]) {
        if ([isLogin isEqualToString:@"YES"]) {
            return YES;
        }
        return NO;
    }
    return NO;
}

+ (BOOL)isFirstLaunch{
    
    return ([CenterModel UUID] == nil/* || [self myMemberInfo] == nil*/);
}

+ (NSString *)UUID{
    NSString *uuid = [[NSUserDefaults standardUserDefaults]objectForKey:@"UUID"];
    if ([ETRegularUtil isEmptyString:uuid]) {
        uuid = [CenterModel getIdentifierNumber];
        [[NSUserDefaults standardUserDefaults]setValue:uuid forKey:@"UUID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return nil;
    }else{
        [[NSUserDefaults standardUserDefaults]setObject:@"FirstOpen" forKey:@"FirstOpen"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return uuid;
    }
}

+ (NSString *)getIdentifierNumber{
    
    NSString* identifierNumber = [[UIDevice currentDevice].identifierForVendor UUIDString] ;
    return identifierNumber;
}

+ (BOOL)getFirst{
    NSString *firtst = [[NSUserDefaults standardUserDefaults]objectForKey:@"FirstOpen"];
    if (![ETRegularUtil isEmptyString:firtst]) {
        return YES;
    }else{
        return NO;
    }
}

+ (void)memberLogout{
    
    //快速创建
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLogin"];
    //必须
    [[NSUserDefaults standardUserDefaults]synchronize];
    [AVUser logOut];
}

+ (NSString *)showErrorMessage:(NSError *)error{
    
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    NSDictionary *errorDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSString *message = [errorDic objectForKey:@"error"];
    return message;
}

@end
