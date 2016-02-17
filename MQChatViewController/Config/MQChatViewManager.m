//
//  MQChatViewManager.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewManager.h"
#import "MQImageUtil.h"
#import "MQServiceToViewInterface.h"

@implementation MQChatViewManager {
    MQChatViewController *chatViewController;
    MQChatViewConfig *chatViewConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        chatViewConfig = [MQChatViewConfig sharedConfig];
    }
    return self;
}

- (MQChatViewController *)pushMQChatViewControllerInViewController:(UIViewController *)viewController {
    if (chatViewConfig) {
        chatViewConfig = [MQChatViewConfig sharedConfig];
    }
    if (!chatViewController) {
        chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    }
    if (viewController.navigationController) {
        chatViewConfig.isPushChatView = true;
        [self updateNavAttributesWithViewController:chatViewController navigationController:viewController.navigationController isPresentModalView:false];
        chatViewController.hidesBottomBarWhenPushed = chatViewConfig.hidesBottomBarWhenPushed;
        [viewController.navigationController pushViewController:chatViewController animated:true];
    } else {
        [self presentMQChatViewControllerInViewController:viewController];
    }
    return chatViewController;
}

- (MQChatViewController *)presentMQChatViewControllerInViewController:(UIViewController *)viewController {
    if (chatViewConfig) {
        chatViewConfig = [MQChatViewConfig sharedConfig];
    }
    chatViewConfig.isPushChatView = false;
    if (!chatViewController) {
        chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    }
    UINavigationController *chatNavigationController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
    [self updateNavAttributesWithViewController:chatViewController navigationController:chatNavigationController isPresentModalView:true];
    [viewController presentViewController:chatNavigationController animated:true completion:nil];
    return chatViewController;
}

//修改导航栏属性
- (void)updateNavAttributesWithViewController:(MQChatViewController *)viewController
                         navigationController:(UINavigationController *)navigationController
                           isPresentModalView:(BOOL)isPresentModalView
{
    if ([MQChatViewConfig sharedConfig].navBarTintColor) {
        navigationController.navigationBar.tintColor = [MQChatViewConfig sharedConfig].navBarTintColor;
    }
    if ([MQChatViewConfig sharedConfig].navBarColor) {
        navigationController.navigationBar.barTintColor = [MQChatViewConfig sharedConfig].navBarColor;
    }
    
    //导航栏左键
    UIBarButtonItem *leftItem;
    if ([MQChatViewConfig sharedConfig].navBarLeftButton) {
        leftItem = [[UIBarButtonItem alloc] initWithCustomView:[MQChatViewConfig sharedConfig].navBarLeftButton];
        [[MQChatViewConfig sharedConfig].navBarLeftButton addTarget:viewController action:@selector(dismissChatViewController) forControlEvents:UIControlEventTouchUpInside];
    } else {
        if (![MQChatViewConfig sharedConfig].isPushChatView) {
            leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:viewController action:@selector(dismissChatViewController)];
        }
    }
    viewController.navigationItem.leftBarButtonItem = leftItem;
    
    //导航栏右键
    if ([MQChatViewConfig sharedConfig].navBarRightButton) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:[MQChatViewConfig sharedConfig].navBarRightButton];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [[MQChatViewConfig sharedConfig].navBarRightButton addTarget:viewController action:@selector(didSelectNavigationRightButton) forControlEvents:UIControlEventTouchUpInside];
#pragma clang diagnostic pop
        viewController.navigationItem.rightBarButtonItem = rightItem;
    }
    
    //导航栏标题
    if ([MQChatViewConfig sharedConfig].navTitleText) {
        viewController.navigationItem.title = [MQChatViewConfig sharedConfig].navTitleText;
        if ([MQChatViewConfig sharedConfig].navBarTintColor) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            navigationController.navigationBar.titleTextAttributes = @{
                                                                       UITextAttributeTextColor : [MQChatViewConfig sharedConfig].navBarTintColor
                                                                       };
#pragma clang diagnostic pop
        }
    }
}

- (void)disappearMQChatViewController {
    if (!chatViewController) {
        return ;
    }
    [chatViewController dismissChatViewController];
}

- (void)hidesBottomBarWhenPushed:(BOOL)hide
{
    chatViewConfig.hidesBottomBarWhenPushed = hide;
}

- (void)enableCustomChatViewFrame:(BOOL)enable {
    chatViewConfig.isCustomizedChatViewFrame = enable;
}

- (void)setChatViewFrame:(CGRect)viewFrame {
    chatViewConfig.chatViewFrame = viewFrame;
}

- (void)setViewControllerPoint:(CGPoint)viewPoint {
    chatViewConfig.chatViewControllerPoint = viewPoint;
}

- (void)setMessageNumberRegex:(NSString *)numberRegex {
    if (!numberRegex) {
        return;
    }
    [chatViewConfig.numberRegexs addObject:numberRegex];
}

- (void)setMessageLinkRegex:(NSString *)linkRegex {
    if (!linkRegex) {
        return;
    }
    [chatViewConfig.linkRegexs addObject:linkRegex];
}

- (void)setMessageEmailRegex:(NSString *)emailRegex {
    if (!emailRegex) {
        return;
    }
    [chatViewConfig.emailRegexs addObject:emailRegex];
}

- (void)enableSyncServerMessage:(BOOL)enable {
    chatViewConfig.enableSyncServerMessage = enable;
}

- (void)enableEventDispaly:(BOOL)enable {
    chatViewConfig.enableEventDispaly = enable;
}

- (void)enableSendVoiceMessage:(BOOL)enable {
    chatViewConfig.enableSendVoiceMessage = enable;
}

- (void)enableSendImageMessage:(BOOL)enable {
    chatViewConfig.enableSendImageMessage = enable;
}

- (void)enableShowNewMessageAlert:(BOOL)enable {
    chatViewConfig.enableShowNewMessageAlert = enable;
}

- (void)setIncomingMessageTextColor:(UIColor *)textColor {
    if (!textColor) {
        return;
    }
    chatViewConfig.incomingMsgTextColor = [textColor copy];
}

- (void)setIncomingBubbleColor:(UIColor *)bubbleColor {
    if (!bubbleColor) {
        return;
    }
    chatViewConfig.incomingBubbleColor = bubbleColor;
}

- (void)setOutgoingMessageTextColor:(UIColor *)textColor {
    if (!textColor) {
        return;
    }
    chatViewConfig.outgoingMsgTextColor = [textColor copy];
}

- (void)setOutgoingBubbleColor:(UIColor *)bubbleColor {
    if (!bubbleColor) {
        return;
    }
    chatViewConfig.outgoingBubbleColor = bubbleColor;
}

- (void)enableMessageImageMask:(BOOL)enable
{
    chatViewConfig.enableMessageImageMask = enable;
}

- (void)setEventTextColor:(UIColor *)textColor {
    if (!textColor) {
        return;
    }
    chatViewConfig.eventTextColor = [textColor copy];
}

- (void)setNavigationBarTintColor:(UIColor *)tintColor {
    if (!tintColor) {
        return;
    }
    chatViewConfig.navBarTintColor = [tintColor copy];
}

- (void)setNavigationBarColor:(UIColor *)barColor {
    if (!barColor) {
        return;
    }
    chatViewConfig.navBarColor = [barColor copy];
}

- (void)setPullRefreshColor:(UIColor *)pullRefreshColor {
    if (!pullRefreshColor) {
        return;
    }
    chatViewConfig.pullRefreshColor = pullRefreshColor;
}

- (void)setChatWelcomeText:(NSString *)welcomText {
    if (!welcomText) {
        return;
    }
    chatViewConfig.chatWelcomeText = [welcomText copy];
}

- (void)setAgentName:(NSString *)agentName {
    if (!agentName) {
        return;
    }
    chatViewConfig.agentName = [agentName copy];
}

- (void)enableIncomingAvatar:(BOOL)enable {
    chatViewConfig.enableIncomingAvatar = enable;
}

- (void)enableOutgoingAvatar:(BOOL)enable {
    chatViewConfig.enableOutgoingAvatar = enable;
}

- (void)setincomingDefaultAvatarImage:(UIImage *)image {
    if (!image) {
        return;
    }
    chatViewConfig.incomingDefaultAvatarImage = image;
}

- (void)setoutgoingDefaultAvatarImage:(UIImage *)image {
    if (!image) {
        return;
    }
    chatViewConfig.outgoingDefaultAvatarImage = image;
#ifdef INCLUDE_MEIQIA_SDK
    [MQServiceToViewInterface uploadClientAvatar:image completion:^(BOOL success, NSError *error) {
    }];
#endif
}

- (void)setPhotoSenderImage:(UIImage *)image
           highlightedImage:(UIImage *)highlightedImage
{
    if (image) {
        chatViewConfig.photoSenderImage = image;
    }
    if (highlightedImage) {
        chatViewConfig.photoSenderHighlightedImage = highlightedImage;
    }
}

- (void)setVoiceSenderImage:(UIImage *)image
           highlightedImage:(UIImage *)highlightedImage
{
    if (image) {
        chatViewConfig.voiceSenderImage = image;
    }
    if (highlightedImage) {
        chatViewConfig.voiceSenderHighlightedImage = highlightedImage;
    }
}

- (void)setTextSenderImage:(UIImage *)image
          highlightedImage:(UIImage *)highlightedImage
{
    if (image) {
        chatViewConfig.keyboardSenderImage = image;
    }
    if (highlightedImage) {
        chatViewConfig.keyboardSenderHighlightedImage = highlightedImage;
    }
}

- (void)setResignKeyboardImage:(UIImage *)image
              highlightedImage:(UIImage *)highlightedImage
{
    if (image) {
        chatViewConfig.resignKeyboardImage = image;
    }
    if (highlightedImage) {
        chatViewConfig.resignKeyboardHighlightedImage = highlightedImage;
    }
}

- (void)setIncomingBubbleImage:(UIImage *)bubbleImage {
    if (!bubbleImage) {
        return;
    }
    chatViewConfig.incomingBubbleImage = bubbleImage;
}

- (void)setOutgoingBubbleImage:(UIImage *)bubbleImage {
    if (!bubbleImage) {
        return;
    }
    chatViewConfig.outgoingBubbleImage = bubbleImage;
}

- (void)setBubbleImageStretchInsets:(UIEdgeInsets)stretchInsets {
    chatViewConfig.bubbleImageStretchInsets = stretchInsets;
}

- (void)setNavRightButton:(UIButton *)rightButton {
    if (!rightButton) {
        return;
    }
    chatViewConfig.navBarRightButton = rightButton;
}

- (void)setNavLeftButton:(UIButton *)leftButton {
    if (!leftButton) {
        return;
    }
    chatViewConfig.navBarLeftButton = leftButton;
}

- (void)setNavTitleText:(NSString *)titleText {
    if (!titleText) {
        return;
    }
    chatViewConfig.navTitleText = titleText;
}

- (void)enableMessageSound:(BOOL)enable {
    chatViewConfig.enableMessageSound = enable;
}

- (void)enableTopPullRefresh:(BOOL)enable {
    chatViewConfig.enableTopPullRefresh = enable;
}

- (void)enableRoundAvatar:(BOOL)enable {
    chatViewConfig.enableRoundAvatar = enable;
}

- (void)enableTopAutoRefresh:(BOOL)enable {
    chatViewConfig.enableTopAutoRefresh = enable;
}

- (void)enableBottomPullRefresh:(BOOL)enable {
    chatViewConfig.enableBottomPullRefresh = enable;
}

- (void)enableChatWelcome:(BOOL)enable {
    chatViewConfig.enableChatWelcome = enable;
}

- (void)setIncomingMessageSoundFileName:(NSString *)soundFileName {
    if (!soundFileName) {
        return;
    }
    chatViewConfig.incomingMsgSoundFileName = soundFileName;
}

- (void)setMaxRecordDuration:(NSTimeInterval)recordDuration {
    chatViewConfig.maxVoiceDuration = recordDuration;
}

#ifdef INCLUDE_MEIQIA_SDK

- (void)setScheduledAgentId:(NSString *)agentId {
    if (!agentId) {
        return;
    }
    chatViewConfig.scheduledAgentId = agentId;
}

- (void)setScheduledGroupId:(NSString *)groupId {
    if (!groupId) {
        return;
    }
    chatViewConfig.scheduledGroupId = groupId;
}

- (void)setScheduleLogicWithRule:(MQChatScheduleRules)scheduleRule {
    chatViewConfig.scheduleRule = scheduleRule;
}

- (void)setLoginCustomizedId:(NSString *)customizedId {
    if (!customizedId) {
        return;
    }
    chatViewConfig.customizedId = customizedId;
}

- (void)setLoginMQClientId:(NSString *)MQClientId {
    if (!MQClientId) {
        return;
    }
    chatViewConfig.MQClientId = MQClientId;
}

#endif

@end
