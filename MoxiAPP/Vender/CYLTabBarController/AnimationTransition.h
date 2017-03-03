//
//  AnimationTransition.h
//  MoxiAPP
//
//  Created by HaviLee on 2017/3/1.
//  Copyright © 2017年 HaviLee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,AnimatorTransitionType) {

    kAnimatorTransitionTypePresent = 0,
    kAnimatorTransitionTypeDismiss,
    kAnimatorTransitionTypeBubble,
    kAnimatorTransitionTypeBubbleBack
    
};
@interface AnimationTransition : NSObject<UIViewControllerAnimatedTransitioning>

    //转场动画上下文
@property (nonatomic, weak) id<UIViewControllerContextTransitioning> transitionContext;

    //转场动画过程中呈现出来的View
@property (nonatomic,retain) UIView *containerView;

    //转场动画类型
@property (nonatomic,assign)AnimatorTransitionType animatorTransitionType;

@property (nonatomic,retain) UIViewController *from;
@property (nonatomic,retain) UIViewController *to;

@property (nonatomic,retain) UIView *fromView;
@property (nonatomic,retain) UIView *toView;


@property (nonatomic,assign) CGPoint bubbleCenter;


@end
