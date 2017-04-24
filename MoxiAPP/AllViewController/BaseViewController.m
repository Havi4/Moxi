//
//  BaseViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.976 green:0.976 blue:0.976 alpha:1.00];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bar"] forBarMetrics:0];

        // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNewPublic) name:@"vxchange" object:nil];
}

- (void)getNewPublic
{
    [[BaseNetworking sharedAPIManager]getPublicDicWith:nil success:^(id response) {
        if ([[response objectForKey:@"code"] intValue]==200) {
            publicGet = response;
        }else {
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:[[UIApplication sharedApplication] keyWindow]];
        }

    } fail:^(NSError *error) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
