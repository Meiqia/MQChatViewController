//
//  MQShareTransitioningDelegateImpl.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/20.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQShareTransitioningDelegateImpl.h"
#import "MQAnimatorPush.h"

@implementation MQShareTransitioningDelegateImpl

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    MQAnimatorPush *animator = [MQAnimatorPush new];
    animator.isPresenting = YES;
    return animator;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [MQAnimatorPush new];
}


@end
