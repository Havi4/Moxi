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

@interface HomeViewController ()<DropViewDataSource,DropViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIBarButtonItem *changeLocationItem;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, copy) NSArray  *dataA2;
@property (nonatomic, assign) BOOL isShowDropView;
@property (nonatomic, strong) JDDropView *dropDwonView;
@property (nonatomic, strong) UIButton *locationChange;
@property (nonatomic, assign) BOOL isShowTag;
@property (nonatomic, strong) UITableView *orderView;
@property (nonatomic, strong) NSMutableArray *dic;

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
    self.dic = @[].mutableCopy;
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
    [_rightButton setImage:[[UIImage imageNamed:@"house_order_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(changLocation) forControlEvents:UIControlEventTouchUpInside];
    self.rightButton.tag = 101;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_rightButton];

    _locationChange = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationChange.frame = CGRectMake(0, 0, 120, 44);
    [_locationChange setImage:[[UIImage imageNamed:@"change_location_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [_locationChange setTitle:@"大板" forState:UIControlStateNormal];
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

- (void)changLocation
{
    if (self.rightButton.tag == 101) {
        self.rightButton.tag = 102;
        [self.rightButton setImage:[UIImage imageNamed:@"car_order_icon"] forState:UIControlStateNormal];
        DeBugLog(@"changlocation hourse");
    }else{
        self.rightButton.tag = 101;
        [self.rightButton setImage:[UIImage imageNamed:@"house_order_icon"] forState:UIControlStateNormal];
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
        cell.backgroundColor = [UIColor clearColor];
        cell.text = [[self.dic objectAtIndex:indexPath.row] objectForKey:@"yaoqiu"];
        [cell cellConfigWithItem:[self.dic objectAtIndex:indexPath.row] andIndex:indexPath];
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
        NSString *str = [[self.dic objectAtIndex:indexPath.row] objectForKey:@"startPlace"];
        NSString *str1 = [[self.dic objectAtIndex:indexPath.row] objectForKey:@"endPlace"];
        /* model 为模型实例， keyPath 为 model 的属性名，通过 kvc 统一赋值接口 */
        CarModel *car = [[CarModel alloc]init];
        car.text = str;
        car.text1 = str1;
        return [self.orderView cellHeightForIndexPath:indexPath model:car keyPath:@"carModel" cellClass:[CarTableViewCell class] contentViewWidth:kScreenSize.width];
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
}
-(void)didSelectItemsTagArray:(NSArray *)itemsA
{
    DeBugLog(@"%@",itemsA);
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
