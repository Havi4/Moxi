//
//  CheckOrderViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "CheckOrderViewController.h"
#import "MyHouseTableViewCell.h"
#import "MyCarTableViewCell.h"
#import "CarOrderViewController.h"
#import "HourseViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import <AFHTTPSessionManager.h>
#import "FaBuSetVXViewController.h"
#import "SureGuideView.h"

@interface CheckOrderViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *orderView;
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, assign) int orderPg;


@end

@implementation CheckOrderViewController

- (void)viewWillAppear:(BOOL)animated
{

}

- (void)showAnimation:(NSNotification *)userInfo
{
    self.navigationItem.titleView.alpha = 0;
    self.navigationItem.leftBarButtonItem.customView.alpha = 0;
    self.navigationItem.rightBarButtonItem.customView.alpha = 0;
    NSDictionary *dic = userInfo.userInfo;
    BaseNaviViewController *navi = [dic objectForKey:@"key"];
    if ([[[navi viewControllers] firstObject] isKindOfClass:[CheckOrderViewController class]]) {
        DeBugLog(@"check");
        [UIView animateWithDuration:1 animations:^{
            self.navigationItem.titleView.alpha = 1;
            self.navigationItem.leftBarButtonItem.customView.alpha = 1;
            self.navigationItem.rightBarButtonItem.customView.alpha = 1;
        }];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.orderArr = @[].mutableCopy;
    self.orderPg = 1;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAnimation:) name:@"naviAlpha" object:nil];
    // Do any additional setup after loading the view.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [leftButton setImage:[[UIImage imageNamed:@"bar_user_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [leftButton addTarget:(BaseNaviViewController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

    UIButton *_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    [_rightButton setImage:[[UIImage imageNamed:@"order_pulish_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(addNewOrder:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];

    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"我的发布";
    titleLabel.frame = CGRectMake((kScreenSize.width-100)/2, 20, 100, 44);
    titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    titleLabel.textColor = kBarLightTextColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;

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
    if ([SureGuideView shouldShowFaGuider]) {
        [SureGuideView sureGuideViewWithImageName:@"fa_view" imageCount:2];
    }
}

- (void)loadAllData
{
    self.orderPg += 1;
    [self getOrder];
}

- (void)loadNewData
{
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"加载中" inView:self.view];
    self.orderPg = 1;
    [self.orderArr removeAllObjects];
    [self getOrder];
}

- (void)getOrder
{
    NSDictionary *para = @{
                           @"pg":[NSNumber numberWithInt:self.orderPg]
                           };
    [[BaseNetworking sharedAPIManager]getMYOrderWith:para success:^(id response) {
        DeBugLog(@"订单是%@",response);
        [[HIPregressHUD shartMBHUD]hideLoading];
        [self.orderView.mj_header endRefreshing];
        if ([[response objectForKey:@"code"] intValue]==200) {
            [self.orderArr addObjectsFromArray:[response objectForKey:@"data"]];
            [self.orderView reloadData];
            if (self.orderArr.count<3) {
                self.orderView.mj_footer.hidden = YES;
            }else{
                self.orderView.mj_footer.hidden = NO;
            }
            if ([[response objectForKey:@"data"] count]==0) {
                self.orderView.mj_footer.state = MJRefreshStateNoMoreData;
            }else{
                self.orderView.mj_footer.state = MJRefreshStateIdle;
            }
        }else {
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:[[UIApplication sharedApplication] keyWindow]];
        }
    } fail:^(NSError *error) {

    }];
}


- (void)addNewOrder:(UIButton *)sender
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
    if (![[[publicGet objectForKey:@"data"] objectForKey:@"vxhao"] isEqualToString:@"null"]) {
        FaBuSetVXViewController *wx = [[FaBuSetVXViewController alloc]init];
        wx.doneSave = ^(NSInteger index) {
            HourseViewController *hourse = [[HourseViewController alloc]init];
            [self presentViewController:hourse animated:YES completion:^{

            }];
        };
        [self presentViewController:wx animated:YES completion:^{

        }];
    }else{
        HourseViewController *hourse = [[HourseViewController alloc]init];
        [self presentViewController:hourse animated:YES completion:^{

        }];
    }
}

- (void)showCarOrder
{
    if (![[[publicGet objectForKey:@"data"] objectForKey:@"vxhao"] isEqualToString:@"null"]) {
        FaBuSetVXViewController *wx = [[FaBuSetVXViewController alloc]init];
        wx.doneSave = ^(NSInteger index) {
            CarOrderViewController *carOrder = [[CarOrderViewController alloc]init];
            [self presentViewController:carOrder animated:YES completion:^{

            }];
        };
        [self presentViewController:wx animated:YES completion:^{

        }];
    }else{
        CarOrderViewController *carOrder = [[CarOrderViewController alloc]init];
        [self presentViewController:carOrder animated:YES completion:^{

        }];
    }
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.orderArr objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"type"] isEqualToString:@"yc"]) {//车

        MyCarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        if (!cell) {
            cell = [[MyCarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carcell"];
        }
        [cell cellConfigWithItem:[self.orderArr objectAtIndex:indexPath.row] andIndex:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[dic objectForKey:@"isComplete"] intValue]==0) {//未完成
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
        MyHouseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[MyHouseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell cellConfigWithItem:[self.orderArr objectAtIndex:indexPath.row] andIndex:indexPath];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([[dic objectForKey:@"isComplete"] intValue]==0) {//未完成
            cell.hideModelDoneView = YES;
            cell.copyWx = ^(NSIndexPath *indexPath){
                [self copyWx:indexPath];
            };
            cell.moreNext = ^(NSIndexPath *indexPath){
                [self showMore:indexPath];
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
    NSDictionary *dic = [self.orderArr objectAtIndex:indexPath.row];
    if ([[dic objectForKey:@"type"] isEqualToString:@"yc"]) {//车
        CGFloat height = [self heightForText1:[dic objectForKey:@"from"]];
        CGFloat height2 = [self heightForText1:[dic objectForKey:@"to"]];
        return 241 + height2 +height;
    }else{
        NSString *str = [[self.orderArr objectAtIndex:indexPath.row] objectForKey:@"yaoqiu"];
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
        return [self.orderView cellHeightForIndexPath:indexPath model:str keyPath:@"text" cellClass:[MyHouseTableViewCell class] contentViewWidth:kScreenSize.width];
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
        [self deleteSingleOrder:indexPath];
    }];
    [done setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:done];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"不再显示所有已完成订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteMoreOrder:indexPath];
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
    NSDictionary *dic = [self.orderArr objectAtIndex:indexPath.row];

    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string= [dic objectForKey:@"vxhao"];
    [[HIPregressHUD shartMBHUD]showAlertWith:@"微信号已复制到剪切板" inView:self.view];
}

- (void)showMore:(NSIndexPath *)indexPath
{
    DeBugLog(@"展示是%ld",(long)indexPath.row);
    NSDictionary *dic = [self.orderArr objectAtIndex:indexPath.row];
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"复制订单内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *orderContent = @"";
        if ([[dic objectForKey:@"type"] isEqualToString:@"ms"]) {
            orderContent = [NSString stringWithFormat:@"%@\n游客预算:%@%@\n入住时间:%@,退房时间：%@共计%@晚，入住:%@人\n介绍人:%@\n要求:%@\n微信号:%@\n本订单信息来自MoxiSharing，更多用房用车订单尽在http://orders.moxi.gg",[dic objectForKey:@"title"],[dic objectForKey:@"priceType"],[dic objectForKey:@"price"],[NSString stringWithFormat:@"%@月%@日",[[dic objectForKey:@"ruzhu"] substringToIndex:2],[[dic objectForKey:@"ruzhu"] substringFromIndex:2]],[NSString stringWithFormat:@"%@月%@日",[[dic objectForKey:@"ruzhu"] substringToIndex:2],[[dic objectForKey:@"tuifang"] substringFromIndex:2]],[dic objectForKey:@"wan"],[dic objectForKey:@"renshu"],[dic objectForKey:@"nickName"],[dic objectForKey:@"yaoqiu"],[dic objectForKey:@"vxhao"]];
        }else{
            NSString * time = [NSString stringWithFormat:@"%@月%@日 %@",[[dic objectForKey:@"time"]substringWithRange:NSMakeRange(5, 2)],[[dic objectForKey:@"time"]substringWithRange:NSMakeRange(8, 2)],[[dic objectForKey:@"time"]substringWithRange:NSMakeRange(11, 5)]];

            orderContent = [NSString stringWithFormat:@"%@\n游客预算:%@%@\n乘车时间:%@,共计:%@人\n介绍人:%@\n微信号:%@\n本订单信息来自MoxiSharing，更多用房用车订单尽在http://orders.moxi.gg",[dic objectForKey:@"title"],[dic objectForKey:@"priceType"],[dic objectForKey:@"price"],time,[dic objectForKey:@"renshu"],[dic objectForKey:@"nickName"],[dic objectForKey:@"vxhao"]];
        }
        UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string= orderContent;
        [[HIPregressHUD shartMBHUD]showAlertWith:@"订单内容已复制到剪贴板" inView:self.view];
    }];
    [done setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:done];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"订单已完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self completeOrder:indexPath];
    }];
    [cancel1 setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:cancel1];

    UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:@"删除订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteSingleOrder:indexPath];
    }];
    [cancel2 setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:cancel2];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [cancel setValue:kFocusTextColor forKey:@"titleTextColor"];
    [alertView addAction:cancel];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (void)completeOrder:(NSIndexPath *)indexPath
{
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"提交中..." inView:self.view];
    NSMutableDictionary *orderInfo = [NSMutableDictionary dictionaryWithDictionary:[self.orderArr objectAtIndex:indexPath.row]];
    NSDictionary *para=nil;
    if ([[orderInfo objectForKey:@"type"] isEqualToString:@"ms"]) {
        para = @{@"ids":[orderInfo objectForKey:@"id"],@"type":@"ms"};
    }else{
        para = @{@"ids":[orderInfo objectForKey:@"id"],@"type":@"yc"};
    }
    [[BaseNetworking sharedAPIManager] completeOrderWith:para success:^(id response) {
        DeBugLog(@"订单是%@",response);
        [[HIPregressHUD shartMBHUD]hideLoading];
        if ([[response objectForKey:@"code"] intValue]==200) {
            [orderInfo setObject:@"1" forKey:@"isComplete"];
            [self.orderArr replaceObjectAtIndex:indexPath.row withObject:orderInfo];
            [self.orderView reloadRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationNone];
        }else {
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:[[UIApplication sharedApplication] keyWindow]];
        }
    } fail:^(NSError *error) {

    }];

}

- (void)deleteSingleOrder:(NSIndexPath *)indexPath
{
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"提交中..." inView:self.view];
    NSMutableDictionary *orderInfo = [NSMutableDictionary dictionaryWithDictionary:[self.orderArr objectAtIndex:indexPath.row]];
    NSDictionary *para=nil;
    if ([[orderInfo objectForKey:@"type"] isEqualToString:@"ms"]) {
        para = @{@"ids":[orderInfo objectForKey:@"id"],@"type":@"ms"};
    }else{
        para = @{@"ids":[orderInfo objectForKey:@"id"],@"type":@"yc"};
    }
    [[BaseNetworking sharedAPIManager] deleteOrderWith:para success:^(id response) {
        DeBugLog(@"订单是%@",response);
        [[HIPregressHUD shartMBHUD]hideLoading];
        if ([[response objectForKey:@"code"] intValue]==200) {
            [self.orderArr removeObjectAtIndex:indexPath.row];
            [self.orderView reloadData];
        }else {
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:[[UIApplication sharedApplication] keyWindow]];
        }
    } fail:^(NSError *error) {

    }];
}

- (void)deleteMoreOrder:(NSIndexPath *)indexPath
{
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"提交中..." inView:self.view];
    NSString *msids = @"";
    NSString *ycids = @"";
    for (int i = 0; i< self.orderArr.count; i++) {
        NSDictionary *dic = [self.orderArr objectAtIndex:i];
        if ([[dic objectForKey:@"isComplete"] intValue]==1) {
            if ([[dic objectForKey:@"type"]isEqualToString:@"yc"]) {
                ycids = [NSString stringWithFormat:@"%@|",[dic objectForKey:@"id"]];
            }else{
                msids = [NSString stringWithFormat:@"%@|",[dic objectForKey:@"id"]];
            }
        }
    }
    if (ycids.length>0) {
        ycids = [ycids substringToIndex:ycids.length-1];
    }
    if (msids.length>0) {
        msids = [msids substringToIndex:msids.length-1];
    }
    __block BOOL ycBool = NO;
    __block BOOL msBool = NO;
        // 创建组
    dispatch_group_t group = dispatch_group_create();
        // 将第一个网络请求任务添加到组中
    if (ycids.length>0) {

        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 创建信号量
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                // 开始网络请求任务
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://share-app.moxi.gg/yc/delete/?id=%@",ycids]
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if ([[responseObject objectForKey:@"code"] intValue]==200) {
                         ycBool = YES;
                     }else {
                         [[HIPregressHUD shartMBHUD]showAlertWith:[responseObject objectForKey:@"msg"] inView:self.view];
                     }
                     dispatch_semaphore_signal(semaphore);
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     dispatch_semaphore_signal(semaphore);
                 }];
                // 在网络请求任务成功之前，信号量等待中
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
        // 将第二个网络请求任务添加到组中
    if (msids.length>0) {

        dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 创建信号量
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                // 开始网络请求任务
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager GET:[NSString stringWithFormat:@"http://share-app.moxi.gg/ms/delete/?id=%@",msids]
              parameters:nil
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     if ([[responseObject objectForKey:@"code"] intValue]==200) {
                         msBool = YES;
                     }else {
                         [[HIPregressHUD shartMBHUD]showAlertWith:[responseObject objectForKey:@"msg"] inView:self.view];
                     }

                     dispatch_semaphore_signal(semaphore);
                 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                     dispatch_semaphore_signal(semaphore);
                 }];
                // 在网络请求任务成功之前，信号量等待中
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        });
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [[HIPregressHUD shartMBHUD]hideLoading];
        if (ycBool) {

            for (int i = 0; i<self.orderArr.count; i++) {
                NSDictionary *dic = [self.orderArr objectAtIndex:i];
                if ([[dic objectForKey:@"isComplete"] intValue]==1 && [[dic objectForKey:@"type"] isEqualToString:@"yc"]) {
                    [self.orderArr removeObjectAtIndex:i];
                }
            }
            [self.orderView reloadData];
        }else{
            [[HIPregressHUD shartMBHUD]showAlertWith:@"批量删除用车订单失败" inView:self.view];
        }

        if (msBool) {
            for (int i = 0; i<self.orderArr.count; i++) {
                NSDictionary *dic = [self.orderArr objectAtIndex:i];
                if ([[dic objectForKey:@"isComplete"] intValue]==1 && [[dic objectForKey:@"type"] isEqualToString:@"ms"]) {
                    [self.orderArr removeObjectAtIndex:i];
                }
            }
            [self.orderView reloadData];
        }else{
            [[HIPregressHUD shartMBHUD]showAlertWith:@"批量删除民宿订单失败" inView:self.view];

        }
    });
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
