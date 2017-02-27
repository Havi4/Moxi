//
//  CarTableViewCell.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/24.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "CarTableViewCell.h"
#import "TopLabel.h"

@interface CarTableViewCell ()
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *titleBackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *moreButton;
@property (nonatomic, strong) UILabel *moneyLabel;
@property (nonatomic, strong) UILabel *moneyShowLabel;
@property (nonatomic, strong) TopLabel *startLabel;
@property (nonatomic, strong) TopLabel *startLabelShow;
@property (nonatomic, strong) TopLabel *endLabel;
@property (nonatomic, strong) TopLabel *endLabelShow;

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UILabel *peopleLabel;
@property (nonatomic, strong) UILabel *peopleLabelNum;
@property (nonatomic, strong) UILabel *peopleLabell;
@property (nonatomic, strong) UILabel *nightLabell;
@property (nonatomic, strong) UILabel *hunterLabel;
@property (nonatomic, strong) UILabel *hunter;
@property (nonatomic, strong) UIButton *contactButton;
@property (nonatomic, strong) UIButton *sopyButton;
@property (nonatomic, strong) UIView *modelDoneView;
@property (nonatomic, strong) NSIndexPath *tapIndex;

@end

@implementation CarTableViewCell

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
        _titleBackView.userInteractionEnabled = YES;
        _titleBackView.image = [UIImage imageNamed:@"car_order_title"];
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
        [_moreButton addTarget:self action:@selector(showMoreNext:) forControlEvents:UIControlEventTouchUpInside];
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
        _startLabel = [[TopLabel alloc]init];
        _startLabel.text = @"出发地:";
        _startLabel.font = [UIFont systemFontOfSize:16];

        [_startLabel setVerticalAlignment:VerticalAlignmentTop];
        [_backView addSubview:_startLabel];

        _startLabelShow = [[TopLabel alloc]init];
        _startLabelShow.numberOfLines = 0;
        [_startLabelShow setVerticalAlignment:VerticalAlignmentTop];
        _startLabelShow.font = [UIFont systemFontOfSize:16];

        _startLabelShow.text = @"折扣蓝井艾露几点睡觉;";
        _startLabelShow.textColor = kFocusTextColor;
        [_backView addSubview:_startLabelShow];
        [_startLabel sizeToFit];

        _endLabel = [[TopLabel alloc]init];
        _endLabel.text = @"目的地:";
        _endLabel.font = [UIFont systemFontOfSize:16];

        [_endLabel setVerticalAlignment:VerticalAlignmentTop];
        [_backView addSubview:_endLabel];

        _endLabelShow = [[TopLabel alloc]init];
        _endLabelShow.numberOfLines = 0;
        [_endLabelShow setVerticalAlignment:VerticalAlignmentTop];
        _endLabelShow.font = [UIFont systemFontOfSize:16];

        _endLabelShow.text = @"折扣蓝井艾露几点睡觉;";
        _endLabelShow.textColor = kFocusTextColor;
        [_backView addSubview:_endLabelShow];
        [_endLabel sizeToFit];

        [_startLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.width.equalTo(@60);
            make.top.equalTo(line1.mas_bottom).offset(15);
        }];

        [_startLabelShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_startLabel.mas_right).offset(15);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.top.equalTo(line1.mas_bottom).offset(15);

        }];


        [_endLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.width.equalTo(@60);
            make.top.equalTo(_startLabel.mas_bottom).offset(10);
            make.bottom.equalTo(line2.mas_bottom).offset(-10);
        }];

        [_endLabelShow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_endLabel.mas_right).offset(15);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.top.equalTo(_startLabel.mas_bottom).offset(10);
            make.bottom.equalTo(line2.mas_bottom).offset(-10);
            
        }];

        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@1);
        }];

        _dateLabel = [[UILabel alloc]init];
        [_backView addSubview:_dateLabel];
        _dateLabel.text = @"10月1日";
        _dateLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];

        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_backView.mas_left).offset(10);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@40);
        }];
        _timelabel = [[UILabel alloc]init];
        [_backView addSubview:_timelabel];
        _timelabel.text = @"12:00";
        _timelabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [_timelabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_dateLabel.mas_right).offset(10);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@40);
        }];

        _peopleLabel = [[UILabel alloc]init];
        [_backView addSubview:_peopleLabel];
        _peopleLabel.text = @"乘客";
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
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@40);
        }];

        [_peopleLabelNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_peopleLabel.mas_right).offset(5);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.height.equalTo(@40);
        }];

        [_peopleLabell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_peopleLabelNum.mas_right).offset(5);
            make.top.equalTo(line2.mas_bottom).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.height.equalTo(@40);
        }];


        UIView *line3 = [[UIView alloc]init];
        line3.backgroundColor = kSepetorColor;
        [_backView addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dateLabel.mas_bottom).offset(10);
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
        [_contactButton addTarget:self action:@selector(callMoxi:) forControlEvents:UIControlEventTouchUpInside];
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
        [_sopyButton addTarget:self action:@selector(copyWX:) forControlEvents:UIControlEventTouchUpInside];
        [_sopyButton setTitleColor:kCarOrderBarColor forState:UIControlStateNormal];
        [_backView addSubview:_sopyButton];
        [_sopyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line5.mas_left).offset(10);
            make.right.equalTo(_backView.mas_right).offset(-10);
            make.top.equalTo(line4.mas_bottom);
            make.bottom.equalTo(_backView.mas_bottom);
            make.height.equalTo(@40);
        }];

        _modelDoneView = [[UIView alloc]init];
        _modelDoneView.layer.cornerRadius = 5;
        _modelDoneView.layer.masksToBounds = YES;
        _modelDoneView.hidden = YES;
        _modelDoneView.backgroundColor = [UIColor colorWithRed:0.118 green:0.145 blue:0.204 alpha:0.5];
        [self addSubview:_modelDoneView];
        [_modelDoneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(7.5, 15, 7.5, 15));
        }];

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
        
    }
    return self;
}

- (void)cellConfigWithItem:(id)item andIndex:(NSIndexPath *)indexPath
{
    NSDictionary *dic = item;
    self.tapIndex = indexPath;
    self.startLabelShow.text = [dic objectForKey:@"text"];
    self.endLabelShow.text = [dic objectForKey:@"text1"];
    
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

- (void)callMoxi:(UIButton *)button
{
    if (self.callMoxi) {
        self.callMoxi(self.tapIndex);
    }
}

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

@end
