//
//  NSObject+CurrentController.h
//  CollegeGirl
//
//  Created by lwhldy on 17/1/10.
//  Copyright © 2017年 林文华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSObject (CurrentController)

- (void)alertMessageWithString:(NSString*)Message;

- (UIViewController *)getCurrentVC;

- (void)backMainViewController;

- (UIViewController*)currentVC;

- (void)checkNetworkStatus;

@end
