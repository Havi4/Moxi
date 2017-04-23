//
//  AppDelegate.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "AppDelegate.h"
#import "HiThirdPartService.h"
#import "HiInitData.h"
#import "BaseNaviViewController.h"
#import "HomeViewController.h"
#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "WXApi.h"
#import "WeiXinAPI.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

        // Create content and menu controllers
        //
    [WXApi registerApp:kWXAPPKey];
    if ([UserManager IsUserLogged]) {
        [UserManager GetUserObj];
        [HYBNetworking configCommonHttpHeaders:@{@"moxi-token":[NSString stringWithFormat:@"%@|%@",thirdPartyAccess_Token,thirdPartyOpenID]}];
        [self setRootViewController];
    }else{
        LoginViewController* login = [[LoginViewController alloc]init];
        self.window.rootViewController = login;
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self setUpNavigationBarAppearance];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)setRootViewController
{
    LeftMenuViewController *menuController = [[LeftMenuViewController alloc] init];

        // Create frosted view controller
        //
    self.tabBarControllerConfig = [[CYLTabBarControllerConfig alloc] init];
    REFrostedViewController *frostedViewController = [[REFrostedViewController alloc] initWithContentViewController:_tabBarControllerConfig.tabBarController menuViewController:menuController];
    frostedViewController.direction = REFrostedViewControllerDirectionLeft;
    frostedViewController.liveBlurBackgroundStyle = REFrostedViewControllerLiveBackgroundStyleLight;
    frostedViewController.delegate = self;

        // Make it a root controller
        //
    self.window.rootViewController = frostedViewController;
}

/**
 *  设置navigationBar样式
 */
- (void)setUpNavigationBarAppearance {
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];

    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [UIImage imageNamed:@"background_image"];

        textAttributes = @{
                           NSFontAttributeName : [UIFont systemFontOfSize:17],
                           NSForegroundColorAttributeName : kBarLightTextColor,
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [UIImage imageNamed:@"navigationbar_background"];
        textAttributes = @{
                           UITextAttributeFont : [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor : [UIColor blackColor],
                           UITextAttributeTextShadowColor : [UIColor clearColor],
                           UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLogin) name:kLogoutKey object:nil];
}

- (void)showLogin
{
    [UserManager resetUserInfo];
    LoginViewController* login = [[LoginViewController alloc]init];
    self.window.rootViewController = login;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark menu delegate
- (void)frostedViewController:(REFrostedViewController *)frostedViewController didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{

}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didShowMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didShowMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController willHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"willHideMenuViewController");
}

- (void)frostedViewController:(REFrostedViewController *)frostedViewController didHideMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"didHideMenuViewController");
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary*)options
{
    BOOL isSuc = [WXApi handleOpenURL:url delegate:self];
    NSLog(@"url %@ isSuc %d",url,isSuc == YES ? 1 : 0);
    return  isSuc;
}

#pragma mark 微信回掉

-(void) onReq:(BaseReq*)req
{
    
}

-(void) onResp:(BaseResp*)resp
{
    DeBugLog(@"%@",resp.errStr);
    if([resp isKindOfClass:[SendAuthResp class]])
    {
        SendAuthResp *temp = (SendAuthResp*)resp;
        if (temp.code) {
            [WeiXinAPI getWeiXinInfoWith:temp.code parameters:nil finished:^(NSURLResponse *response, NSData *data) {
                NSDictionary *obj = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    //第三方登录
                thirdPartyLoginUserId = [obj objectForKey:@"unionid"];
                thirdPartyUseIcon = [obj objectForKey:@"headimgurl"];
                thirdPartyNickName = [obj objectForKey:@"nickname"];
                [UserManager setGlobalOauth];
                [HYBNetworking configCommonHttpHeaders:@{@"moxi-token":[NSString stringWithFormat:@"%@|%@",thirdPartyAccess_Token,thirdPartyOpenID]}];
                [self setRootViewController];
                NSLog(@"用户信息是%@",obj);
            } failed:^(NSURLResponse *response, NSError *error) {

            }];
        }else{
            [NSObject showHudTipStr:@"取消登录"];
        }

    }
}

@end
