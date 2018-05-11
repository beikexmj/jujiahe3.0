//
//  AppDelegate.h
//  copooo
//
//  Created by XiaMingjiang on 2018/1/15.
//  Copyright © 2018年 世纪之光. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"f4c05efcf4f635adfc6b4822";//极光推送
static NSString *channel = @"jjh_push_distribution";//
static BOOL isProduction = YES;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,copy)NSString *registrationID;

@end

