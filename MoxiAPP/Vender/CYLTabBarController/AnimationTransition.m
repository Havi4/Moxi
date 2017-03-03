//
//  AnimationTransition.m
//  MoxiAPP
//
//  Created by HaviLee on 2017/3/1.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import "AnimationTransition.h"

@implementation AnimationTransition
/**
 *  转场动画所需要的时间
 */
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 1.0;
}
/**
 *  转场动画完成调用的方法
 */
- (void)animationEnded:(BOOL)transitionCompleted{

}
/**
 *  转场动画细节实现
 */
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{

        //得到转场过程中的View
    _transitionContext = transitionContext;
    _containerView  = [transitionContext containerView];
    _containerView.backgroundColor = [UIColor whiteColor];

        //得到转场的两上VC
    _from = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    _to = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        // 得到
        // iOS8之后才有
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {

        _fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        _toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    } else {

        _fromView = _from.view;
        _toView = _to.view;
    }
    if (self.animatorTransitionType == kAnimatorTransitionTypePresent) {
        [self animatorPresent];
    }
    if (self.animatorTransitionType == kAnimatorTransitionTypeDismiss) {
        [self animatorDismiss];
    }
    if (self.animatorTransitionType == kAnimatorTransitionTypeBubble){
        [self animatorBubble];
    }
    if (self.animatorTransitionType == kAnimatorTransitionTypeBubbleBack) {
        [self animatorBubbleBack];
    }
}

- (void)animatorBubble{

        // 在toView的下边, 添加了一个bubbleView, 从最初的bubble的center位置开始, 通过scale动画呈现出来.
        // BubbleView与toView的背景色一致.
    UIView *bubbleView = [[UIView alloc] init];
    bubbleView.backgroundColor = self.toView.backgroundColor;
    CGSize toViewSize = self.toView.frame.size;
    CGFloat x = fmax(_bubbleCenter.x, toViewSize.width);
    CGFloat y = fmax(_bubbleCenter.y, toViewSize.height);
    CGFloat radius = sqrt(x * x + y * y);
    bubbleView.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    bubbleView.layer.cornerRadius = CGRectGetHeight(bubbleView.frame) / 2;
    bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    bubbleView.center = _bubbleCenter;
    [self.containerView addSubview:bubbleView];

        // toView要跟随bubbleView一起做动画
    self.toView.frame = [self.transitionContext finalFrameForViewController:self.to];
    self.toView.transform = CGAffineTransformMakeScale(0.001, 0.001);
    self.toView.center = _bubbleCenter;
    self.toView.alpha = 0.0;
    [self.containerView addSubview:self.toView];


    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
                     animations:^{

                         bubbleView.transform = CGAffineTransformIdentity;
                         self.toView.transform = CGAffineTransformIdentity;
                         self.toView.alpha = 1.0f;


                     } completion:^(BOOL finished) {
                         [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
                     }];



}
- (void)animatorBubbleBack{

    self.toView.frame = [self.transitionContext finalFrameForViewController:self.to];
    [self.containerView insertSubview:self.toView belowSubview:self.fromView];


        // 与present bubble时的过程相反.
    UIView *bubbleView = [[UIView alloc] init];
    bubbleView.backgroundColor = self.fromView.backgroundColor;
    CGSize fromViewSize = self.fromView.frame.size;
    CGFloat x = fmax(_bubbleCenter.x, fromViewSize.width);
    CGFloat y = fmax(_bubbleCenter.y, fromViewSize.height);
    CGFloat radius = sqrt(x * x + y * y);
    bubbleView.frame = CGRectMake(0, 0, radius * 2, radius * 2);
    bubbleView.layer.cornerRadius = radius;
    bubbleView.layer.masksToBounds = YES;
        //    bubbleView.transform = CGAffineTransformIdentity;
    bubbleView.center = _bubbleCenter;
    [self.containerView insertSubview:bubbleView belowSubview:self.fromView];


    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
                     animations:^{

                         bubbleView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         self.fromView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         self.fromView.center = self.bubbleCenter;

                     } completion:^(BOOL finished) {
                         [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];

                     }];


}
#pragma mark - 简单的呈现动画
#define PERSPECTIVE -1.0/200

- (void)animatorPresent{
        //得到初始frame,fromView为全屏，toView为（0，0，0，0）
//    CATransform3D viewFromTransform = CATransform3DMakeRotation(M_PI/2, 0, 1, 0);
//    CATransform3D viewToTransform = CATransform3DMakeRotation(-M_PI/2, 0, 1, 0);
//    viewFromTransform.m34 = PERSPECTIVE;
//    viewToTransform.m34 = PERSPECTIVE;


    UIViewController *toVC = [_transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [_transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *container = [_transitionContext containerView];
    fromVC.navigationItem.titleView.alpha = 1;
    fromVC.navigationItem.leftBarButtonItem.customView.alpha = 1;
    fromVC.navigationItem.rightBarButtonItem.customView.alpha = 1;
    toVC.navigationItem.titleView.alpha = 0;
    toVC.navigationItem.leftBarButtonItem.customView.alpha = 0;
    toVC.navigationItem.rightBarButtonItem.customView.alpha = 0;
//    [toVC.view.layer setAnchorPoint:CGPointMake(0, 0.5)];
//    [fromVC.view.layer setAnchorPoint:CGPointMake(1, 0.5)];
//
//    toVC.view.layer.transform = viewToTransform;

    [container addSubview:toVC.view];
//    container.transform = CGAffineTransformMakeTranslation(container.frame.size.width/2.0,0);


    [UIView animateWithDuration:[self transitionDuration:_transitionContext] animations:^{
        fromVC.navigationItem.titleView.alpha = 0;
        fromVC.navigationItem.leftBarButtonItem.customView.alpha = 0;
        fromVC.navigationItem.rightBarButtonItem.customView.alpha = 0;
        toVC.navigationItem.titleView.alpha = 1;
        toVC.navigationItem.leftBarButtonItem.customView.alpha = 1;
        toVC.navigationItem.rightBarButtonItem.customView.alpha = 1;
//        fromVC.view.frame = CGRectMake(kScreenSize.width, 0, kScreenSize.width, kScreenSize.height);
//        toVC.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//        container.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//        fromVC.view.layer.transform = viewFromTransform;
//        toVC.view.layer.transform = CATransform3DIdentity;
//        [container setTransform:CGAffineTransformMakeTranslation(-container.frame.size.width/2.0, 0)];


    } completion:^(BOOL finished) {

//        fromVC.view.frame = CGRectMake(kScreenSize.width, 0, kScreenSize.width, kScreenSize.height);
//        toVC.view.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//        container.frame = CGRectMake(0, 0, kScreenSize.width, kScreenSize.height);
//        fromVC.view.layer.transform = CATransform3DIdentity;
//        toVC.view.layer.transform = CATransform3DIdentity;
//        [fromVC.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
//        [toVC.view.layer setAnchorPoint:CGPointMake(0.5f, 0.5f)];
//        [container setTransform:CGAffineTransformIdentity];
//
//        [_transitionContext completeTransition:YES];
    }];
//    self.fromView.frame = [self.transitionContext initialFrameForViewController:self.from];
//    self.toView.frame = [self.transitionContext initialFrameForViewController:self.to];
//    [self.containerView addSubview:self.toView];
//
//
//        //从中间扩散
//    self.toView.alpha = 0;
//    self.toView.center = self.containerView.center;
//    self.toView.transform = CGAffineTransformMakeScale(0.001, 0.001);
//
//    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
//                          delay:0
//         usingSpringWithDamping:100// 弹簧效果，越小越明显
//          initialSpringVelocity:3  //初始速度
//                        options:UIViewAnimationOptionTransitionFlipFromTop
//                     animations:^{
////                         self.toView.transform = CGAffineTransformIdentity;
//                         self.toView.frame = [self.transitionContext finalFrameForViewController:self.to];
//                         self.toView.alpha = 1;
//
//                     } completion:^(BOOL finished) {
//                             //这个方法代表告诉系统转都转场成功了
//                         BOOL wasCancelled = [self.transitionContext transitionWasCancelled];
//                         [self.transitionContext completeTransition:!wasCancelled];
//
//                     }];

}
- (void)animatorDismiss{

    /**
     *  返回时toView,fromView的frame都是全屏
     */
    [self.containerView addSubview:self.fromView];
        //[self.containerView insertSubview:self.toView belowSubview:self.fromView];
    [UIView animateWithDuration:[self transitionDuration:self.transitionContext]
                          delay:0
         usingSpringWithDamping:100// 弹簧效果，越小越明显
          initialSpringVelocity:3 //初始速度
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{

                         self.fromView.transform = CGAffineTransformMakeScale(0.001, 0.001);
                         self.fromView.frame = CGRectZero;
                         self.fromView.center = self.containerView.center;
                     }
                     completion:^(BOOL finished) {
                         BOOL wasCancelled = [self.transitionContext transitionWasCancelled];
                         [self.transitionContext completeTransition:!wasCancelled];
                         [self.fromView removeFromSuperview];
                     }];
    
    
}
@end
