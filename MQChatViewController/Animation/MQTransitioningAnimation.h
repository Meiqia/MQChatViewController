//
//  MQTransitioningAnimation.h
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/20.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQAnimatorPush.h"
#import "MQShareTransitioningDelegateImpl.h"
#import "MQChatViewConfig.h"

@interface MQTransitioningAnimation : NSObject

+ (id <UIViewControllerTransitioningDelegate>)transitioningDelegateImpl;

+ (CATransition *)createPresentingTransiteAnimation:(MQTransiteAnimationType)animation;

+ (CATransition *)createDismissingTransiteAnimation:(MQTransiteAnimationType)animation;

@end
