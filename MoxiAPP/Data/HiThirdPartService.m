//
//  HiThirdPartService.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "HiThirdPartService.h"
#import "IQKeyboardManager.h"

@implementation HiThirdPartService

+ (void)load
{
        //状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"navi_bar"] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance]setBarTintColor:kNaviBarBackColor];
//    [[UINavigationBar appearance] setBackgroundColor:kNaviBarBackColor];
    [[UINavigationBar appearance] setTintColor:kBarLightTextColor];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].canAdjustTextView = YES;
    [HYBNetworking configCommonHttpHeaders:@{@"Content-Type":@"application/x-www-form-urlencoded"}];
    [HYBNetworking updateBaseUrl:kAppBaseURL];

    regionArr = @[@"东京",@"大阪",@"京都",@"名古屋",@"北海道",@"冲绳",@"其它"];

    [[NSUserDefaults standardUserDefaults]registerDefaults:@{kHourseTopIds:@""}];
    [[NSUserDefaults standardUserDefaults]registerDefaults:@{kCarTopIds:@""}];
}

@end
