//
//  SureGuideView.m
//  ProjectRefactoring
//
//  Created by 刘硕 on 2016/11/17.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "SureGuideView.h"
#import "UIImage+Adaptive.h"
#import "AppDelegate.h"
NSString *const SureShouldShowHomeGuide = @"SureShouldShowGuide";
NSString *const SureShouldShowFaGuide = @"SureShouldShowFaGuide";

@interface SureGuideView ()
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) NSInteger imageCount;
@end
@implementation SureGuideView

+ (instancetype)sureGuideViewWithImageName:(NSString*)imageName
                                imageCount:(NSInteger)imageCount{
    return [[self alloc]initWithImageName:imageName imageCount:imageCount];
}

+ (instancetype)sureGuideViewWithImageName:(NSString*)imageName
                                imageCount:(NSInteger)imageCount inView:(UIView *)view
{
    return [[self alloc]initWithImageName:imageName imageCount:imageCount inview:view];

};

- (instancetype)initWithImageName:(NSString*)imageName
                       imageCount:(NSInteger)imageCount inview:(UIView *)view
{
    if (self = [super init]) {
        _imageName = imageName;
        _imageCount = imageCount;
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
        if (_imageCount) {
            for (NSInteger i = _imageCount; i > 0; i--) {
                NSString *realImageName = [NSString stringWithFormat:@"%@_%ld",_imageName,i];
                UIImage *image = [UIImage imageNamed:realImageName];
                UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
                imageView.userInteractionEnabled = YES;
                imageView.tag = 1000 + i;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
                [imageView addGestureRecognizer:tap];
                [self addSubview:imageView];
            }
        }
        [view addSubview:self];
    }
    return self;
}

- (instancetype)initWithImageName:(NSString*)imageName
                       imageCount:(NSInteger)imageCount{
    if (self = [super init]) {
        _imageName = imageName;
        _imageCount = imageCount;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
    if (_imageCount) {
        for (NSInteger i = _imageCount; i > 0; i--) {
            NSString *realImageName = [NSString stringWithFormat:@"%@_%ld",_imageName,i];
            UIImage *image = [UIImage imageNamed:realImageName];
            UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
            imageView.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
            imageView.userInteractionEnabled = YES;
            imageView.tag = 1000 + i;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchImageView:)];
            [imageView addGestureRecognizer:tap];
            [self addSubview:imageView];
        }
    }
    [self show];
}

- (void)touchImageView:(UITapGestureRecognizer*)tap {
    UIImageView *tapImageView = (UIImageView*)tap.view;
    //依次移除
    [tapImageView removeFromSuperview];
    if (tapImageView.tag - 1000 == _imageCount) {
        //最后一张
        if (self.lastTapBlock) {
            self.lastTapBlock();
        }
        [self hide];
    }
}

- (void)show {
//    [UIApplication sharedApplication].statusBarHidden = YES;
    AppDelegate *appDel = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDel.window addSubview:self];
}

- (void)hide {
//    [UIApplication sharedApplication].statusBarHidden = NO;
    [self removeFromSuperview];
}

+ (BOOL)shouldShowHomeGuider {
    NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:SureShouldShowHomeGuide];
    if ([number isEqual:@200]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@200 forKey:SureShouldShowHomeGuide];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
}

+ (BOOL)shouldShowFaGuider {
    NSNumber *number = [[NSUserDefaults standardUserDefaults]objectForKey:SureShouldShowFaGuide];
    if ([number isEqual:@200]) {
        return NO;
    } else {
        [[NSUserDefaults standardUserDefaults]setObject:@200 forKey:SureShouldShowFaGuide];
        [[NSUserDefaults standardUserDefaults]synchronize];
        return YES;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
