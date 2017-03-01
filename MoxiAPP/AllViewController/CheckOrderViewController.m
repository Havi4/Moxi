//
//  CheckOrderViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "CheckOrderViewController.h"
#import "HouseTableViewCell.h"
#import "CarTableViewCell.h"
#import "CarOrderViewController.h"
#import "HourseViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"

@interface CheckOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderView;
@property (nonatomic, strong) NSMutableArray *dic;

@end

@implementation CheckOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dic = @[].mutableCopy;

    // Do any additional setup after loading the view.
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
     @{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue" size:20],NSForegroundColorAttributeName:kBarLightTextColor}];

    _orderView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _orderView.backgroundColor = kBackgroundViewColor;
    _orderView.delegate = self;
    _orderView.dataSource = self;
    _orderView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_orderView];
            // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    self.orderView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];

        // Enter the refresh status immediately
    [self.orderView.mj_header beginRefreshing];
    self.orderView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            //Call this Block When enter the refresh status automatically
        [self loadAllData];
    }];

}

- (void)loadAllData
{
    NSString *path = [[NSBundle mainBundle]pathForResource:@"testData" ofType:@"plist"];
    [self.dic addObjectsFromArray:[NSArray arrayWithContentsOfFile:path]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.orderView.mj_footer endRefreshing];
        [self.orderView reloadData];
    });
}

- (void)loadNewData
{
        //    [[HIPregressHUD shartMBHUD]showLoadingWith:@"加载中" inView:self.view];
    NSString *path = [[NSBundle mainBundle]pathForResource:@"testData" ofType:@"plist"];
    self.dic = [NSMutableArray arrayWithArray:[NSArray arrayWithContentsOfFile:path]];
    DeBugLog(@"字典%@",self.dic);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.orderView.mj_header endRefreshing];
        [self.orderView reloadData];
    });
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
    OptionalConfiguration option = {11,7,7,8.5,6.5,YES,NO,YES,NO,{0.376, 0.255, 0.227},{1,1,1}};
    [KxMenu setTitleFont:[UIFont systemFontOfSize:20]];

    [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-50, -60, 52, 60) menuItems:itemArr withOptions:option];
}

- (void)showMinsuOrder
{
    HourseViewController *hourse = [[HourseViewController alloc]init];
    [self presentViewController:hourse animated:YES completion:^{

    }];
}

- (void)showCarOrder
{
    CarOrderViewController *carOrder = [[CarOrderViewController alloc]init];
    [self presentViewController:carOrder animated:YES completion:^{

    }];
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dic.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dic objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"orderType"] intValue]==0) {//车

        CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        if (!cell) {
            cell = [[CarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carcell"];
        }
        [cell cellConfigWithItem:[self.dic objectAtIndex:indexPath.row] andIndex:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[dic objectForKey:@"isDone"] intValue]==0) {//未完成
            cell.hideModelDoneView = YES;
            cell.copyWx = ^(NSIndexPath *indexPath){
                [self copyWx:indexPath];
            };
            cell.moreNext = ^(NSIndexPath *indexPath){
                [self showMore:indexPath];
            };

            cell.callMoxi = ^(NSIndexPath *indexPath){
                [self callMoxi:indexPath];
            };
        }else{
            cell.hideModelDoneView = NO;
            cell.copyWx = ^(NSIndexPath *indexPath){
                [self copyWx:indexPath];
            };

            cell.callMoxi = ^(NSIndexPath *indexPath){
                [self callMoxi:indexPath];
            };
            cell.tapDoneDelete = ^(NSIndexPath *indexPath){
                [self deleteOrder:indexPath];
            };

        }
        return cell;
    }else{
        HouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[HouseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell cellConfigWithItem:[self.dic objectAtIndex:indexPath.row] andIndex:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[dic objectForKey:@"isDone"] intValue]==0) {//未完成
            cell.hideModelDoneView = YES;
            cell.copyWx = ^(NSIndexPath *indexPath){
                [self copyWx:indexPath];
            };
            cell.moreNext = ^(NSIndexPath *indexPath){
                [self showMore:indexPath];
            };

            cell.callMoxi = ^(NSIndexPath *indexPath){
                [self callMoxi:indexPath];
            };
        }else{
            cell.hideModelDoneView = NO;
            cell.copyWx = ^(NSIndexPath *indexPath){
                [self copyWx:indexPath];
            };

            cell.callMoxi = ^(NSIndexPath *indexPath){
                [self callMoxi:indexPath];
            };
            cell.tapDoneDelete = ^(NSIndexPath *indexPath){
                [self deleteOrder:indexPath];
            };

        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.dic objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"orderType"] intValue]==0) {//车
        CGFloat height = [self heightForText1:[dic objectForKey:@"startPlace"]];
        CGFloat height2 = [self heightForText1:[dic objectForKey:@"endPlace"]];
        return 241 + height2 +height;
    }else{
        NSString *str = [[self.dic objectAtIndex:indexPath.row] objectForKey:@"yaoqiu"];
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
        return [self.orderView cellHeightForIndexPath:indexPath model:str keyPath:@"text" cellClass:[HouseTableViewCell class] contentViewWidth:kScreenSize.width];
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)heightForText:(NSString *)text
{
        //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat width = self.view.frame.size.width-100;
    return [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

- (CGFloat)heightForText1:(NSString *)text
{
        //设置计算文本时字体的大小,以什么标准来计算
    NSDictionary *attrbute = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGFloat width = self.view.frame.size.width-120;
    return [text boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attrbute context:nil].size.height;
}

- (void)deleteOrder:(NSIndexPath *)indexPath
{
    DeBugLog(@"删除的订单是%ld",(long)indexPath.row);
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"不再显示该订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [done setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:done];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"不再显示所有已完成订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }];
    [cancel1 setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:cancel1];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [cancel setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:cancel];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)callMoxi:(NSIndexPath *)indexPath
{
    DeBugLog(@"直连是%ld",(long)indexPath.row);
}

- (void)copyWx:(NSIndexPath *)indexPath
{
    DeBugLog(@"copy订单是%ld",(long)indexPath.row);
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string=@"测试";
    [[HIPregressHUD shartMBHUD]showAlertWith:@"微信号已复制到剪切板" inView:self.view];
}

- (void)showMore:(NSIndexPath *)indexPath
{
    DeBugLog(@"展示是%ld",(long)indexPath.row);
    NSDictionary *dic = [self.dic objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"isMine"] intValue]==0) {//自己的
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"复制订单内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [done setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:done];
        UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"订单已完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [cancel1 setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel1];

        UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:@"删除订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [cancel2 setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel2];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

        }];
        [cancel setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel];
        [self presentViewController:alertView animated:YES completion:nil];

    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"复制订单内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [done setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:done];
        UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"标记订单为置顶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [cancel1 setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel1];

        UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:@"不再显示该订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        }];
        [cancel2 setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel2];

        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [cancel setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel];
        [self presentViewController:alertView animated:YES completion:nil];
        
    }
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
