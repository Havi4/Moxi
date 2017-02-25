//
//  HouseTableViewCell.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/24.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "HouseTableViewCell.h"
#import "TopLabel.h"
@interface HouseTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *titleBackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *moneyShowLabel;
@property (nonatomic, strong) TopLabel *queryLabel;
@property (nonatomic, strong) TopLabel *queryLabelShow;
@property (nonatomic, strong) UILabel *startTimeLabel;
@property (nonatomic, strong) UILabel *startTime;
@property (nonatomic, strong) UILabel *endTimeLabel;
@property (nonatomic, strong) UILabel *endTime;
@property (nonatomic, strong) UILabel *peopleLabel;
@property (nonatomic, strong) UILabel *nightLabel;
@property (nonatomic, strong) UILabel *peopleLabelNum;
@property (nonatomic, strong) UILabel *nightLabelNum;
@property (nonatomic, strong) UILabel *peopleLabell;
@property (nonatomic, strong) UILabel *nightLabell;
@property (nonatomic, strong) UILabel *hunterLabel;
@property (nonatomic, strong) UILabel *hunter;
@property (nonatomic, strong) UIButton *contactButton;
@property (nonatomic, strong) UIButton *sopyButton;
//@property (nonatomic, strong) UIView *line1;
//@property (nonatomic, strong) UIView *line2;
//@property (nonatomic, strong) UIView *line3;
//@property (nonatomic, strong) UIView *line4;
//@property (nonatomic, strong) UIView *line5;
@end

@implementation HouseTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _backView = [[UIView alloc]init];
        _backView.layer.cornerRadius = 5;
        _backView.layer.masksToBounds = YES;
        _backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(7.5, 15, 7.5, 15));
        }];

        _titleBackView = [[UIImageView alloc]init];
        _titleBackView.image = [UIImage imageNamed:@"home_order_title"];
        [_backView addSubview:_titleBackView];
        [_titleBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_backView.mas_top);
            make.left.equalTo(_backView.mas_left);
            make.right.equalTo(_backView.mas_right);
            make.height.equalTo(@41);
        }];

        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"标题内容";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleBackView addSubview:_titleLabel];
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBackView addSubview:_moreButton];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleBackView.mas_left).offset(10);
            make.top.equalTo(_titleBackView.mas_top);
            make.bottom.equalTo(_titleBackView.mas_bottom);
        }];

        [_moreButton setImage:[[UIImage imageNamed:@"more_icon"] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleBackView.mas_right);
            make.centerY.equalTo(_titleBackView.mas_centerY);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];

        _moneyLabel = [[UILabel alloc]init];
        [_backView addSubview:_moneyLabel];
        _moneyLabel.text = @"游客预算:";
        _moneyLabel.font = [UIFont systemFontOfSize:16];
        [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleBackView.mas_bottom);
            make.height.equalTo(@41);
            make.left.equalTo(_titleBackView.mas_left).offset(10);
        }];

        _moneyShowLabel = [[UILabel alloc]init];
        [_backView addSubview:_moneyShowLabel];
        _moneyShowLabel.textColor = kFocusTextColor;
        _moneyShowLabel.text = @"JPY 8500";
        _moneyShowLabel.font = [UIFont systemFontOfSize:16];

        [_moneyShowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleBackView.mas_bottom);
            make.height.equalTo(@41);
            make.right.equalTo(_titleBackView.mas_right).offset(-10);
        }];

        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = kSepetorColor;
        [_backView addSubview:line1];
        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_moneyShowLabel.mas_bottom);
            make.left.equalTo(_backView.mas_left).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = kSepetorColor;
        [_backView addSubview:line2];
        _queryLabel = [[TopLabel alloc]init];
        _queryLabel.text = @"要求:";
        _queryLabel.font = [UIFont systemFontOfSize:16];

        [_queryLabel setVerticalAlignment:VerticalAlignmentTop];
        [_backView addSubview:_queryLabel];

        _queryLabelShow = [[TopLabel alloc]init];
        _queryLabelShow.numberOfLines = 0;
        [_queryLabelShow setVerticalAlignment:VerticalAlignmentTop];
        _queryLabelShow.font = [UIFont systemFontOfSize:16];

        _queryLabelShow.text = @"折扣蓝井艾露几点睡觉;";
        _queryLabelShow.textColor = kFocusTextColor;
        [_backView addSubview:_queryLabelShow];
        [_queryLabel sizeToFit];
        [_queryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.width.equalTo(@40);
            make.top.equalTo(line1.mas_bottom).offset(15);
            make.bottom.equalTo(line2.mas_bottom);
        }];


        [_queryLabelShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_queryLabel.mas_right).offset(15);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.top.equalTo(line1.mas_bottom).offset(15);
            make.bottom.equalTo(line2.mas_bottom);

        }];


        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];

        _startTimeLabel = [[UILabel alloc]init];
        [_backView addSubview:_startTimeLabel];
        _startTimeLabel.text = @"入住时间";
        _startTimeLabel.font = [UIFont systemFontOfSize:16];

        [_startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@20);
        }];
        _startTime = [[UILabel alloc]init];
        [_backView addSubview:_startTime];
        _startTime.text = @"10月1日";
        _startTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [_startTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.top.equalTo(_startTimeLabel.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];

        _endTimeLabel = [[UILabel alloc]init];
        [_backView addSubview:_endTimeLabel];
        _endTimeLabel.text = @"退房时间";
        _endTimeLabel.font = [UIFont systemFontOfSize:16];

        [_endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_backView.mas_centerX);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@20);
        }];
        _endTime = [[UILabel alloc]init];
        [_backView addSubview:_endTime];
        _endTime.text = @"10月5日";
        _endTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [_endTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_endTimeLabel.mas_left);
            make.top.equalTo(_endTimeLabel.mas_bottom).offset(5);
            make.height.equalTo(@30);
        }];

        _nightLabel = [[UILabel alloc]init];
        [_backView addSubview:_nightLabel];
        _nightLabel.text = @"共计";
        _nightLabel.font = [UIFont systemFontOfSize:15];

        _nightLabelNum = [[UILabel alloc]init];
        [_backView addSubview:_nightLabelNum];
        _nightLabelNum.text = @"5";
        _nightLabelNum.textColor = kFocusTextColor;
        _nightLabelNum.font = [UIFont systemFontOfSize:15];

        _nightLabell = [[UILabel alloc]init];
        [_backView addSubview:_nightLabell];
        _nightLabell.text = @"晚";
        _nightLabell.font = [UIFont systemFontOfSize:15];

        [_nightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_nightLabelNum.mas_left).offset(-5);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@25);
        }];

        [_nightLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nightLabel.mas_right).offset(5);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@25);
        }];


        [_nightLabell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nightLabelNum.mas_right).offset(5);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@25);
        }];

        _peopleLabel = [[UILabel alloc]init];
        [_backView addSubview:_peopleLabel];
        _peopleLabel.text = @"入住";
        _peopleLabel.font = [UIFont systemFontOfSize:15];

        _peopleLabelNum = [[UILabel alloc]init];
        [_backView addSubview:_peopleLabelNum];
        _peopleLabelNum.textColor = kFocusTextColor;
        _peopleLabelNum.text = @"9";
        _peopleLabelNum.font = [UIFont systemFontOfSize:15];

        _peopleLabell = [[UILabel alloc]init];
        [_backView addSubview:_peopleLabell];
        _peopleLabell.text = @"人";
        _peopleLabell.font = [UIFont systemFontOfSize:15];

        [_peopleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_peopleLabelNum.mas_left).offset(-5);
            make.top.equalTo(_nightLabel.mas_bottom).offset(5);
            make.height.equalTo(@25);
        }];

        [_peopleLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_peopleLabel.mas_right).offset(5);
            make.top.equalTo(_nightLabel.mas_bottom).offset(5);
            make.height.equalTo(@25);
        }];

        [_peopleLabell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_peopleLabelNum.mas_right).offset(5);
            make.top.equalTo(_nightLabel.mas_bottom).offset(5);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@25);
        }];


        UIView *line3 = [[UIView alloc]init];
        line3.backgroundColor = kSepetorColor;
        [_backView addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_startTime.mas_bottom).offset(10);
            make.left.equalTo(_backView.mas_left).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];

        _hunterLabel = [[UILabel alloc]init];
        _hunterLabel.text = @"介绍人:";
        _hunterLabel.font = [UIFont systemFontOfSize:16];

        [_backView addSubview:_hunterLabel];
        [_hunterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.top.equalTo(line3.mas_bottom).offset(0);
            make.width.equalTo(@70);
            make.height.equalTo(@46);

        }];

        _hunter = [[UILabel alloc]init];
        _hunter.text = @"VANX";
        _hunter.font = [UIFont systemFontOfSize:16];

        [_backView addSubview:_hunter];
        [_hunter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hunterLabel.mas_right).offset(15);
            make.top.equalTo(line3.mas_bottom).offset(0);
            make.height.equalTo(@46);
        }];

        UIView *line4 = [[UIView alloc]init];
        line4.backgroundColor = kSepetorColor;
        [_backView addSubview:line4];
        [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_hunterLabel.mas_bottom).offset(0);
            make.left.equalTo(_backView.mas_left).offset(0);
            make.right.equalTo(_backView.mas_right).offset(-0);
            make.height.equalTo(@1);
        }];

        UIView *line5 = [[UIView alloc]init];
        line5.backgroundColor = kSepetorColor;
        [_backView addSubview:line5];
        [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line4.mas_bottom).offset(5);
            make.bottom.equalTo(_backView.mas_bottom).offset(-5);
            make.centerX.equalTo(_backView.mas_centerX);
            make.width.equalTo(@1);
        }];

        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactButton setTitle:@"MOXI直连" forState:UIControlStateNormal];
        _contactButton.titleLabel.font = [UIFont systemFontOfSize:16];

        [_contactButton setTitleColor:kFocusTextColor forState:UIControlStateNormal];
        [_backView addSubview:_contactButton];
        [_contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.right.equalTo(line5.mas_left).offset(-10);
            make.top.equalTo(line4.mas_bottom);
            make.bottom.equalTo(_backView.mas_bottom);
            make.height.equalTo(@40);
        }];

        _sopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sopyButton setTitle:@"复制微信号" forState:UIControlStateNormal];
        _sopyButton.titleLabel.font = [UIFont systemFontOfSize:16];

        [_sopyButton setTitleColor:kCarOrderBarColor forState:UIControlStateNormal];
        [_backView addSubview:_sopyButton];
        [_sopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line5.mas_left).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.top.equalTo(line4.mas_bottom);
            make.bottom.equalTo(_backView.mas_bottom);
            make.height.equalTo(@40);
        }];


    }
    return self;
}

- (void)cellConfigWithItem:(id)item andIndex:(NSIndexPath *)indexPath
{
    NSDictionary *dic = item;
    self.queryLabelShow.text = [dic objectForKey:@"text"];

}

- (void)layoutViewContrains
{

}
@end
