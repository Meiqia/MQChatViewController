//
//  MQChatViewManager.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewManager.h"
#import "MQChatViewConfig.h"

@implementation MQChatViewManager {
#warning 这些属性需要如果需要实时和chatView同步，则需要在增加chatViewController中的相关方法后，再添加
    MQChatViewController *chatViewController;
    MQChatViewConfig *chatViewConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        chatViewConfig = [[MQChatViewConfig alloc] init];
    }
    return self;
}

- (MQChatViewController *)pushMQChatViewControllerInViewController:(UIViewController *)viewController {
    if (!chatViewController) {
        chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    }
    if (viewController.navigationController) {
        [viewController.navigationController pushViewController:chatViewController animated:true];
    } else {
        [self presentMQChatViewControllerInViewController:viewController];
    }
    return chatViewController;
}

- (MQChatViewController *)presentMQChatViewControllerInViewController:(UIViewController *)viewController {
    if (chatViewController) {
        chatViewController = [[MQChatViewController alloc] initWithChatViewManager:chatViewConfig];
    }
    [viewController presentViewController:chatViewController animated:true completion:nil];
    return chatViewController;
}

- (void)disappearMQChatViewController {
    if (!chatViewController) {
        return ;
    }
#warning 需要在chatViewController中添加disappear后，再写这里
}

- (void)setChatViewFrame:(CGRect)viewFrame {
    chatViewConfig.chatViewFrame = viewFrame;
}

- (void)setMessageRegex:(NSDictionary *)regexs {
    chatViewConfig.chatRegexs = [[NSDictionary alloc] initWithDictionary:regexs];
}

- (void)enableSyncServerMessage:(BOOL)enable {
    chatViewConfig.enableSyncServerMessage = enable;
}

- (void)enableEventDispaly:(BOOL)enable {
    chatViewConfig.enableEventDispaly = enable;
}

- (void)enableVoiceMessage:(BOOL)enable {
    chatViewConfig.enableVoiceMessage = enable;
}

- (void)enableImageMessage:(BOOL)enable {
    chatViewConfig.enableImageMessage = enable;
}

- (void)enableTipsView:(BOOL)enable {
    chatViewConfig.enableTipsView = enable;
}

- (void)setIncomingMessageTextColor:(UIColor *)textColor {
    chatViewConfig.incomingMsgTextColor = [textColor copy];
}

- (void)setOutgoingMessageTextColor:(UIColor *)textColor {
    chatViewConfig.outgoingMsgTextColor = [textColor copy];
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

- (void)setAgentOnlineTip:(NSString *)tipText {
    chatViewConfig.agentOnlineTipText = [tipText copy];
}

- (void)setAgentOfflineTip:(NSString *)tipText {
    chatViewConfig.agentOfflineTipText = [tipText copy];
}

- (void)setChatWelcomText:(NSString *)welcomText {
    chatViewConfig.chatWelcomText = [welcomText copy];
}

- (void)enableAgentAvatar:(BOOL)enable {
    chatViewConfig.enableAgentAvatar = enable;
}

- (void)setAgentDefaultAvatarImage:(UIImage *)image {
    chatViewConfig.agentDefaultAvatarImage = [UIImage imageWithCGImage:image.CGImage];
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

- (void)enableCustomRecordView:(BOOL)enable {
    chatViewConfig.enableCustomRecordView = enable;
}

- (void)enableMessageSound:(BOOL)enable {
    chatViewConfig.enableMessageSound = enable;
}

- (void)setOutgoingMessageSound:(NSData *)soundData {
    chatViewConfig.outgoingMsgSoundData = [NSData dataWithData:soundData];
}

- (void)setIncomingMessageSound:(NSData *)soundData {
    chatViewConfig.incomingMsgSoundData = [NSData dataWithData:soundData];
}




@end
