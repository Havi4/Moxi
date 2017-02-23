//
//  CheckOrderViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "CheckOrderViewController.h"

@interface CheckOrderViewController ()

@end

@implementation CheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bar_user_icon"] imageByTintColor:kBarLightTextColor]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(BaseNaviViewController *)self.navigationController
                                                                            action:@selector(showMenu)];
    UIBarButtonItem *addOrderItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"order_pulish_icon"] imageByTintColor:kBarLightTextColor]
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(addNewOrder)];

    self.navigationItem.rightBarButtonItems = @[addOrderItem];

    self.navigationItem.title = @"我的发布";
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
