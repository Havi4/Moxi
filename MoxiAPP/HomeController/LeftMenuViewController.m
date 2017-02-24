//
//  LeftMenuViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "HomeViewController.h"
#import "BaseNaviViewController.h"
#import "CheckOrderViewController.h"
#import "ChangeWXViewController.h"
#import "ContactViewController.h"
#import "AboutViewController.h"
#import "UIViewController+REFrostedViewController.h"

@interface LeftMenuViewController ()

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width-100, self.view.frame.size.height-49);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = kBackgroundViewColor;
    self.tableView.separatorColor = kFocusTextColor;
    self.tableView.scrollEnabled = NO;
    self.tableView.tableHeaderView = ({
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 215.0f)];
        view.image = [UIImage imageNamed:@"left_icon_back"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 60, 60)];
        [view addSubview:imageView];

        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(view.mas_centerY);
            make.left.equalTo(@15);
            make.height.equalTo(@60);
            make.width.equalTo(@60);
        }];
        imageView.image = [UIImage imageNamed:@"avatar.jpg"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 30.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Roman Efimov";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        [label sizeToFit];
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).offset(5);
            make.centerY.equalTo(view.mas_centerY);
        }];
        view;
    });
    UIButton *logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutButton.frame = CGRectMake((self.view.frame.size.width-100-150)/2+30, self.view.frame.size.height, 150, 49);
    [self.view addSubview:logoutButton];
    [logoutButton setImage:[UIImage imageNamed:@"login_out"] forState:UIControlStateNormal];
    logoutButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    [logoutButton setImageEdgeInsets:UIEdgeInsetsMake(0, 20, 0, logoutButton.titleLabel.intrinsicContentSize.width)];
//
//    [logoutButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -logoutButton.currentImage.size.width, 0, -50)];
    [logoutButton setTitle:@"解绑微信并退出" forState:UIControlStateNormal];
    [logoutButton setTitleColor:[UIColor colorWithRed:0.376 green:0.255 blue:0.227 alpha:1.00] forState:UIControlStateNormal];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = kFocusTextColor;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return nil;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = kBackgroundViewColor;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIndex
{
    if (sectionIndex == 0)
        return 0;

    return 34;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        HomeViewController *homeViewController = [[HomeViewController alloc] init];
        BaseNaviViewController *navigationController = [[BaseNaviViewController alloc] initWithRootViewController:homeViewController];
        self.frostedViewController.contentViewController = navigationController;
    } else if(indexPath.row == 1) {
        CheckOrderViewController *secondViewController = [[CheckOrderViewController alloc] init];
        BaseNaviViewController *navigationController = [[BaseNaviViewController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
    }else if(indexPath.row == 2) {
        ChangeWXViewController *secondViewController = [[ChangeWXViewController alloc] init];
        BaseNaviViewController *navigationController = [[BaseNaviViewController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
    }else if(indexPath.row == 3) {
        ContactViewController *secondViewController = [[ContactViewController alloc] init];
        BaseNaviViewController *navigationController = [[BaseNaviViewController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
    }else if(indexPath.row == 4) {
        AboutViewController *secondViewController = [[AboutViewController alloc] init];
        BaseNaviViewController *navigationController = [[BaseNaviViewController alloc] initWithRootViewController:secondViewController];
        self.frostedViewController.contentViewController = navigationController;
    }

    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    NSArray *titles = @[@"首页",@"查看我的发布", @"修改联系微信", @"联系客服",@"关于MOXI"];
    cell.textLabel.text = titles[indexPath.row];
    cell.textLabel.textColor = kBarLightTextColor;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, self.view.frame.size.width-50)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
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
