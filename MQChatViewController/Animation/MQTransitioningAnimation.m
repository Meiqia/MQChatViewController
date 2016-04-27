//
//  MQTransitioningAnimation.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/20.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQTransitioningAnimation.h"

@interface MQTransitioningAnimation()

@property (nonatomic, strong) id<UIViewControllerTransitioningDelegate> transitioningDelegateImpl;

@end


@implementation MQTransitioningAnimation

///使用 singleton 的原因是使用这个 transition 的对象并没有维护这个 transition 对象，如果被释放 transition 则会失效，为了减少自定义 transition 对使用者的侵入，只好使用 singleton 来保持该对象
+ (instancetype)sharedInstance {
    static MQTransitioningAnimation *instance = nil;
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

+ (id <UIViewControllerTransitioningDelegate>)transitioningDelegateImpl {
    return [[self sharedInstance] transitioningDelegateImpl];
}

+ (CATransition *)createPresentingTransiteAnimation:(MQTransiteAnimationType)animation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    [transition setFillMode:kCAFillModeBoth];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    switch (animation) {
        case MQTransiteAnimationTypePush:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromRight;
            break;
        case MQTransiteAnimationTypeDefault:
        default:
            break;
    }
    return transition;
}
+ (CATransition *)createDismissingTransiteAnimation:(MQTransiteAnimationType)animation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    [transition setFillMode:kCAFillModeBoth];
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    switch (animation) {
        case MQTransiteAnimationTypePush:
            transition.type = kCATransitionMoveIn;
            transition.subtype = kCATransitionFromLeft;
            break;
        case MQTransiteAnimationTypeDefault:
        default:
            break;
    }
    return transition;
}


@end
