//
//  SetWXViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/4/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "SetWXViewController.h"

@interface SetWXViewController ()

@property (nonatomic, strong) UITextField *wxTextfield;

@end

@implementation SetWXViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundViewColor;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_navi_icon"] imageByTintColor:kBarLightTextColor]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showMenu)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveWxId)];
    self.navigationItem.title = @"设置联系微信";
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:kBarLightTextColor}];

    self.wxTextfield = [[UITextField alloc]init];
    _wxTextfield.borderStyle = UITextBorderStyleNone;
    _wxTextfield.backgroundColor = [UIColor whiteColor];
    _wxTextfield.clearButtonMode = UITextFieldViewModeNever;
    _wxTextfield.font = [UIFont systemFontOfSize:20];
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 50)];
    _wxTextfield.leftViewMode = UITextFieldViewModeAlways;
    _wxTextfield.leftView = view;
    [self.view addSubview:self.wxTextfield];
    [_wxTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@50);
    }];

    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[[UIImage imageNamed:@"clear"] imageByTintColor:[UIColor colorWithRed:0.847 green:0.847 blue:0.847 alpha:1.00]] forState:UIControlStateNormal];
    [clearButton addTarget:self action:@selector(clearAll) forControlEvents:UIControlEventTouchUpInside];
    clearButton.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:clearButton];

    [clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_wxTextfield.mas_centerY);
        make.height.equalTo(@50);
        make.width.equalTo(@50);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(_wxTextfield.mas_right);
    }];

    UIImageView *line1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"septor_line"]];
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.wxTextfield.mas_top).offset(0);
    }];

    UIImageView *line2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"septor_line"]];
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.wxTextfield.mas_bottom).offset(0);
    }];
}

- (void)clearAll
{
    _wxTextfield.text = @"";
}

- (void)saveWxId
{
    DeBugLog(@"爆粗");
    if (self.wxTextfield.text.length == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入微信号" inView:self.view];
    }
    NSDictionary *dic = @{@"wxhao":self.wxTextfield.text};
    [[BaseNetworking sharedAPIManager] changeWXHAOWith:dic success:^(id response) {
        if ([[response objectForKey:@"code"] intValue]==200) {
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
        }else {
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
        }
    } fail:^(NSError *error) {

    }];
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
