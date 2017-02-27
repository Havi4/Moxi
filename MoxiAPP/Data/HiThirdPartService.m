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
    [[UINavigationBar appearance] setBarTintColor:kNaviBarBackColor];
    [[UINavigationBar appearance] setTintColor:kBarLightTextColor];
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
    [IQKeyboardManager sharedManager].canAdjustTextView = YES;
}

@end
