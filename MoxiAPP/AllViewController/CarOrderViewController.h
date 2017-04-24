//
//  CarOrderViewController.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/26.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "BaseViewController.h"

@interface CarOrderViewController : BaseViewController

@property (nonatomic, copy) void (^fabuDone)(NSInteger indexPath);

@end
