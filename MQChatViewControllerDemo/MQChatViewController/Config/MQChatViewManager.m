//
//  MQChatViewManager.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewManager.h"
#import "MQImageUtil.h"

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
    if (!chatViewController) {
        chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    }
    if (viewController.navigationController) {
        chatViewConfig.isPushChatView = true;
        [self updateNavAttributesWithViewController:chatViewController navigationController:viewController.navigationController isPresentModalView:false];
        [viewController.navigationController pushViewController:chatViewController animated:true];
    } else {
        [self presentMQChatViewControllerInViewController:viewController];
    }
    return chatViewController;
}

- (MQChatViewController *)presentMQChatViewControllerInViewController:(UIViewController *)viewController {
    chatViewConfig.isPresentChatView = true;
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
        navigationController.navigationBar.backgroundColor = [MQChatViewConfig sharedConfig].navBarColor;
    }
    //导航栏左键
    UIImage *cancelImage = isPresentModalView ? [MQChatViewConfig sharedConfig].modalViewLeftButtonImage : [MQChatViewConfig sharedConfig].navBarLeftButtonImage;
    if ([MQChatViewConfig sharedConfig].navBarTintColor) {
        cancelImage = [MQImageUtil convertImageColorWithImage:cancelImage toColor:[MQChatViewConfig sharedConfig].navBarTintColor];
    }
    if (cancelImage) {
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, cancelImage.size.width, cancelImage.size.height);
        [cancelBtn setBackgroundImage:cancelImage forState:UIControlStateNormal];
        [cancelBtn addTarget:viewController action:@selector(dismissChatViewController) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        viewController.navigationItem.leftBarButtonItem = leftItem;
    }
    //导航栏右键
    if ([MQChatViewConfig sharedConfig].navBarRightButton) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:[MQChatViewConfig sharedConfig].navBarRightButton];
        viewController.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)disappearMQChatViewController {
    if (!chatViewController) {
        return ;
    }
    [chatViewController dismissChatViewController];
}

- (void)enableCustomChatViewFrame:(BOOL)enable {
    chatViewConfig.isCustomizedChatViewFrame = enable;
}

- (void)setChatViewFrame:(CGRect)viewFrame {
    chatViewConfig.chatViewFrame = viewFrame;
}

- (void)setMessageNumberRegex:(NSString *)numberRegex {
    [chatViewConfig.numberRegexs addObject:numberRegex];
}

- (void)setMessageLinkRegex:(NSString *)linkRegex {
    [chatViewConfig.linkRegexs addObject:linkRegex];
}

- (void)setMessageEmailRegex:(NSString *)emailRegex {
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
    chatViewConfig.incomingMsgTextColor = [textColor copy];
}

- (void)setIncomingBubbleColor:(UIColor *)bubbleColor {
    chatViewConfig.incomingBubbleColor = bubbleColor;
}

- (void)setOutgoingMessageTextColor:(UIColor *)textColor {
    chatViewConfig.outgoingMsgTextColor = [textColor copy];
}

- (void)setOutgoingBubbleColor:(UIColor *)bubbleColor {
    chatViewConfig.outgoingBubbleColor = bubbleColor;
}

- (void)setEventTextColor:(UIColor *)textColor {
    chatViewConfig.eventTextColor = [textColor copy];
}

- (void)setNavigationBarTintColor:(UIColor *)tintColor {
    chatViewConfig.navBarTintColor = [tintColor copy];
}

- (void)setNavigationBarColor:(UIColor *)barColor {
    chatViewConfig.navBarColor = [barColor copy];
}

- (void)setPullRefreshColor:(UIColor *)pullRefreshColor {
    chatViewConfig.pullRefreshColor = pullRefreshColor;
}

- (void)setChatWelcomeText:(NSString *)welcomText {
    chatViewConfig.chatWelcomeText = [welcomText copy];
}

- (void)setAgentName:(NSString *)agentName {
    chatViewConfig.agentName = [agentName copy];
}

- (void)enableAgentAvatar:(BOOL)enable {
    chatViewConfig.enableAgentAvatar = enable;
}

- (void)enableClientAvatar:(BOOL)enable {
    chatViewConfig.enableClientAvatar = enable;
}

- (void)setAgentDefaultAvatarImage:(UIImage *)image {
    chatViewConfig.agentDefaultAvatarImage = [UIImage imageWithCGImage:image.CGImage];
}

- (void)setClientDefaultAvatarImage:(UIImage *)image {
    chatViewConfig.clientDefaultAvatarImage = [UIImage imageWithCGImage:image.CGImage];
}

- (void)setPhotoSenderImage:(UIImage *)image {
    chatViewConfig.photoSenderImage = [UIImage imageWithCGImage:image.CGImage];
}

- (void)setVoiceSenderImage:(UIImage *)image {
    chatViewConfig.voiceSenderImage = [UIImage imageWithCGImage:image.CGImage];
}

- (void)setIncomingBubbleImage:(UIImage *)bubbleImage {
    chatViewConfig.incomingBubbleImage = [UIImage imageWithCGImage:bubbleImage.CGImage];
}

- (void)setOutgoingBubbleImage:(UIImage *)bubbleImage {
    chatViewConfig.outgoingBubbleImage = [UIImage imageWithCGImage:bubbleImage.CGImage];
}

- (void)setNavLeftButtonImage:(UIImage *)leftButtonImage {
    chatViewConfig.navBarLeftButtonImage = leftButtonImage;
}

- (void)setModalViewNavLeftButtonImage:(UIImage *)leftButtonImage {
    chatViewConfig.modalViewLeftButtonImage = leftButtonImage;
}

- (void)setNavRightButton:(UIButton *)rightButton {
    chatViewConfig.navBarRightButton = rightButton;
}

- (void)enableCustomRecordView:(BOOL)enable {
    chatViewConfig.enableCustomRecordView = enable;
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

- (void)enableWelcomeChat:(BOOL)enable {
    chatViewConfig.enableWelcomeChat = enable;
}

- (void)setIncomingMessageSoundFileName:(NSString *)soundFileName {
    chatViewConfig.incomingMsgSoundFileName = soundFileName;
}

- (void)setMaxRecordDuration:(NSTimeInterval)recordDuration {
    chatViewConfig.maxVoiceDuration = recordDuration;
}

#ifdef INCLUDE_MEIQIA_SDK

- (void)setScheduledAgentToken:(NSString *)agentToken {
    chatViewConfig.scheduledAgentToken = agentToken;
}


- (void)setScheduledGroupToken:(NSString *)groupToken {
    chatViewConfig.scheduledGroupToken = groupToken;
}

- (void)setLoginCustomizedId:(NSString *)customizedId {
    chatViewConfig.customizedId = customizedId;
}

- (void)setLoginMQClientId:(NSString *)MQClientId {
    chatViewConfig.MQClientId = MQClientId;
}

#endif

@end
