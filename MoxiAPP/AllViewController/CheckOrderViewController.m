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
                                                                    action:@selector(addNewOrder:)];

    self.navigationItem.rightBarButtonItems = @[addOrderItem];

    self.navigationItem.title = @"我的发布";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:17],NSForegroundColorAttributeName:kBarLightTextColor}];

}

- (void)addNewOrder:(UIBarButtonItem *)sender
{
    DeBugLog(@"addneworder");
    for (UIView *view in self.view.subviews) {
        if ([view isKindOfClass:[KxMenuOverlay class]]) {
            [KxMenu dismissMenu];
            return;
        }
    }
    NSArray *itemArr = @[
                         [KxMenuItem menuItem:@"发布民宿订单" image:nil target:self action:@selector(showMinsuOrder)],
                         [KxMenuItem menuItem:@"发布用车订单" image:nil target:self action:@selector(showCarOrder)]
                         ];
    OptionalConfiguration option = {9,7,7,8.5,6.5,YES,NO,YES,NO,{0.376, 0.255, 0.227},{1,1,1}};

    [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-50, 6, 50, 60) menuItems:itemArr withOptions:option];
        //    if (![KxMenu isShow]) {
        //    }else{
        //        [KxMenu dismissMenu];
        //    }
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
