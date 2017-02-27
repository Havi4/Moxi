//
//  HIPregressHUD.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/27.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HIPregressHUD : NSObject

+ (instancetype)shartMBHUD;

- (void)showAlertWith:(NSString *)title inView:(UIView *)inView;

- (void)showLoadingWith:(NSString *)title inView:(UIView *)inView;

- (void)hideLoading;
@end
