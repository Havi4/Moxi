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
@property (nonatomic, strong) UIView *modelDoneView;
@property (nonatomic, strong) NSIndexPath *tapIndex;
@property (nonatomic, strong) UIImageView *topImage;
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
        [self.contentView addSubview:_backView];
        _backView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(7.5, 15, 7.5, 15));

        
        _titleBackView = [[UIImageView alloc]init];
        _titleBackView.userInteractionEnabled = YES;
        _titleBackView.image = [UIImage imageNamed:@"home_order_title"];
        [self.contentView addSubview:_titleBackView];
        _titleBackView.sd_layout
        .leftSpaceToView(self.contentView,15)
        .topSpaceToView(self.contentView,7.5)
        .rightSpaceToView(self.contentView,15)
        .heightIs(41);

        _titleLabel = [[UILabel alloc]init];
        _titleLabel.text = @"标题内容";
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = [UIColor whiteColor];
        [_titleBackView addSubview:_titleLabel];
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_titleBackView addSubview:_moreButton];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_titleBackView.mas_left).offset(15);
            make.top.equalTo(_titleBackView.mas_top);
            make.bottom.equalTo(_titleBackView.mas_bottom);
        }];

        [_moreButton setImage:[[UIImage imageNamed:@"more_icon"] imageByTintColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_moreButton addTarget:self action:@selector(showMoreNext:) forControlEvents:UIControlEventTouchUpInside];

        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_titleBackView.mas_right);
            make.centerY.equalTo(_titleBackView.mas_centerY);
            make.width.equalTo(@60);
            make.height.equalTo(@40);
        }];

        _topImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"topImage"]];
        _topImage.frame = CGRectMake(0, 0, 27, 27);
        _topImage.hidden = YES;
        [_titleBackView addSubview:_topImage];

        _moneyLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_moneyLabel];
        _moneyLabel.text = @"游客预算:";
        _moneyLabel.font = [UIFont systemFontOfSize:16];
        _moneyLabel.sd_layout
        .leftSpaceToView(self.contentView,25)
        .topSpaceToView(_titleBackView,5)
        .heightIs(30)
        .widthIs(100);

        _moneyShowLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_moneyShowLabel];
        _moneyShowLabel.textColor = kFocusTextColor;
        _moneyShowLabel.textAlignment = NSTextAlignmentRight;
        _moneyShowLabel.text = @"JPY 0";
        _moneyShowLabel.font = [UIFont systemFontOfSize:16];
        _moneyShowLabel.sd_layout
        .rightSpaceToView(self.contentView,25)
        .topSpaceToView(_titleBackView,5)
        .heightIs(30)
        .minWidthIs(50);


        UIView *line1 = [[UIView alloc]init];
        line1.backgroundColor = kSepetorColor;
        [self.contentView addSubview:line1];
        line1.sd_layout
        .topSpaceToView(_moneyShowLabel,5)
        .leftSpaceToView(self.contentView,25)
        .rightSpaceToView(self.contentView,25)
        .heightIs(1);

        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = kSepetorColor;
        [self.contentView addSubview:line2];
        _queryLabel = [[TopLabel alloc]init];
        _queryLabel.text = @"要求:";
        _queryLabel.font = [UIFont systemFontOfSize:16];

        [self.contentView addSubview:_queryLabel];

        _queryLabelShow = [[TopLabel alloc]init];
        _queryLabelShow.numberOfLines = 0;
        _queryLabelShow.font = [UIFont systemFontOfSize:16];
        _queryLabelShow.textAlignment = NSTextAlignmentLeft;

        _queryLabelShow.text = @"折扣蓝井艾露几点睡觉;";
        _queryLabelShow.textColor = kFocusTextColor;
        [self.contentView addSubview:_queryLabelShow];

        _queryLabel.sd_layout
        .leftSpaceToView(self.contentView,25)
        .topSpaceToView(line1,10)
        .widthIs(40)
        .autoHeightRatio(0);

        _queryLabelShow.sd_layout
        .leftSpaceToView(_queryLabel,5)
        .rightSpaceToView(self.contentView,25)
        .topSpaceToView(line1,10)
        .autoHeightRatio(0);

        line2.sd_layout
        .topSpaceToView(_queryLabelShow,10)
        .leftSpaceToView(self.contentView,25)
        .rightSpaceToView(self.contentView,25)
        .heightIs(1);

        _startTimeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_startTimeLabel];
        _startTimeLabel.text = @"入住时间";
        _startTimeLabel.font = [UIFont systemFontOfSize:16];
        _startTimeLabel.sd_layout
        .topSpaceToView(line2,10)
        .leftSpaceToView(self.contentView,25)
        .heightIs(20)
        .minWidthIs(100);
        _startTime = [[UILabel alloc]init];
        [self.contentView addSubview:_startTime];
        _startTime.text = @"10月1日";
        _startTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _startTime.sd_layout
        .leftSpaceToView(self.contentView,25)
        .topSpaceToView(_startTimeLabel,0)
        .heightIs(30)
        .widthIs(90);

        _endTimeLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_endTimeLabel];
        _endTimeLabel.textAlignment = NSTextAlignmentCenter;
        _endTimeLabel.text = @"退房时间";
        _endTimeLabel.font = [UIFont systemFontOfSize:16];
        _endTimeLabel.sd_layout
        .topSpaceToView(line2,10)
        .centerXEqualToView(self.contentView)
        .heightIs(20)
        .widthIs(100);


        _endTime = [[UILabel alloc]init];
        [self.contentView addSubview:_endTime];
        _endTime.textAlignment = NSTextAlignmentCenter;
        _endTime.text = @"10月5日";
        _endTime.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _endTime.sd_layout
        .topSpaceToView(_endTimeLabel,0)
        .leftEqualToView(_endTimeLabel)
        .heightIs(30)
        .widthIs(100);

        UIImageView *lineImage = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"house_line"] imageByTintColor:kSepetorColor]];
        [self.contentView addSubview:lineImage];
        lineImage.sd_layout
        .centerYEqualToView(_endTime)
        .centerXIs(kScreenSize.width/4+33)
        .widthIs(10)
        .heightIs(20);

    //
        _nightLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_nightLabel];
        _nightLabel.text = @"共计";
        _nightLabel.textAlignment = NSTextAlignmentRight;
        _nightLabel.font = [UIFont systemFontOfSize:15];

        _nightLabelNum = [[UILabel alloc]init];
        [self.contentView addSubview:_nightLabelNum];
        _nightLabelNum.text = @"5";
        _nightLabelNum.textAlignment = NSTextAlignmentCenter;
        _nightLabelNum.textColor = kFocusTextColor;
        _nightLabelNum.font = [UIFont systemFontOfSize:15];

        _nightLabell = [[UILabel alloc]init];
        [self.contentView addSubview:_nightLabell];
        _nightLabell.text = @"晚";
        _nightLabell.textAlignment = NSTextAlignmentRight;
        _nightLabell.font = [UIFont systemFontOfSize:15];

        _nightLabell.sd_layout
        .rightSpaceToView(self.contentView,25)
        .topSpaceToView(line2,10)
        .heightIs(25)
        .widthIs(20);

        _nightLabelNum.sd_layout
        .rightSpaceToView(_nightLabell,5)
        .topSpaceToView(line2,10)
        .heightIs(25)
        .widthIs(20);

        _nightLabel.sd_layout
        .rightSpaceToView(_nightLabelNum,5)
        .topSpaceToView(line2,10)
        .heightIs(25)
        .widthIs(35);



        _peopleLabel = [[UILabel alloc]init];
        [self.contentView addSubview:_peopleLabel];
        _peopleLabel.textAlignment = NSTextAlignmentRight;
        _peopleLabel.text = @"入住";
        _peopleLabel.font = [UIFont systemFontOfSize:15];

        _peopleLabelNum = [[UILabel alloc]init];
        [self.contentView addSubview:_peopleLabelNum];
        _peopleLabelNum.textColor = kFocusTextColor;
        _peopleLabelNum.text = @"9";
        _peopleLabelNum.textAlignment = NSTextAlignmentCenter;
        _peopleLabelNum.font = [UIFont systemFontOfSize:15];

        _peopleLabell = [[UILabel alloc]init];
        _peopleLabell.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_peopleLabell];
        _peopleLabell.text = @"人";
        _peopleLabell.font = [UIFont systemFontOfSize:15];

        _peopleLabell.sd_layout
        .rightSpaceToView(self.contentView,25)
        .topSpaceToView(_nightLabel,0)
        .heightIs(25)
        .widthIs(20);

        _peopleLabelNum.sd_layout
        .rightSpaceToView(_nightLabell,5)
        .topSpaceToView(_nightLabel,0)
        .heightIs(25)
        .widthIs(20);

        _peopleLabel.sd_layout
        .rightSpaceToView(_nightLabelNum,5)
        .topSpaceToView(_nightLabel,0)
        .heightIs(25)
        .widthIs(35);

        UIView *line3 = [[UIView alloc]init];
        line3.backgroundColor = kSepetorColor;
        [self.contentView addSubview:line3];
        line3.sd_layout
        .topSpaceToView(_startTime,10)
        .leftSpaceToView(self.contentView,25)
        .rightSpaceToView(self.contentView,25)
        .heightIs(1);
//
        _hunterLabel = [[UILabel alloc]init];
        _hunterLabel.text = @"介绍人:";
        _hunterLabel.font = [UIFont systemFontOfSize:16];

        [self.contentView addSubview:_hunterLabel];
        _hunterLabel.sd_layout
        .leftSpaceToView(self.contentView,25)
        .topSpaceToView(line3,0)
        .widthIs(69)
        .heightIs(44);

        _hunter = [[UILabel alloc]init];
        _hunter.text = @"这是个测试";
        _hunter.font = [UIFont systemFontOfSize:16];

        [self.contentView addSubview:_hunter];
        [_hunter mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_hunterLabel.mas_right).offset(15);
            make.top.equalTo(line3.mas_bottom).offset(0);
            make.height.equalTo(@46);
        }];

//        UIView *line4 = [[UIView alloc]init];
//        line4.backgroundColor = kSepetorColor;
//        [self.contentView addSubview:line4];
//        line4.sd_layout
//        .topSpaceToView(_hunterLabel,0)
//        .leftSpaceToView(self.contentView,25)
//        .rightSpaceToView(self.contentView,25)
//        .heightIs(1);



//        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_contactButton setTitle:@"MOXI直连" forState:UIControlStateNormal];
//        _contactButton.titleLabel.font = [UIFont systemFontOfSize:16];
//        [_contactButton addTarget:self action:@selector(callMoxi:) forControlEvents:UIControlEventTouchUpInside];
//
//        [_contactButton setTitleColor:kFocusTextColor forState:UIControlStateNormal];
//        [self.contentView addSubview:_contactButton];
//
//        _contactButton.sd_layout
//        .leftSpaceToView(self.contentView,25)
//        .topSpaceToView(line4,0)
//        .heightIs(40)
//        .rightSpaceToView(line5,5);
//
        _sopyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sopyButton setTitle:@"复制微信号" forState:UIControlStateNormal];
        _sopyButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_sopyButton addTarget:self action:@selector(copyWX:) forControlEvents:UIControlEventTouchUpInside];

        [_sopyButton setTitleColor:kCarOrderBarColor forState:UIControlStateNormal];
        [self.contentView addSubview:_sopyButton];
        _sopyButton.sd_layout
        .rightSpaceToView(self.contentView,25)
        .topSpaceToView(line3,0)
        .heightIs(40)
        .widthIs(100);

        UIView *line4 = [[UIView alloc]init];
        line4.backgroundColor = kSepetorColor;
        [self.contentView addSubview:line4];
        line4.sd_layout
        .rightSpaceToView(_sopyButton,5)
        .topSpaceToView(line3,5)
        .bottomSpaceToView(self.contentView,12.5)
        .widthIs(1);

        _modelDoneView = [[UIView alloc]init];
        _modelDoneView.layer.cornerRadius = 5;
        _modelDoneView.layer.masksToBounds = YES;
        _modelDoneView.hidden = YES;
        _modelDoneView.backgroundColor = [UIColor colorWithRed:0.118 green:0.145 blue:0.204 alpha:0.25];
        [self.contentView addSubview:_modelDoneView];
        _modelDoneView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(7.5, 15, 7.5, 15));

        UILabel *doneLabel = [[UILabel alloc]init];
        [_modelDoneView addSubview:doneLabel];
        doneLabel.textColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.922 alpha:1.00];
        doneLabel.text = @"订单已完成";
        doneLabel.font = [UIFont systemFontOfSize:30];
        [doneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_modelDoneView.mas_centerX);
            make.centerY.equalTo(_modelDoneView.mas_centerY);
        }];

        UIButton *buttonDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonDelete setImage:[UIImage imageNamed:@"delete_done_order"] forState:UIControlStateNormal];
        [buttonDelete addTarget:self action:@selector(deleteOrder:) forControlEvents:UIControlEventTouchUpInside];
        
        [_modelDoneView addSubview:buttonDelete];
        [buttonDelete mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@40);
            make.width.equalTo(@40);
            make.top.equalTo(_modelDoneView.mas_top).offset(5);
            make.right.equalTo(_modelDoneView.mas_right).offset(-5);
        }];

        [self setupAutoHeightWithBottomView:_sopyButton bottomMargin:10];
    }
    return self;
}

- (void)cellConfigWithItem:(id)item andIndex:(NSIndexPath *)indexPath
{
    NSDictionary *dic = item;
    self.tapIndex = indexPath;
    if (!item) {
        return;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
    self.moneyShowLabel.text = [NSString stringWithFormat:@"%@ %@",[dic objectForKey:@"priceType"],[dic objectForKey:@"price"]];
    self.startTime.text = [NSString stringWithFormat:@"%@月%@日",[[dic objectForKey:@"ruzhu"] substringToIndex:2],[[dic objectForKey:@"ruzhu"] substringFromIndex:3]];

    self.endTime.text = [NSString stringWithFormat:@"%@月%@日",[[dic objectForKey:@"tuifang"] substringToIndex:2],[[dic objectForKey:@"ruzhu"] substringFromIndex:3]];
    self.nightLabelNum.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"wan"]];;
    self.peopleLabelNum.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"renshu"]];
    self.queryLabelShow.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"yaoqiu"]];
    self.hunter.text = [[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]] isEqualToString:@"<null>"] ? @"":[NSString stringWithFormat:@"%@",[dic objectForKey:@"nickName"]];
    self.topImage.hidden = [[dic objectForKey:@"isTop"] intValue]==1?NO:YES;

}

- (void)deleteOrder:(UIButton *)button
{
    if (self.tapDoneDelete) {
        self.tapDoneDelete(self.tapIndex);
    }
}


- (void)copyWX:(UIButton *)button
{
    if (self.copyWx) {
        self.copyWx(self.tapIndex);
    }
}
/*
- (void)callMoxi:(UIButton *)button
{
    if (self.callMoxi) {
        self.callMoxi(self.tapIndex);
    }
}
*/
- (void)showMoreNext:(UIButton *)button
{
    if (self.moreNext) {
        self.moreNext(self.tapIndex);
    }
}


- (void)setHideModelDoneView:(BOOL)hideModelDoneView
{
    if (hideModelDoneView) {
        self.modelDoneView.hidden = YES;
    }else{
        self.modelDoneView.hidden = NO;
    }
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.queryLabelShow.text = text;
}


@end
