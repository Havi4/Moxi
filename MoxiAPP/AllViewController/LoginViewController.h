//
//  LoginViewController.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/18.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (nonatomic, copy) void (^loginDone)(NSDictionary *userData);

@end
