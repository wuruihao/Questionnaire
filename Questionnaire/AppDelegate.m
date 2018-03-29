//
//  AppDelegate.m
//  Questionnaire
//
//  Created by Robert on 2018/3/15.
//  Copyright © 2018年 wuruihao. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate () <JPUSHRegisterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    // 1.创建UIWindow
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.tabBarController;
    // 让UIWindow显示出来(让窗口成为主窗口 并且显示出来)
    // 一个应用程序只能有一个主窗口
    [self.window makeKeyAndVisible];
    
    //JPush
    [self configurationJPush:launchOptions];
    
    //Umeng
    [self configurationUment:launchOptions];
    
    [AVOSCloud setApplicationId:LeanCloundAppID clientKey:LeanCloundAppKey];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [[QuestionManager defaultManager] beginAnalyseWithLaunchScreenID:LaunchScreenID];
    
    return YES;
}

#pragma mark -- UMCAnalytics
- (void)configurationUment:(NSDictionary *)launchOptions {
    
#ifdef DEBUG
    
#else
    // 配置友盟SDK产品并并统一初始化
    // [UMConfigure setEncryptEnabled:YES]; // optional: 设置加密传输, 默认NO.
    // [UMConfigure setLogEnabled:YES]; // 开发调试时可在console查看友盟日志显示，发布产品必须移除。
    [UMConfigure initWithAppkey:UMengAppKey channel:@"App Store"];
    /* appkey: 开发者在友盟后台申请的应用获得（可在统计后台的 “统计分析->设置->应用信息” 页面查看）*/
    
    // 统计组件配置
    [MobClick setScenarioType:E_UM_NORMAL];
    // [MobClick setScenarioType:E_UM_GAME];  // optional: 游戏场景设置
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setVersion:version.integerValue];
#endif
    
}

/**
 添加初始化的APN JPush代码
 */
- (void)configurationJPush:(NSDictionary *)launchOptions{
    
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                          channel:@"Appstore"
                 apsForProduction:true
            advertisingIdentifier:nil];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"registrationID获取成功：%@",registrationID);
        } else {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
}

/**
 注册的APN成功并上报DeviceToken
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

/**
 实现注册的APN失败接口
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

/**
 添加处理的APN通知回调方法
 */
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {

}

- (void)applicationDidBecomeActive:(UIApplication *)application {

}

- (void)applicationWillTerminate:(UIApplication *)application {

    [self saveContext];
}

+ (AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (CustomTabBarController *)tabBarController {
    if (_tabBarController == nil){
        _tabBarController = [[CustomTabBarController alloc] init];
        _tabBarController.delegate = self;
        [_tabBarController setupView];
    }
    return _tabBarController;
}
//显示登录界面
- (void)showLogin {
    
    //清空缓存
    [CenterModel memberLogout];
    
    LoginController *viewController = [[LoginController alloc] init];
    ETNavigationController* navi = [[ETNavigationController alloc] initWithRootViewController:viewController];
    [self.window.rootViewController presentViewController:navi
                                                 animated:YES
                                               completion:nil];
}
//显示登录界面
- (void)memberShowLogin {
    
    //清空缓存
    [CenterModel memberLogout];
    
    LoginController *viewController = [[LoginController alloc] init];
    ETNavigationController* navi = [[ETNavigationController alloc] initWithRootViewController:viewController];
    navi.tag = 1001;
    [self.window.rootViewController presentViewController:navi
                                                 animated:YES
                                               completion:nil];
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    [_tabBarController selectedItemWithIndex:tabBarController.selectedIndex];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(nonnull UIViewController *)viewController {
    ETNavigationController *navi = (ETNavigationController *)viewController;
    [navi popViewControllerAnimated:NO];
    
    if (navi.tag == 2) {
        if (![CenterModel isDidMemberLogin]) {
            [self memberShowLogin];
            return NO;
        }
    }
    return YES;
}
#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Questionnaire"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
