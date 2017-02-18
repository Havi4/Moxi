//
//  BaseNaviViewController.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/2/9.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "BaseNaviViewController.h"
#import "LeftMenuViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "REFrostedViewController.h"

@interface BaseNaviViewController ()

@property (strong, readwrite, nonatomic) LeftMenuViewController *menuViewController;

@end

@implementation BaseNaviViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognized:)]];
}

- (void)showMenu
{
    [self.frostedViewController presentMenuViewController];
}

#pragma mark -
#pragma mark Gesture recognizer

- (void)panGestureRecognized:(UIPanGestureRecognizer *)sender
{
    [self.frostedViewController panGestureRecognized:sender];
}

@end
