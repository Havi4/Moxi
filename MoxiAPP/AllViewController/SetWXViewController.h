//
//  SetWXViewController.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/4/23.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "BaseViewController.h"

@interface SetWXViewController : BaseViewController

@property (nonatomic, copy) void (^doneSave)(NSInteger index);

@end
