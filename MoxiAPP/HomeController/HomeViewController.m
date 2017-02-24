//
//  HomeViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "HomeViewController.h"
#import "JDDropView.h"

@interface HomeViewController ()<DropViewDataSource,DropViewDelegate>

@property (nonatomic, strong) UIBarButtonItem *changeLocationItem;
@property (nonatomic, copy) NSArray  *dataA2;
@property (nonatomic, assign) BOOL isShowDropView;
@property (nonatomic, strong) JDDropView *dropDwonView;
@property (nonatomic, strong) UIButton *locationChange;
@property (nonatomic, assign) BOOL isShowTag;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSubViews];
}

- (void)setSubViews
{
        // Do any additional setup after loading the view.
    self.isShowTag = NO;
    self.view.backgroundColor = [UIColor redColor];
    self.isShowDropView = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"bar_user_icon"] imageByTintColor:kBarLightTextColor]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:(BaseNaviViewController *)self.navigationController
                                                                            action:@selector(showMenu)];

    self.changeLocationItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"house_order_icon"] imageByTintColor:kBarLightTextColor]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(changLocation)];
    self.changeLocationItem.tag = 101;
    UIBarButtonItem *addOrderItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"order_pulish_icon"] imageByTintColor:kBarLightTextColor]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(addNewOrder:)];

    self.navigationItem.rightBarButtonItems = @[addOrderItem,self.changeLocationItem];

    _locationChange = [UIButton buttonWithType:UIButtonTypeCustom];
    _locationChange.frame = CGRectMake(0, 0, 70, 44);
    [_locationChange setImage:[[UIImage imageNamed:@"change_location_icon"] imageByTintColor:kBarLightTextColor] forState:UIControlStateNormal];
    [_locationChange setTitle:@"大板" forState:UIControlStateNormal];
    [_locationChange setTitleColor:kBarLightTextColor forState:UIControlStateNormal];
    [_locationChange setTarget:self action:@selector(showAllLoaction) forControlEvents:UIControlEventTouchUpInside];
    _locationChange.titleLabel.font = [UIFont systemFontOfSize:17];
    [_locationChange setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, _locationChange.titleLabel.intrinsicContentSize.width)];
    [_locationChange setTitleEdgeInsets:UIEdgeInsetsMake(0, -_locationChange.currentImage.size.width, 0, -25)];
    self.navigationItem.titleView = _locationChange;

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = [UIImage imageNamed:@"Balloon"];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:imageView];
}

- (void)changLocation
{
    if (self.changeLocationItem.tag == 101) {
        self.changeLocationItem.tag = 102;
        self.changeLocationItem.image = [UIImage imageNamed:@"car_order_icon"];
        DeBugLog(@"changlocation hourse");
    }else{
        self.changeLocationItem.tag = 101;
        self.changeLocationItem.image = [UIImage imageNamed:@"house_order_icon"];
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
    OptionalConfiguration option = {9,7,7,8.5,6.5,YES,NO,YES,NO,{0.376, 0.255, 0.227},{1,1,1}};

    [KxMenu showMenuInView:self.view fromRect:CGRectMake(self.view.frame.size.width-50, 6, 50, 60) menuItems:itemArr withOptions:option];
//    if (![KxMenu isShow]) {
//    }else{
//        [KxMenu dismissMenu];
//    }
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
        _dropDwonView = [[JDDropView alloc]initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, 50)];
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
