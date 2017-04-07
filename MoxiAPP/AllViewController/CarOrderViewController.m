//
//  CarOrderViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/26.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "CarOrderViewController.h"
#import "UnderlineTextField.h"
#import "DVSwitch.h"
#import "ActionSheetStringPicker.h"
#import "ActionSheetLocalePicker.h"
#import "ActionSheetDatePicker.h"
#define MAX_PLACE_NUMS     51
#define MAX_TITLE_NUMS     16

@interface CarOrderViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
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
@property (nonatomic, strong) NSString *moneyType;

//
@property (nonatomic, strong) UILabel *carTitle;
@property (nonatomic, strong) UITextView *carTitleText;
//
@property (nonatomic, strong) UILabel *startPlaceTitle;
@property (nonatomic, strong) UITextView *startPlaceValue;
//
@property (nonatomic, strong) UILabel *endPlaceTitle;
@property (nonatomic, strong) UITextView *endPlaceValue;
//
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation CarOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _textFontSize = 20.0;
    _textRowCount = 2;
    self.moneyType = @"JPY";
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
    _orderTableView.showsVerticalScrollIndicator = NO;
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
        [_carTakeDate setTitle:@"乘车日期" forState:UIControlStateNormal];
        [_carTakeDate addTarget:self action:@selector(showCarTakeDate:) forControlEvents:UIControlEventTouchUpInside];
        _carTakeDate.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    return _carTakeDate;
}

- (UIButton *)carTakeTime
{
    if (!_carTakeTime) {
        _carTakeTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [_carTakeTime setTitle:@"当日时间" forState:UIControlStateNormal];
        [_carTakeTime addTarget:self action:@selector(showCarTakeTime:) forControlEvents:UIControlEventTouchUpInside];
        _carTakeTime.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:25];
    }
    return _carTakeTime;
}

- (UILabel *)carTakeDateLabel
{
    if (!_carTakeDateLabel) {
        _carTakeDateLabel = [[UILabel alloc]init];
        _carTakeDateLabel.text = @"乘车日期";
        _carTakeDateLabel.textColor = kLeftCellTitleColor;
        _carTakeDateLabel.font = [UIFont systemFontOfSize:14];
    }
    return _carTakeDateLabel;
}

- (UILabel *)carTakeTimeLabel
{
    if (!_carTakeTimeLabel) {
        _carTakeTimeLabel = [[UILabel alloc]init];
        _carTakeTimeLabel.text = @"当日时间";
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
        _peopleTitleLeft.text = @"乘客";
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
        [_regionValue addTarget:self action:@selector(slectRegion:) forControlEvents:UIControlEventTouchUpInside];
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
        _startPlaceTitle.text = @"出发地";
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

- (UILabel *)endPlaceTitle
{
    if (!_endPlaceTitle) {
        _endPlaceTitle = [[UILabel alloc]init];
        _endPlaceTitle.text = @"目的地";
        _endPlaceTitle.textColor = kLeftCellTitleColor;
        _endPlaceTitle.font = [UIFont systemFontOfSize:20];
    }
    return _endPlaceTitle;
}

- (UITextView *)endPlaceValue
{
    if (!_endPlaceValue) {
        _endPlaceValue =  [[UITextView alloc] init];
        _endPlaceValue.frame = CGRectMake(0, 0, 100, 44);
        _endPlaceValue.delegate = self;
        _endPlaceValue.backgroundColor = [UIColor clearColor];
        _endPlaceValue.tintColor = [UIColor whiteColor];
        _endPlaceValue.scrollEnabled = NO;
        _endPlaceValue.textColor = [UIColor whiteColor];
        _endPlaceValue.font = [UIFont systemFontOfSize:20];
    }
    return _endPlaceValue;
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
    ActionSheetDatePicker *actionSheetPicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择日期" datePickerMode:UIDatePickerModeDate selectedDate:[NSDate date]
                                                          minimumDate:[NSDate date]
                                                          maximumDate:[[NSDate date] dateByAddingYears:1]
                                                               target:self action:@selector(dateWasSelected:element:) origin:button];
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(0, 0, 50, 32)];
    [actionSheetPicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:okButton]];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [cancelButton setFrame:CGRectMake(0, 0, 50, 32)];
    [actionSheetPicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];

    [actionSheetPicker showActionSheetPicker];
}

- (void)dateWasSelected:(NSDate *)selectedDate element:(id)element {
    DeBugLog(@"选中的时间是%@",selectedDate);
    if (!selectedDate) {
        return;
    }
    self.carTakeDateLabel.hidden = NO;
    NSString *date = [[NSString stringWithFormat:@"%@",[selectedDate dateByAddingHours:8]] substringWithRange:NSMakeRange(5, 5)];

    [self.carTakeDate setTitle:[NSString stringWithFormat:@"%@月%@日",[date substringWithRange:NSMakeRange(0, 2)],[date substringWithRange:NSMakeRange(3, 2)]] forState:UIControlStateNormal];
}

- (void)showCarTakeTime:(UIButton *)button
{
    DeBugLog(@"显示时间");
    ActionSheetDatePicker *datePicker = [[ActionSheetDatePicker alloc] initWithTitle:@"选择时间" datePickerMode:UIDatePickerModeTime selectedDate:[NSDate date]
                                                                                minimumDate:[NSDate date]
                                                                                maximumDate:[[NSDate date] dateByAddingDays:30]
                                                                                     target:self action:@selector(timeWasSelected:element:) origin:button];
    datePicker.minuteInterval = 1;
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(0, 0, 50, 32)];
    [datePicker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:okButton]];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [cancelButton setFrame:CGRectMake(0, 0, 50, 32)];
    [datePicker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];

    [datePicker showActionSheetPicker];
}

- (void)timeWasSelected:(NSDate *)selectedTime element:(id)element {
    DeBugLog(@"时间是%@",selectedTime);
    if (!selectedTime) {
        return;
    }
    self.carTakeTimeLabel.hidden = NO;
    NSString *date = [[NSString stringWithFormat:@"%@",[selectedTime dateByAddingHours:8]] substringWithRange:NSMakeRange(11, 5)];

    [self.carTakeTime setTitle:[NSString stringWithFormat:@"%@",date] forState:UIControlStateNormal];
}


- (void)peopleMinus:(UIButton *)button
{
    DeBugLog(@"减少人数");
    int num = [self.peopleNum.text intValue];
    num = num - 1;
    if (num < 0) {
        num = 0;
    }
    self.peopleNum.text = [NSString stringWithFormat:@"%d",num];
}

- (void)peoplePlus:(UIButton *)button
{
    DeBugLog(@"增加人数");
    int num = [self.peopleNum.text intValue];
    num = num + 1;
    self.peopleNum.text = [NSString stringWithFormat:@"%d",num];
}

- (void)selectMoneyTpye:(NSUInteger)index
{
    DeBugLog(@"选中%@",index == 0 ? @"人民币":@"日元");
}

- (void)commitOrder:(UIButton *)button
{
    DeBugLog(@"commit all infomation");
    if ([self.carTakeDate.titleLabel.text isEqualToString:@"乘车日期"]) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入乘车日期" inView:self.view];
        return;
    }else if ([self.carTakeTime.titleLabel.text isEqualToString:@"乘车时间"]) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入乘车时间" inView:self.view];
        return;
    }else if([self.peopleNum.text intValue] == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入乘客人数" inView:self.view];
        return;
    }else if(self.regionValue.titleLabel.text.length == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入地区" inView:self.view];
         return;
    }else if(self.moneyValue.text.length == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入预算金额" inView:self.view];
         return;
    }else if(self.carTitleText.text.length == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入标题" inView:self.view];
         return;
    }else if(self.startPlaceValue.text.length == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入出发地" inView:self.view];
         return;
    }else if(self.endPlaceValue.text.length == 0) {
        [[HIPregressHUD shartMBHUD]showAlertWith:@"请输入目的地" inView:self.view];
         return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单一旦建立将无法修改" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *done = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HIPregressHUD shartMBHUD]showLoadingWith:@"提交中" inView:self.view];
        [self commitSure];
    }];
    [alert addAction:done];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {

    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{

    }];
}

- (void)commitSure
{
    NSString *region = [NSString stringWithFormat:@"%d",(int)[regionArr indexOfObject:self.regionValue.titleLabel.text]];
    NSString *ruzhu = [NSString stringWithFormat:@"%@/%@",[self.carTakeDate.titleLabel.text substringWithRange:NSMakeRange(0, 2)],[self.carTakeDate.titleLabel.text substringWithRange:NSMakeRange(3, 2)]];
    NSDictionary *dic = @{
                          @"time":[NSString stringWithFormat:@"%@ %@",ruzhu,self.carTakeTime.titleLabel.text],
                          @"renshu":self.peopleNum.text,
                          @"diqu":region,
                          @"priceType":self.moneyType,
                          @"price":self.moneyValue.text,
                          @"title":self.carTitleText.text,
                          @"from":self.startPlaceValue.text,
                          @"to":self.endPlaceValue.text
                          };
    [[BaseNetworking sharedAPIManager] addCarOrderWith:(NSDictionary *)dic success:^(id response) {
        NSDictionary *dic = (NSDictionary *)response;
        [[HIPregressHUD shartMBHUD]hideLoading];
        if ([[dic objectForKey:@"code"] intValue]==200) {
            [self dismissViewControllerAnimated:YES completion:^{

                [[HIPregressHUD shartMBHUD]showAlertWith:@"用车订单发布成功" inView:[UIApplication sharedApplication].keyWindow];
            }];
        }
    } fail:^(NSError *error) {
        NSLog(@"错误是%@",error);
    }];
}

- (void)slectRegion:(UIButton *)button
{
    NSArray *colors = @[@"东京",@"大阪",@"京都",@"名古屋",@"北海道",@"其它"];

    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        [self.regionValue setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker){

    };
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"选择地区" rows:colors initialSelection:0 doneBlock:done cancelBlock:cancel origin:button];
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"完成" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton setFrame:CGRectMake(0, 0, 50, 32)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:okButton]];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    [cancelButton setFrame:CGRectMake(0, 0, 50, 32)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    [picker showActionSheetPicker];
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
        case 6:
        {
            [self configEndPlaceCell:orderCell];
            break;
        }


        default:
            break;
    }
    return orderCell;
}

- (void)configTimeCell:(UITableViewCell *)cell
{
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"car_line"] imageByTintColor:[UIColor colorWithRed:0.969 green:0.886 blue:0.788 alpha:1.00]]];
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
    self.carTakeTimeLabel.hidden = YES;
    self.carTakeDateLabel.hidden = YES;
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
        make.height.equalTo(@65);
    }];

}

- (void)configEndPlaceCell:(UITableViewCell *)cell
{
    [cell addSubview:self.endPlaceTitle];
    [_endPlaceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(7);
        make.left.equalTo(cell.mas_left).offset(25);
        make.width.equalTo(@70);
    }];
    [cell addSubview:self.endPlaceValue];
    [_endPlaceValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.mas_top).offset(0);
        make.left.equalTo(_endPlaceTitle.mas_right).offset(5);
        make.right.equalTo(cell.mas_right).offset(-15);
        make.width.equalTo(@(self.view.frame.size.width - 195-40));
        make.height.equalTo(@65);
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
            return 75;
            break;
        }
        case 6:{
            return 75;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
