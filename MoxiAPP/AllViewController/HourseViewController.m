//
//  HourseViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/26.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "HourseViewController.h"
#import "UnderlineTextField.h"
#import "DVSwitch.h"
#define MAX_PLACE_NUMS     101
#define MAX_TITLE_NUMS     16

@interface HourseViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    CGFloat _textFontSize;// 当前文本字号，因为你说的是高度，所以字号还要计算
    NSInteger _textRowCount;// 当前文本的行数
}
@property (nonatomic, strong) UITableView *orderTableView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *carTakeDate;
@property (nonatomic, strong) UILabel *carTakeDateLabel;
@property (nonatomic, strong) UIButton *carTakeTime;
@property (nonatomic, strong) UILabel *carTakeTimeLabel;
    //
@property (nonatomic, strong) UIButton *peopleMinusButton;
@property (nonatomic, strong) UIButton *peoplePlusButton;
@property (nonatomic, strong) UILabel *peopleTitleLeft;
@property (nonatomic, strong) UILabel *peopleTitleRight;
@property (nonatomic, strong) UILabel *peopleNum;
    //
@property (nonatomic, strong) UILabel *regionTitle;
@property (nonatomic, strong) UIButton *regionValue;
@property (nonatomic, strong) UIImageView *upRegionView;
@property (nonatomic, strong) UIImageView *downRegionView;
    //
@property (nonatomic, strong) UILabel *moneyTitle;
@property (nonatomic, strong) UnderlineTextField *moneyValue;
@property (nonatomic, strong) DVSwitch *selectMoney;
    //
@property (nonatomic, strong) UILabel *carTitle;
@property (nonatomic, strong) UITextView *carTitleText;
    //
@property (nonatomic, strong) UILabel *startPlaceTitle;
@property (nonatomic, strong) UITextView *startPlaceValue;
    //
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation HourseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view.
    _textFontSize = 20.0;
    _textRowCount = 2;
    UIImageView *backgroundImage = [[UIImageView alloc]initWithFrame:self.view.bounds];
    backgroundImage.image = [UIImage imageNamed:@"back_ground_image"];
    [self.view addSubview:backgroundImage];

    UIButton *backNavi = [UIButton buttonWithType:UIButtonTypeCustom];
    [backNavi setImage:[[UIImage imageNamed:@"close_icon"] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.view addSubview:backNavi];
    [backNavi addTarget:self action:@selector(backNavi) forControlEvents:UIControlEventTouchUpInside];
    [backNavi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(8);
        make.top.equalTo(self.view.mas_top).offset(20);
        make.height.equalTo(@44);
        make.width.equalTo(@44);
    }];


    _orderTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64-64) style:UITableViewStylePlain];
    _orderTableView.delegate = self;
    _orderTableView.dataSource = self;
    _orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _orderTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_orderTableView];
    [self.view addSubview:self.commitButton];
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@64);
    }];
}
#pragma mark cellOne
- (UIButton *)carTakeDate
{
    if (!_carTakeDate) {
        _carTakeDate = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carTakeDate setTitle:@"入住时间" forState:UIControlStateNormal];
        [_carTakeDate addTarget:self action:@selector(showCarTakeDate:) forControlEvents:UIControlEventTouchUpInside];
        _carTakeDate.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    return _carTakeDate;
}

- (UIButton *)carTakeTime
{
    if (!_carTakeTime) {
        _carTakeTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carTakeTime setTitle:@"退房时间" forState:UIControlStateNormal];
        [_carTakeTime addTarget:self action:@selector(showCarTakeTime:) forControlEvents:UIControlEventTouchUpInside];
        _carTakeTime.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    return _carTakeTime;
}

- (UILabel *)carTakeDateLabel
{
    if (!_carTakeDateLabel) {
        _carTakeDateLabel = [[UILabel alloc]init];
        _carTakeDateLabel.text = @"入住时间";
        _carTakeDateLabel.textColor = kLeftCellTitleColor;
        _carTakeDateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _carTakeDateLabel;
}

- (UILabel *)carTakeTimeLabel
{
    if (!_carTakeTimeLabel) {
        _carTakeTimeLabel = [[UILabel alloc]init];
        _carTakeTimeLabel.text = @"退房时间";
        _carTakeTimeLabel.textColor = kLeftCellTitleColor;
        _carTakeTimeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _carTakeTimeLabel;
}
#pragma mark cellTwo
- (UIButton *)peopleMinusButton
{
    if (!_peopleMinusButton) {
        _peopleMinusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_peopleMinusButton setImage:[[UIImage imageNamed:@"num_minus"] imageByTintColor:kLeftCellTitleColor] forState:UIControlStateNormal];
        [_peopleMinusButton addTarget:self action:@selector(peopleMinus:) forControlEvents:UIControlEventTouchUpInside];
        _peopleMinusButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    return _peopleMinusButton;
}

- (UIButton *)peoplePlusButton
{
    if (!_peoplePlusButton) {
        _peoplePlusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_peoplePlusButton setImage:[[UIImage imageNamed:@"num_plus"] imageByTintColor:kLeftCellTitleColor] forState:UIControlStateNormal];
        [_peoplePlusButton addTarget:self action:@selector(peoplePlus:) forControlEvents:UIControlEventTouchUpInside];
        _peoplePlusButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    return _peoplePlusButton;
}

- (UILabel *)peopleTitleLeft
{
    if (!_peopleTitleLeft) {
        _peopleTitleLeft = [[UILabel alloc]init];
        _peopleTitleLeft.text = @"房客";
        _peopleTitleLeft.textColor = [UIColor whiteColor];
        _peopleTitleLeft.font = [UIFont systemFontOfSize:20];
    }
    return _peopleTitleLeft;
}

- (UILabel *)peopleTitleRight
{
    if (!_peopleTitleRight) {
        _peopleTitleRight = [[UILabel alloc]init];
        _peopleTitleRight.text = @"人";
        _peopleTitleRight.textColor = [UIColor whiteColor];
        _peopleTitleRight.font = [UIFont systemFontOfSize:20];
    }
    return _peopleTitleRight;
}

- (UILabel *)peopleNum
{
    if (!_peopleNum) {
        _peopleNum = [[UILabel alloc]init];
        _peopleNum.text = @"0";
        _peopleNum.textColor = [UIColor whiteColor];
        _peopleNum.font = [UIFont systemFontOfSize:20];
    }
    return _peopleNum;
}
#pragma mark cellThree
- (UILabel *)regionTitle
{
    if (!_regionTitle) {
        _regionTitle = [[UILabel alloc]init];
        _regionTitle.text = @"地区";
        _regionTitle.textColor = kLeftCellTitleColor;
        _regionTitle.font = [UIFont systemFontOfSize:20];
    }
    return _regionTitle;
}

- (UIButton *)regionValue
{
    if (!_regionValue) {
        _regionValue = [UIButton buttonWithType:UIButtonTypeCustom];
        [_regionValue setTitle:@"大阪" forState:UIControlStateNormal];
        [_regionValue addTarget:self action:@selector(peoplePlus:) forControlEvents:UIControlEventTouchUpInside];
        _regionValue.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    return _regionValue;
}

- (UIImageView *)upRegionView
{
    if (!_upRegionView) {
        _upRegionView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_up"]];
    }
    return _upRegionView;
}

- (UIImageView *)downRegionView
{
    if (!_downRegionView) {
        _downRegionView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return _downRegionView;
}

#pragma mark cellMoney

- (UILabel *)moneyTitle
{
    if (!_moneyTitle) {
        _moneyTitle = [[UILabel alloc]init];
        _moneyTitle.text = @"预算";
        _moneyTitle.textColor = kLeftCellTitleColor;
        _moneyTitle.font = [UIFont systemFontOfSize:20];
    }
    return _moneyTitle;
}

- (UITextField *)moneyValue
{
    if (!_moneyValue) {
        _moneyValue = [UnderlineTextField new];
        _moneyValue.borderStyle = UITextBorderStyleNone;
        _moneyValue.keyboardType = UIKeyboardTypeNumberPad;
        _moneyValue.tintColor = [UIColor whiteColor];
        _moneyValue.textColor = [UIColor whiteColor];
    }
    return _moneyValue;
}

- (DVSwitch *)selectMoney
{
    if (!_selectMoney) {
        @weakify(self);
        _selectMoney = [[DVSwitch alloc] initWithStringsArray:@[@"CNY", @"JPY"]];
        _selectMoney.backgroundColor = [UIColor clearColor];
        _selectMoney.cornerRadius = 15;
        _selectMoney.layer.borderColor = [UIColor whiteColor].CGColor;
        _selectMoney.layer.borderWidth = 1;
        _selectMoney.layer.cornerRadius = 15;
        _selectMoney.layer.masksToBounds = YES;
        _selectMoney.labelTextColorInsideSlider = kFocusTextColor;
        [_selectMoney setPressedHandler:^(NSUInteger index) {
            @strongify(self);
            [self selectMoneyTpye:index];
        }];
    }
    return _selectMoney;
}
#pragma mark cartitle

- (UILabel *)carTitle
{
    if (!_carTitle) {
        _carTitle = [[UILabel alloc]init];
        _carTitle.text = @"标题";
        _carTitle.textColor = kLeftCellTitleColor;
        _carTitle.font = [UIFont systemFontOfSize:20];
    }
    return _carTitle;
}

- (UITextView *)carTitleText
{
    if (!_carTitleText) {
        _carTitleText =  [[UITextView alloc] init];
        _carTitleText.frame = CGRectMake(0, 0, 100, 44);
        _carTitleText.delegate = self;
        _carTitleText.backgroundColor = [UIColor clearColor];
        _carTitleText.tintColor = [UIColor whiteColor];
        _carTitleText.scrollEnabled = NO;
        _carTitleText.textColor = [UIColor whiteColor];
        _carTitleText.font = [UIFont systemFontOfSize:20];
    }
    return _carTitleText;
}

- (UILabel *)startPlaceTitle
{
    if (!_startPlaceTitle) {
        _startPlaceTitle = [[UILabel alloc]init];
        _startPlaceTitle.text = @"要求";
        _startPlaceTitle.textColor = kLeftCellTitleColor;
        _startPlaceTitle.font = [UIFont systemFontOfSize:20];
    }
    return _startPlaceTitle;
}

- (UITextView *)startPlaceValue
{
    if (!_startPlaceValue) {
        _startPlaceValue =  [[UITextView alloc] init];
        _startPlaceValue.frame = CGRectMake(0, 0, 100, 44);
        _startPlaceValue.delegate = self;
        _startPlaceValue.backgroundColor = [UIColor clearColor];
        _startPlaceValue.tintColor = [UIColor whiteColor];
        _startPlaceValue.scrollEnabled = NO;
        _startPlaceValue.textColor = [UIColor whiteColor];
        _startPlaceValue.font = [UIFont systemFontOfSize:20];
    }
    return _startPlaceValue;
}

- (UIButton *)commitButton
{
    if (!_commitButton) {
        _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_commitButton setImage:[UIImage imageNamed:@"commit_info_icon"] forState:UIControlStateNormal];
        [_commitButton addTarget:self action:@selector(commitOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitButton;
}

- (void)backNavi
{
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}

#pragma mark textview delegate

/**
 * 代理方法，每次textView的改变都会调用，判断字号是否合适
 **/


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSInteger num = 0;
    if ([textView isEqual:self.carTitleText]) {
        num = MAX_TITLE_NUMS;
    }else{
        num = MAX_PLACE_NUMS;
    }
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];

    NSInteger caninputlen = num - comcatstr.length;

    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSString *title = [NSString stringWithFormat:@"最多输入%ld字",num];
        [[HIPregressHUD shartMBHUD] showAlertWith:title inView:self.view];
        NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};

        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];

            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }

}

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"this text is %@", textView.text);
    if (![textView isEqual:self.carTitleText]) {
        if (textView.text.length == 0) {
            _textFontSize = 20;
            [textView setFont:[UIFont systemFontOfSize:_textFontSize]];
        }
        CGFloat textWidth = [textView.text sizeWithFont:[UIFont systemFontOfSize:_textFontSize]].width;
        if (textWidth >= textView.frame.size.width * _textRowCount) {
            _textFontSize = [self _getTextFontSizeWithTextHeight:textView.frame.size.height / (2* _textRowCount) textString:textView.text]-2;
            _textRowCount++;
            [textView setFont:[UIFont systemFontOfSize:_textFontSize]];
        }
    }
}
/**
 * 计算字号
 **/
- (CGFloat)_getTextFontSizeWithTextHeight:(CGFloat)p_textHeight textString:(NSString*)textString {
    CGFloat retSize = 1.0;
    while ([textString sizeWithFont:[UIFont systemFontOfSize:retSize]].height < p_textHeight) {
        retSize++;
    }
    return retSize;
}

- (void)showCarTakeDate:(UIButton *)button
{
    DeBugLog(@"显示日期");
}

- (void)showCarTakeTime:(UIButton *)button
{
    DeBugLog(@"显示时间");
}

- (void)peopleMinus:(UIButton *)button
{
    DeBugLog(@"减少人数");

}

- (void)peoplePlus:(UIButton *)button
{
    DeBugLog(@"增加人数");

}

- (void)selectMoneyTpye:(NSUInteger)index
{
    DeBugLog(@"选中%@",index == 0 ? @"人民币":@"日元");
}

- (void)commitOrder:(UIButton *)button
{
    DeBugLog(@"commit all infomation");
}

#pragma mark delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cell = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    UITableViewCell *orderCell = [tableView dequeueReusableCellWithIdentifier:cell];
    if (!orderCell) {
        orderCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell];
    }
    orderCell.selectionStyle = UITableViewCellSelectionStyleNone;
    orderCell.backgroundColor = [UIColor clearColor];
    switch (indexPath.row) {
        case 0:
        {
            [self configTimeCell:orderCell];
            break;
        }
        case 1:
        {
            [self configPeopleCell:orderCell];
            break;
        }
        case 2:
        {
            [self configRegionCell:orderCell];
            break;
        }
        case 3:
        {
            [self configMoneyCell:orderCell];
            break;
        }
        case 4:
        {
            [self configCarTitleCell:orderCell];
            break;
        }
        case 5:
        {
            [self configStartPlaceCell:orderCell];
            break;
        }

        default:
            break;
    }
    return orderCell;
}

- (void)configTimeCell:(UITableViewCell *)cell
{
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"house_line"] imageByTintColor:[UIColor colorWithRed:0.969 green:0.886 blue:0.788 alpha:1.00]]];
    [cell addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.centerY.equalTo(cell.mas_centerY).offset(-5);
        make.width.equalTo(@40);
    }];

    [cell addSubview:self.carTakeTime];
    [cell addSubview:self.carTakeDate];
    [cell addSubview:self.carTakeDateLabel];
    [cell addSubview:self.carTakeTimeLabel];
        //    self.carTakeTimeLabel.hidden = YES;
        //    self.carTakeDateLabel.hidden = YES;
    [_carTakeDate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.right.equalTo(lineView.mas_left).offset(-10);
    }];

    [_carTakeTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(lineView.mas_centerY);
        make.left.equalTo(lineView.mas_right).offset(10);
    }];

    [_carTakeDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.carTakeDate.mas_top);
        make.right.equalTo(self.carTakeDate.mas_right);
    }];
    [_carTakeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.carTakeTime.mas_top);
        make.left.equalTo(self.carTakeTime.mas_left);
    }];
}

- (void)configPeopleCell:(UITableViewCell *)cell
{
    [cell addSubview:self.peopleMinusButton];
    [cell addSubview:self.peoplePlusButton];
    [cell addSubview:self.peopleTitleLeft];
    [cell addSubview:self.peopleTitleRight];
    [cell addSubview:self.peopleNum];

    [_peopleNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.centerX.equalTo(cell.mas_centerX).offset(15);
    }];

    [_peopleTitleLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(_peopleNum.mas_left).offset(-10);
    }];

    [_peopleTitleRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.left.equalTo(_peopleNum.mas_right).offset(10);

    }];

    [_peopleMinusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.left.equalTo(cell.mas_left).offset(40);
            //        make.centerX.equalTo(cell.mas_centerX).multipliedBy(0.5);
    }];

    [_peoplePlusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-40);
            //        make.centerX.equalTo(cell.mas_centerX).multipliedBy(1.5);
    }];
}

- (void)configRegionCell:(UITableViewCell *)cell
{
    [cell addSubview:self.regionValue];
    [cell addSubview:self.regionTitle];
    [cell addSubview:self.upRegionView];
    [cell addSubview:self.downRegionView];

    [_regionValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.centerX.equalTo(cell.mas_centerX);
    }];

    [_regionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.left.equalTo(cell.mas_left).offset(25);
        make.width.equalTo(@60);
    }];

    [_upRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.bottom.equalTo(_regionValue.mas_top).offset(0);
    }];

    [_downRegionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(cell.mas_centerX);
        make.top.equalTo(_regionValue.mas_bottom).offset(0);
    }];
}

- (void)configMoneyCell:(UITableViewCell *)cell
{
    [cell addSubview:self.moneyTitle];
    [cell addSubview:self.moneyValue];
    [cell addSubview:self.selectMoney];
    [_moneyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.left.equalTo(cell.mas_left).offset(25);
        make.width.equalTo(@60);
    }];

    [_moneyValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.left.equalTo(_moneyTitle.mas_right).offset(15);
        make.right.equalTo(_selectMoney.mas_left).offset(-15);
        make.width.equalTo(@(self.view.frame.size.width - 195-40));
    }];

    [_selectMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.mas_centerY);
        make.width.equalTo(@130);
        make.height.equalTo(@30);
        make.right.equalTo(cell.mas_right).offset(-10);
    }];
}

- (void)configCarTitleCell:(UITableViewCell *)cell
{
    [cell addSubview:self.carTitle];
    [cell addSubview:self.carTitleText];
    [_carTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(7);
        make.left.equalTo(cell.mas_left).offset(25);
        make.width.equalTo(@60);
    }];

    [_carTitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(0);
        make.left.equalTo(_carTitle.mas_right).offset(15);
        make.right.equalTo(cell.mas_right).offset(-15);
        make.width.equalTo(@(self.view.frame.size.width - 195-40));
        make.height.equalTo(@65);
    }];
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = kSepetorColor;
    [cell addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left).offset(35);
        make.right.equalTo(cell.mas_right).offset(-35);
        make.top.equalTo(cell.mas_bottom).offset(-10);
        make.height.equalTo(@1);
    }];
}

- (void)configStartPlaceCell:(UITableViewCell *)cell
{
    [cell addSubview:self.startPlaceTitle];
    [_startPlaceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(7);
        make.left.equalTo(cell.mas_left).offset(25);
        make.width.equalTo(@70);
    }];
    [cell addSubview:self.startPlaceValue];
    [_startPlaceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(0);
        make.left.equalTo(_startPlaceTitle.mas_right).offset(5);
        make.right.equalTo(cell.mas_right).offset(-15);
        make.width.equalTo(@(self.view.frame.size.width - 195-40));
        make.height.equalTo(@100);
    }];

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            return 84;
            break;
        }
        case 1:{
            return 50;
            break;
        }
        case 4:{
            return 75;
            break;
        }
        case 5:{
            return 100;
            break;
        }
        case 6:{
            return 150;
            break;
        }

        default:
            return 50;
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

@end
