//
//  HIPregressHUD.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/27.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "HIPregressHUD.h"
static HIPregressHUD *share = nil;
@interface HIPregressHUD ()

@property (nonatomic, strong) MBProgressHUD *alertHUD;

@property (nonatomic, strong) MBProgressHUD *loadingHUD;

@end

@implementation HIPregressHUD

+ (instancetype)shartMBHUD
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[HIPregressHUD alloc]init];
    });
    return share;
}

- (void)showAlertWith:(NSString *)title inView:(UIView *)inView
{
    for (UIView *view in inView.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            return;
        }
    }
    self.alertHUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];
        // Set the text mode to show only text.
    _alertHUD.mode = MBProgressHUDModeText;
    _alertHUD.label.text = title;
        // Move to bottm center.
        //    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);

    [_alertHUD hideAnimated:YES afterDelay:3.f];
}

- (void)showLoadingWith:(NSString *)title inView:(UIView *)inView
{
    for (UIView *view in inView.subviews) {
        if ([view isKindOfClass:[MBProgressHUD class]]) {
            return;
        }
    }

    self.loadingHUD = [MBProgressHUD showHUDAddedTo:inView animated:YES];

        // Set the label text.
    _loadingHUD.label.text = title;
}

- (void)hideLoading
{
    [_loadingHUD hideAnimated:YES];
}

@end
