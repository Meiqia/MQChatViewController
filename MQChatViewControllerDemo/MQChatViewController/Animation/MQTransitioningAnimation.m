//
//  MQTransitioningAnimation.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/20.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQTransitioningAnimation.h"

@interface MQTransitioningAnimation()

@property (nonatomic, strong) MQShareTransitioningDelegateImpl *transitioningDelegateImpl;

@end


@implementation MQTransitioningAnimation

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [MQTransitioningAnimation new];
    });
    
    return instance;
}

- (instancetype)init {

    if (self = [super init]) {
        self.transitioningDelegateImpl = [MQShareTransitioningDelegateImpl new];
    }
    return self;
}

- (CATransition *)createPresentingTransiteAnimation:(TransiteAnimationType)animation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    [transition setFillMode:kCAFillModeBoth];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    switch (animation) {
        case TransiteAnimationTypePush:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromRight;
            break;
        case TransiteAnimationTypeDefault:
        default:
            break;
    }
    return transition;
}

- (CATransition *)createDismissingTransiteAnimation:(TransiteAnimationType)animation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    [transition setFillMode:kCAFillModeBoth];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    switch (animation) {
        case TransiteAnimationTypePush:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            break;
        case TransiteAnimationTypeDefault:
        default:
            break;
    }
    return transition;
}


@end
