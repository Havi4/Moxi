//
//  SetWXViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/4/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "SetWXViewController.h"

@interface SetWXViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UITextField *wxTextfield;
@property (nonatomic, strong) UILabel *loginTitle;
@property (nonatomic, strong) UILabel *textTitle;
@property (nonatomic, strong) UIButton *loginWithWXButton;

@end

@implementation SetWXViewController

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
    self.loginTitle.text = @"请设置您的微信，方便其他服务商与您联系";
    self.loginTitle.numberOfLines = 0;
    self.loginTitle.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
    self.loginTitle.textColor = [UIColor whiteColor];
    self.loginTitle.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.loginTitle];
    [self.loginTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(18);
        make.right.equalTo(self.view.mas_right).offset(-18);
        make.top.equalTo(self.view.mas_top).offset(72);
    }];

    self.textTitle = [[UILabel alloc]init];
    self.textTitle.font = [UIFont systemFontOfSize:20];
    self.textTitle.textColor = [UIColor whiteColor];
    self.textTitle.textAlignment = NSTextAlignmentLeft;
    self.textTitle.text = @"微信号";
    [self.view addSubview:self.textTitle];
    [self.textTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(60);
        make.width.equalTo(@70);
    }];

    self.wxTextfield = [[UITextField alloc]init];
    self.wxTextfield.borderStyle = UITextBorderStyleNone;
    self.wxTextfield.font = [UIFont systemFontOfSize:20];
    self.wxTextfield.textColor = [UIColor whiteColor];
    self.wxTextfield.tintColor = [UIColor whiteColor];

    self.wxTextfield.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.wxTextfield];

    [self.wxTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self.textTitle.mas_right).offset(5);
        make.right.equalTo(self.view.mas_right).offset(-60);

    }];

    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor whiteColor];
    [self.wxTextfield addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);
        make.bottom.equalTo(self.wxTextfield.mas_bottom);
        make.left.equalTo(self.wxTextfield.mas_left);
        make.right.equalTo(self.wxTextfield.mas_right);
    }];


    self.loginWithWXButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginWithWXButton.layer.cornerRadius = 21;
    self.loginWithWXButton.layer.masksToBounds = YES;
    self.loginWithWXButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginWithWXButton.layer.borderWidth = 1;
    [self.loginWithWXButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginWithWXButton setTitle:@"完成设置" forState:UIControlStateNormal];
    self.loginWithWXButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [self.loginWithWXButton setTarget:self action:@selector(saveWxId) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginWithWXButton];
    [self.loginWithWXButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-64);
        make.width.equalTo(@160);
        make.height.equalTo(@42);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
}

- (void)saveWxId
{
    DeBugLog(@"爆粗");
    if (self.wxTextfield.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微信号可稍后进行设置，是否跳过？" delegate:self cancelButtonTitle:@"跳过" otherButtonTitles:@"现在设置", nil];
        alert.tag = 101;
        [alert show];
        return;
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"微信号可在个人中心重新设置" delegate:self cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
        alert.tag = 102;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101) {

        if (buttonIndex == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.wxTextfield becomeFirstResponder];
        }
    }else if (alertView.tag == 102){
        NSDictionary *dic = @{@"wxhao":self.wxTextfield.text};
        [[BaseNetworking sharedAPIManager] changeWXHAOWith:dic success:^(id response) {
            if ([[response objectForKey:@"code"] intValue]==200) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"vxchange" object:nil];
                    [[HIPregressHUD shartMBHUD]showAlertWith:@"微信号设置成功" inView:[[UIApplication sharedApplication] keyWindow]];
                }];
            }else {
                [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:[[UIApplication sharedApplication] keyWindow]];
            }
        } fail:^(NSError *error) {
            
        }];
    }
}

- (void)showMenu
{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
