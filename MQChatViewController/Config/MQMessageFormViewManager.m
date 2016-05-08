//
//  MQMessageFormViewManager.m
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/8.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import "MQMessageFormViewManager.h"
#import "MQTransitioningAnimation.h"
#import "MQAssetUtil.h"

@implementation MQMessageFormViewManager  {
    MQMessageFormConfig *messageFormConfig;
    MQMessageFormViewController *messageFormViewController;
}

@dynamic messageFormViewStyle;

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return messageFormConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        messageFormConfig = [MQMessageFormConfig sharedConfig];
    }
    return self;
}

- (MQMessageFormViewController *)pushMQMessageFormViewControllerInViewController:(UIViewController *)viewController {
    if (messageFormConfig) {
        messageFormConfig = [MQMessageFormConfig sharedConfig];
    }
    if (!messageFormViewController) {
        messageFormViewController = [[MQMessageFormViewController alloc] initWithConfig:messageFormConfig];
    }
    [self presentOnViewController:viewController transiteAnimation:MQTransiteAnimationTypePush];
    return messageFormViewController;
}

- (MQMessageFormViewController *)presentMQMessageFormViewControllerInViewController:(UIViewController *)viewController {
    if (messageFormConfig) {
        messageFormConfig = [MQMessageFormConfig sharedConfig];
    }
    if (!messageFormViewController) {
        messageFormViewController = [[MQMessageFormViewController alloc] initWithConfig:messageFormConfig];
    }
    [self presentOnViewController:viewController transiteAnimation:MQTransiteAnimationTypeDefault];
    return messageFormViewController;
}

- (void)presentOnViewController:(UIViewController *)rootViewController transiteAnimation:(MQTransiteAnimationType)animation {
    [MQChatViewConfig sharedConfig].presentingAnimation = animation;
    
    UIViewController *viewController = nil;
    if (animation == MQTransiteAnimationTypePush) {
        viewController = [self createNavigationControllerWithWithAnimationSupport:messageFormViewController presentedViewController:rootViewController];
        BOOL shouldUseUIKitAnimation = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7;
        [rootViewController presentViewController:viewController animated:shouldUseUIKitAnimation completion:nil];
    } else {
        viewController = [[UINavigationController alloc] initWithRootViewController:messageFormViewController];
        [self updateNavAttributesWithViewController:messageFormViewController navigationController:(UINavigationController *)viewController defaultNavigationController:rootViewController.navigationController isPresentModalView:true];
        [rootViewController presentViewController:viewController animated:YES completion:nil];
    }
}

- (UINavigationController *)createNavigationControllerWithWithAnimationSupport:(MQMessageFormViewController *)rootViewController presentedViewController:(UIViewController *)presentedViewController{
    UINavigationController *navigationController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [self updateNavAttributesWithViewController:rootViewController navigationController:(UINavigationController *)navigationController defaultNavigationController:rootViewController.navigationController isPresentModalView:true];
        [navigationController setTransitioningDelegate:[MQTransitioningAnimation transitioningDelegateImpl]];
        [navigationController setModalPresentationStyle:UIModalPresentationCustom];
    } else {
        [self updateNavAttributesWithViewController:messageFormViewController navigationController:(UINavigationController *)navigationController defaultNavigationController:rootViewController.navigationController isPresentModalView:true];
        [rootViewController.view.window.layer addAnimation:[MQTransitioningAnimation createPresentingTransiteAnimation:[MQChatViewConfig sharedConfig].presentingAnimation] forKey:nil];
    }
    return navigationController;
}

//修改导航栏属性
- (void)updateNavAttributesWithViewController:(MQMessageFormViewController *)viewController
                         navigationController:(UINavigationController *)navigationController
                  defaultNavigationController:(UINavigationController *)defaultNavigationController
                           isPresentModalView:(BOOL)isPresentModalView {
    if ([MQChatViewConfig sharedConfig].navBarTintColor) {
        navigationController.navigationBar.tintColor = [MQChatViewConfig sharedConfig].navBarTintColor;
    } else if (defaultNavigationController && defaultNavigationController.navigationBar.tintColor) {
        navigationController.navigationBar.tintColor = defaultNavigationController.navigationBar.tintColor;
    }
    
    if ([MQChatViewConfig sharedConfig].navTitleColor) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        navigationController.navigationBar.titleTextAttributes = @{
                                                                   UITextAttributeTextColor : [MQChatViewConfig sharedConfig].navTitleColor
                                                                   };
#pragma clang diagnostic pop
    } else if (defaultNavigationController) {
        navigationController.navigationBar.titleTextAttributes = defaultNavigationController.navigationBar.titleTextAttributes;
    }
    
    if ([MQChatViewConfig sharedConfig].navBarColor) {
        navigationController.navigationBar.barTintColor = [MQChatViewConfig sharedConfig].navBarColor;
    } else if (defaultNavigationController && defaultNavigationController.navigationBar.barTintColor) {
        navigationController.navigationBar.barTintColor = defaultNavigationController.navigationBar.barTintColor;
    }
    
    //导航栏左键
    if ([MQChatViewConfig sharedConfig].presentingAnimation == MQTransiteAnimationTypeDefault) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:viewController action:@selector(dismissMessageFormViewController)];
    } else {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[MQAssetUtil backArrow] style:UIBarButtonItemStylePlain target:viewController action:@selector(dismissMessageFormViewController)];
    }
}

- (void)disappearMQMessageFromViewController {
    if (!messageFormViewController) {
        return ;
    }
    [messageFormViewController dismissMessageFormViewController];
}

- (void)setLeaveMessageIntro:(NSString *)leaveMessageIntro {
    messageFormConfig.leaveMessageIntro = leaveMessageIntro;
}

- (void)setCustomMessageFormInputModelArray:(NSArray *)customMessageFormInputModelArray {
    if (!customMessageFormInputModelArray) {
        return;
    }
    messageFormConfig.customMessageFormInputModelArray = customMessageFormInputModelArray;
}

@end
