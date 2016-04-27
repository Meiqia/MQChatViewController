//
//  MQAnimatorPush.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/20.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQAnimatorPush.h"

@interface MQAnimatorPush()

@property (nonatomic, strong) UIViewController *toViewController;
@property (nonatomic, strong) UIViewController *fromViewController;

@end

@implementation MQAnimatorPush

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.35;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    self.toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    self.fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    
    CGRect finalFrame = [transitionContext finalFrameForViewController:self.toViewController];
    if (CGRectIsEmpty(finalFrame)) {
        finalFrame = [[UIScreen mainScreen] bounds];
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    if (self.isPresenting) {
        self.toViewController.view.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
        [[transitionContext containerView] addSubview:self.toViewController.view];
    } else {
        self.fromViewController.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    }
    
    [self.toViewController.navigationController beginAppearanceTransition:YES animated:YES];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.toViewController.view.frame = finalFrame;
        if (self.isPresenting) {
            self.fromViewController.view.frame = CGRectMake(-screenSize.width / 2, 0, screenSize.width, screenSize.height);
        } else {
            self.fromViewController.view.frame = CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height);
        }
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];
    }];
}

- (void)animationEnded:(BOOL)transitionCompleted {
    if (transitionCompleted) {
        [self.fromViewController.navigationController endAppearanceTransition];
    }
}

@end
