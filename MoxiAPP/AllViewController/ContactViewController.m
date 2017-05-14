//
//  ContactViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
     self.view.backgroundColor = [UIColor yellowColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_navi_icon"] imageByTintColor:kBarLightTextColor]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMenu)];
    self.navigationItem.title = @"联系客服";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:17],NSForegroundColorAttributeName:kBarLightTextColor}];
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenSize.width, kScreenSize.height-64)];
    [self.view addSubview:self.webView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[publicGet objectForKey:@"data"] objectForKey:@"contactPage"]]]]];
}

- (void)showMenu
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
