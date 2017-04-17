//
//  HomeViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "HomeViewController.h"
#import "JDDropView.h"
#import "HouseTableViewCell.h"
#import "CarTableViewCell.h"
#import "CarOrderViewController.h"
#import "HourseViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import <AFHTTPSessionManager.h>
typedef enum : NSUInteger {
    CarOrderType,
    HourseOrderType,
} OrderType;

@interface HomeViewController ()<DropViewDataSource,DropViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *changeLocationItem;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, copy)   NSArray  *dataA2;
@property (nonatomic, assign) BOOL isShowDropView;
@property (nonatomic, strong) JDDropView *dropDwonView;
@property (nonatomic, strong) UIButton *locationChange;
@property (nonatomic, assign) BOOL isShowTag;
@property (nonatomic, strong) UITableView *orderView;
@property (nonatomic, strong) NSMutableArray *orderArr;
@property (nonatomic, assign) int orderPg;
@property (nonatomic, strong) NSString *orderRegion;
@property (nonatomic, strong) NSString *hourseOrderTopId;
@property (nonatomic, strong) NSString *carOrderTopId;
@property (nonatomic, assign) OrderType orderType;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
//    self.navigationItem.titleView.alpha = 0;
//    self.navigationItem.leftBarButtonItem.customView.alpha = 0;
//    self.navigationItem.rightBarButtonItem.customView.alpha = 0;

}

- (void)showAnimation:(NSNotification *)userInfo
{
    self.navigationItem.titleView.alpha = 0;
    self.navigationItem.leftBarButtonItem.customView.alpha = 0;
    self.navigationItem.rightBarButtonItem.customView.alpha = 0;
    NSDictionary *dic = userInfo.userInfo;
    BaseNaviViewController *navi = [dic objectForKey:@"key"];
    if ([[[navi viewControllers] firstObject] isKindOfClass:[HomeViewController class]]) {
        [UIView animateWithDuration:1 animations:^{
            self.navigationItem.titleView.alpha = 1;
            self.navigationItem.leftBarButtonItem.customView.alpha = 1;
            self.navigationItem.rightBarButtonItem.customView.alpha = 1;
        }];

    }
}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//
//}

- (void)setSubViews
{
        // Do any additional setup after loading the view.
    self.isShowTag = NO;
    self.isShowDropView = NO;
    self.orderArr = @[].mutableCopy;
    self.orderPg = 1;
    self.orderRegion = @"1";
    self.hourseOrderTopId = [[NSUserDefaults standardUserDefaults]objectForKey:kHourseTopIds];
    self.carOrderTopId = [[NSUserDefaults standardUserDefaults]objectForKey:kCarTopIds];
    self.orderType = HourseOrderType;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAnimation:) name:@"naviAlpha" object:nil];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 44, 44);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 15);
    [leftButton setImage:[[UIImage imageNamed:@"bar_user_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [leftButton addTarget:(BaseNaviViewController *)self.navigationController action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];

    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(0, 0, 44, 44);
    _rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    [_rightButton setImage:[[UIImage imageNamed:@"car_order_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(changLocation) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 101;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];

    _locationChange = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationChange.frame = CGRectMake(0, 0, 120, 44);
    [_locationChange setImage:[[UIImage imageNamed:@"change_location_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [_locationChange setTitle:@"东京" forState:UIControlStateNormal];
    [_locationChange setTitleColor:kBarLightTextColor forState:UIControlStateNormal];
    [_locationChange setTarget:self action:@selector(showAllLoaction) forControlEvents:UIControlEventTouchUpInside];
    _locationChange.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
    self.navigationItem.titleView = _locationChange;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Balloon"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];

    _orderView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-49-64) style:UITableViewStylePlain];
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
    self.hourseOrderTopId = [[NSUserDefaults standardUserDefaults]objectForKey:kHourseTopIds];
    self.carOrderTopId = [[NSUserDefaults standardUserDefaults]objectForKey:kCarTopIds];
    if (self.orderType == HourseOrderType) {

        NSDictionary *para = @{
                               @"diqu":self.orderRegion,
                               @"topid":self.hourseOrderTopId,
                               @"pg":[NSNumber numberWithInt:self.orderPg]
                               };
        [[BaseNetworking sharedAPIManager]getMSOrderWith:para success:^(id response) {
            DeBugLog(@"订单是%@",response);
            [[HIPregressHUD shartMBHUD]hideLoading];
            [self.orderView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] intValue]==200) {
                [self.orderArr addObjectsFromArray:[response objectForKey:@"data"]];
                [self.orderArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSInteger doorID1 = [[obj1 objectForKey:@"isTop"] integerValue];
                    NSInteger doorID2 = [[obj2 objectForKey:@"isTop"] integerValue];;
                    if (doorID1 > doorID2)
                        return NSOrderedAscending;
                    else
                        return NSOrderedAscending;
                }];
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
                [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
            }
        } fail:^(NSError *error) {
            
        }];
    }else{
        NSDictionary *para = @{
                               @"diqu":self.orderRegion,
                               @"topid":self.carOrderTopId,
                               @"pg":[NSNumber numberWithInt:self.orderPg]
                               };
        [[BaseNetworking sharedAPIManager]getYCOrderWith:para success:^(id response) {
            DeBugLog(@"yongche订单是%@",response);
            [[HIPregressHUD shartMBHUD]hideLoading];
            [self.orderView.mj_header endRefreshing];
            if ([[response objectForKey:@"code"] intValue]==200) {
                [self.orderArr addObjectsFromArray:[response objectForKey:@"data"]];
                [self.orderArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                    NSInteger doorID1 = [[obj1 objectForKey:@"isTop"] integerValue];
                    NSInteger doorID2 = [[obj2 objectForKey:@"isTop"] integerValue];;
                    if (doorID1 > doorID2)
                        return NSOrderedAscending;
                    else
                        return NSOrderedAscending;
                }];

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
                [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
            }
        } fail:^(NSError *error) {

        }];
    }
}

- (void)changLocation
{
    if (self.rightButton.tag == 101) {
        self.rightButton.tag = 102;
        [self.rightButton setImage:[UIImage imageNamed:@"house_order_icon"] forState:UIControlStateNormal];
        DeBugLog(@"changlocation hourse");
        self.orderType = CarOrderType;
        self.orderPg = 1;
        [self.orderArr removeAllObjects];
        [self loadNewData];
    }else{
        self.rightButton.tag = 101;
        [self.rightButton setImage:[UIImage imageNamed:@"car_order_icon"] forState:UIControlStateNormal];
        self.orderType = HourseOrderType;
        self.orderPg = 1;
        [self.orderArr removeAllObjects];
        [self loadNewData];
        DeBugLog(@"changlocation car");
    }
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
    OptionalConfiguration option = {9,7,7,15,6.5,YES,NO,YES,NO,{0.376, 0.255, 0.227},{1,1,1}};

    [KxMenu setTitleFont:[UIFont systemFontOfSize:20]];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-50, 6, 50, 60) menuItems:itemArr withOptions:option];
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

- (void)showAllLoaction
{
    DeBugLog(@"showAllLocation");
    if (!self.isShowDropView) {
        [self.dropDwonView menuBtnClick:nil];
        self.isShowDropView = YES;
    }else{
        [self.dropDwonView animationUp:1];
        self.isShowDropView = NO;
    }
}

- (JDDropView *)dropDwonView
{
    if (!_dropDwonView) {
        _dropDwonView = [[JDDropView alloc]initWithFrame:CGRectMake(0, -14, self.view.frame.size.width, 50)];
        _dropDwonView.bgView.alpha = 0.6;
        _dropDwonView.dataSource=self;
        _dropDwonView.delegate=self;
        @weakify(self);
        _dropDwonView.menuHide = ^(NSInteger index){
            @strongify(self);
            self.isShowDropView = NO;
        };
        _dataA2=@[@"东京",@"大阪",@"京都",@"名古屋",@"北海道",@"其它"];
        [self.view addSubview:_dropDwonView];
    }
    return _dropDwonView;
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [self.orderArr objectAtIndex:indexPath.row];
    if (self.orderType == CarOrderType) {//车

        CarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"carcell"];
        if (!cell) {
            cell = [[CarTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"carcell"];
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
        }else{//已完成
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
        cell.backgroundColor = [UIColor clearColor];
        [cell cellConfigWithItem:[self.orderArr objectAtIndex:indexPath.row] andIndex:indexPath];
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
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.orderType == CarOrderType) {//车
        NSString *str = [[self.orderArr objectAtIndex:indexPath.row] objectForKey:@"from"];
        NSString *str1 = [[self.orderArr objectAtIndex:indexPath.row] objectForKey:@"to"];
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
        CarModel *car = [[CarModel alloc]init];
        car.text = str;
        car.text1 = str1;
        return [self.orderView cellHeightForIndexPath:indexPath model:car keyPath:@"carModel" cellClass:[CarTableViewCell class] contentViewWidth:kScreenSize.width];
    }else{
        NSString *str = [[self.orderArr objectAtIndex:indexPath.row] objectForKey:@"yaoqiu"];
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
        return [self.orderView cellHeightForIndexPath:indexPath model:str keyPath:@"text" cellClass:[HouseTableViewCell class] contentViewWidth:kScreenSize.width];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
    if ([[dic objectForKey:@"isMine"] intValue]==1) {//自己的
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"复制订单内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *orderContent = @"";
            if (self.orderType == HourseOrderType) {
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

    }else{
        UIAlertController *alertView = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *done = [UIAlertAction actionWithTitle:@"复制订单内容" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *orderContent = @"";
            if (self.orderType == HourseOrderType) {
                orderContent = [NSString stringWithFormat:@"%@\n游客预算:%@%@\n入住时间:%@,退房时间：%@共计%@晚，入住:%@人\n介绍人:%@\n要求:%@\n微信号:%@\n本订单信息来自MoxiSharing，更多用房用车订单尽在http://orders.moxi.gg",[dic objectForKey:@"title"],[dic objectForKey:@"priceType"],[dic objectForKey:@"price"],[NSString stringWithFormat:@"%@月%@日",[[dic objectForKey:@"ruzhu"] substringToIndex:2],[[dic objectForKey:@"ruzhu"] substringFromIndex:2]],[NSString stringWithFormat:@"%@月%@日",[[dic objectForKey:@"ruzhu"] substringToIndex:2],[[dic objectForKey:@"tuifang"] substringFromIndex:2]],[dic objectForKey:@"wan"],[dic objectForKey:@"renshu"],[dic objectForKey:@"yaoqiu"],[dic objectForKey:@"nickName"],[dic objectForKey:@"vxhao"]];
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
        UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:@"订单置顶" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self topOrder:indexPath];
        }];
        [cancel1 setValue:kFocusTextColor forKey:@"titleTextColor"];
        [alertView addAction:cancel1];

        UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:@"不再显示该订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
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
}

#pragma mark dropview delegate

-(NSString *)titleForLeftInColum:(int)colum InCellIndexPath:(int)index
{
    return @"";
}
-(NSInteger)LeftTableViewCount:(int)colum
{
    return 2;
}
-(NSInteger)RightTableViewCount:(int)colum WithLeftIndex:(int)leftRow
{
    return _dataA2.count;

}
-(NSString *)titleForRightInColum:(int)colum WithLeftIndex:(int)leftRow InCellIndexPath:(int)index
{
    return _dataA2[index];
}
-(NSInteger)numberOfMenuInMenu:(JDDropView *)dropV
{
    return 1;

}
-(NSInteger)dropViewTypeInColum:(int)colum InMenu:(JDDropView *)dropV
{
    return 1;
}
-(void)didSelectRowInColum:(int)colum WithLeftRow:(int)leftRow WithRightRow:(int)rightRow
{
    DeBugLog(@"%d====%d===%d",colum,leftRow,rightRow);
    NSString *title = [_dataA2 objectAtIndex:rightRow];
    [_locationChange setTitle:title forState:UIControlStateNormal];
    if (rightRow != 5) {
        self.orderRegion = [NSString stringWithFormat:@"%d",rightRow+1];
    }else{
        self.orderRegion = @"0";
    }
    [self.orderArr removeAllObjects];
    self.orderPg = 1;
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"加载中" inView:self.view];
    [self getOrder];
}
-(void)didSelectItemsTagArray:(NSArray *)itemsA
{
    DeBugLog(@"%@",itemsA);
}

- (void)completeOrder:(NSIndexPath *)indexPath
{
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"提交中..." inView:self.view];
    NSMutableDictionary *orderInfo = [NSMutableDictionary dictionaryWithDictionary:[self.orderArr objectAtIndex:indexPath.row]];
    NSDictionary *para=nil;
    if (self.orderType == HourseOrderType) {
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
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
        }
    } fail:^(NSError *error) {

    }];
    
}

- (void)topOrder:(NSIndexPath *)indexPath
{
    NSMutableDictionary *orderInfo = [NSMutableDictionary dictionaryWithDictionary:[self.orderArr objectAtIndex:indexPath.row]];
    if (self.orderType == HourseOrderType) {
        [orderInfo setObject:@"1" forKey:@"isTop"];
        NSString *topids = [[NSUserDefaults standardUserDefaults]objectForKey:kHourseTopIds];
        if (topids.length == 0) {
            [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[orderInfo objectForKey:@"id"]] forKey:kHourseTopIds];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            NSString *newIds = [NSString stringWithFormat:@"%@|%@",topids,[orderInfo objectForKey:@"id"]];
            [[NSUserDefaults standardUserDefaults]setObject:newIds forKey:kHourseTopIds];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [self.orderArr replaceObjectAtIndex:indexPath.row withObject:orderInfo];
        [self.orderArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSInteger doorID1 = [[obj1 objectForKey:@"isTop"] integerValue];
            NSInteger doorID2 = [[obj2 objectForKey:@"isTop"] integerValue];;
            if (doorID1 > doorID2)
                return NSOrderedAscending;
            else
                return NSOrderedAscending;
        }];
        [self.orderView reloadData];
//        NSDictionary *para = @{
//                               @"diqu":self.orderRegion,
//                               @"topid":[orderInfo objectForKey:@"id"],
//                               @"pg":[NSNumber numberWithInt:self.orderPg]
//                               };
//        [[BaseNetworking sharedAPIManager]getMSOrderWith:para success:^(id response) {
//            DeBugLog(@"订单是%@",response);
//            [[HIPregressHUD shartMBHUD]hideLoading];
//            if ([[response objectForKey:@"code"] intValue]==200) {
//
//            }else {
//                [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
//            }
//        } fail:^(NSError *error) {
//
//        }];
    }else{
        [orderInfo setObject:@"1" forKey:@"isTop"];
        NSString *topids = [[NSUserDefaults standardUserDefaults]objectForKey:kCarTopIds];
        if (topids.length == 0) {
            [[NSUserDefaults standardUserDefaults]setObject:[orderInfo objectForKey:@"id"] forKey:kCarTopIds];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            NSString *newIds = [NSString stringWithFormat:@"%@|%@",topids,[orderInfo objectForKey:@"id"]];
            [[NSUserDefaults standardUserDefaults]setObject:newIds forKey:kCarTopIds];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        [self.orderArr replaceObjectAtIndex:indexPath.row withObject:orderInfo];
        [self.orderArr sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSInteger doorID1 = [[obj1 objectForKey:@"isTop"] integerValue];
            NSInteger doorID2 = [[obj2 objectForKey:@"isTop"] integerValue];;
            if (doorID1 > doorID2)
                return NSOrderedAscending;
            else
                return NSOrderedAscending;
        }];

        [self.orderView reloadData];
//        NSDictionary *para = @{
//                               @"diqu":self.orderRegion,
//                               @"topid":[orderInfo objectForKey:@"id"],
//                               @"pg":[NSNumber numberWithInt:self.orderPg]
//                               };
//        [[BaseNetworking sharedAPIManager]getYCOrderWith:para success:^(id response) {
//            DeBugLog(@"yongche订单是%@",response);
//            [[HIPregressHUD shartMBHUD]hideLoading];
//            if ([[response objectForKey:@"code"] intValue]==200) {
//
//            }else {
//                [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
//            }
//        } fail:^(NSError *error) {
//
//        }];
    }

}

- (void)deleteSingleOrder:(NSIndexPath *)indexPath
{
    [[HIPregressHUD shartMBHUD]showLoadingWith:@"提交中..." inView:self.view];
    NSMutableDictionary *orderInfo = [NSMutableDictionary dictionaryWithDictionary:[self.orderArr objectAtIndex:indexPath.row]];
    NSDictionary *para=nil;
    if (self.orderType == HourseOrderType) {
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
            [[HIPregressHUD shartMBHUD]showAlertWith:[response objectForKey:@"msg"] inView:self.view];
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
            if (self.orderType == CarOrderType) {
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
