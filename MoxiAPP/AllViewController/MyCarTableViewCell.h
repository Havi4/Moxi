//
//  CarTableViewCell.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/24.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@interface MyCarTableViewCell : UITableViewCell

@property (nonatomic, copy) void (^tapDoneDelete)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^callMoxi)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^copyWx)(NSIndexPath *indexPath);

@property (nonatomic, copy) void (^moreNext)(NSIndexPath *indexPath);

- (void)cellConfigWithItem:(id)item andIndex:(NSIndexPath *)indexPath;

@property (nonatomic, assign) BOOL hideModelDoneView;

@property (nonatomic, copy) CarModel *carModel;
@end
