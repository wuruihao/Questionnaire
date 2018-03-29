//
//  AppDelegate.h
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CustomTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property (strong, nonatomic) CustomTabBarController *tabBarController;

- (void)saveContext;

+ (AppDelegate *)sharedInstance;

- (void)showLogin;

@end

