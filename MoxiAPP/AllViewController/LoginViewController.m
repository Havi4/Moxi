//
//  LoginViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/18.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "LoginViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"
@interface LoginViewController ()<WXApiDelegate>

@property (nonatomic, strong) UILabel *loginTitle;
@property (nonatomic, strong) UILabel *loginWelcome;
@property (nonatomic, strong) UIButton *loginWithWXButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setSubViews];
}

- (void)setSubViews
{
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundImage.image = [UIImage imageNamed:@"back_ground_image"];
    [self.view addSubview:backgroundImage];
    self.loginTitle = [[UILabel alloc]init];
    self.loginTitle.text = @"您好，服务商";
    self.loginTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.loginTitle.textColor = [UIColor whiteColor];
    self.loginTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.loginTitle];
    [self.loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.top.equalTo(self.view.mas_top).offset(72);
    }];

    self.loginWelcome = [[UILabel alloc]init];
    self.loginWelcome.text = @"欢迎使用MOXI客源分享系统";
    self.loginWelcome.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.loginWelcome.textColor = [UIColor whiteColor];
    self.loginWelcome.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.loginWelcome];
    [self.loginWelcome mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.top.equalTo(self.view.mas_top).offset(108);
    }];

    self.loginWithWXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginWithWXButton.layer.cornerRadius = 21;
    self.loginWithWXButton.layer.masksToBounds = YES;
    self.loginWithWXButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginWithWXButton.layer.borderWidth = 1;
    [self.loginWithWXButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginWithWXButton setTitle:@"使用微信登录" forState:UIControlStateNormal];
    self.loginWithWXButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginWithWXButton setTarget:self action:@selector(weixinButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginWithWXButton];
    [self.loginWithWXButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
        make.width.equalTo(@160);
        make.height.equalTo(@42);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)weixinButtonTaped:(UIButton *)sender
{
        //    isThirdLogin = YES;
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
    req.state = @"xxx";
    [WXApi sendAuthReq:req viewController:self delegate:self];
}

- (void)loginWX
{

    self.loginDone(@{});
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
