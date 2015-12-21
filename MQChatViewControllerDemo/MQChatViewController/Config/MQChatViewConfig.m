//
//  MQChatViewConfig.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewConfig.h"
#import "MQChatDeviceUtil.h"
#import "MQChatFileUtil.h"
#import "MQAssetUtil.h"
#import "MQBundleUtil.h"

NSString * const MQChatViewKeyboardResignFirstResponderNotification = @"MQChatViewKeyboardResignFirstResponderNotification";
NSString * const MQAudioPlayerDidInterruptNotification = @"MQAudioPlayerDidInterruptNotification";


@implementation MQChatViewConfig

+ (instancetype)sharedConfig {
    static MQChatViewConfig *_sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [[MQChatViewConfig alloc] init];
    });
    return _sharedConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setConfigToDefault];
    }
    return self;
}

- (void)setConfigToDefault {
    self.isCustomizedChatViewFrame  = false;
    self.chatViewFrame              = [MQChatDeviceUtil getDeviceScreenRect];
    self.chatViewControllerPoint    = CGPointMake(0, 0);

    self.numberRegexs = [[NSMutableArray alloc] initWithArray:@[@"^(\\d{3,4}-?)\\d{7,8}$", @"^1[3|4|5|7|8]\\d{9}", @"[0-9]\\d{4,10}"]];
    self.linkRegexs   = [[NSMutableArray alloc] initWithArray:@[@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"]];
    self.emailRegexs  = [[NSMutableArray alloc] initWithArray:@[@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"]];
    
    self.chatWelcomeText        = [MQBundleUtil localizedStringForKey:@"welcome_chat"];
    self.agentName              = [MQBundleUtil localizedStringForKey:@"default_assistant"];
    self.scheduledAgentId    = @"";
    self.scheduledGroupId    = @"";
    self.MQClientId             = @"";
    self.customizedId           = @"";
    self.navTitleText           = @"";
    
    self.enableSyncServerMessage = true;
    self.enableEventDispaly      = false;
    self.enableSendVoiceMessage  = true;
    self.enableSendImageMessage  = true;
    self.enableIncomingAvatar    = true;
    self.enableMessageImageMask  = true;
    self.enableMessageSound      = true;
    self.enableOutgoingAvatar    = true;
    self.enableTopPullRefresh    = false;
    self.enableBottomPullRefresh = false;
    
    self.enableRoundAvatar         = false;
    self.enableChatWelcome         = false;
    self.enableTopAutoRefresh      = true;
    self.isPushChatView            = true;
    self.enableShowNewMessageAlert = true;
    
    self.incomingMsgTextColor   = [UIColor darkTextColor];
    self.outgoingMsgTextColor   = [UIColor darkTextColor];
    self.eventTextColor         = [UIColor grayColor];
    self.pullRefreshColor       = [UIColor colorWithRed:104.0/255.0 green:192.0/255.0 blue:160.0/255.0 alpha:1.0];
    self.redirectAgentNameColor = [UIColor blueColor];
    self.navBarColor            = nil;
    self.navBarTintColor        = nil;
    self.incomingBubbleColor    = nil;
    self.outgoingBubbleColor    = nil;
    
    self.incomingDefaultAvatarImage     = [MQAssetUtil incomingDefaultAvatarImage];
    self.outgoingDefaultAvatarImage     = [MQAssetUtil outgoingDefaultAvatarImage];
    self.photoSenderImage               = [MQAssetUtil messageCameraInputImage];
    self.photoSenderHighlightedImage    = [MQAssetUtil messageCameraInputHighlightedImage];
    self.keyboardSenderImage            = [MQAssetUtil messageTextInputImage];
    self.keyboardSenderHighlightedImage = [MQAssetUtil messageTextInputHighlightedImage];
    self.voiceSenderImage               = [MQAssetUtil messageVoiceInputImage];
    self.voiceSenderHighlightedImage    = [MQAssetUtil messageVoiceInputHighlightedImage];
    self.resignKeyboardImage            = [MQAssetUtil messageResignKeyboardImage];
    self.resignKeyboardHighlightedImage = [MQAssetUtil messageResignKeyboardHighlightedImage];
    self.incomingBubbleImage            = [MQAssetUtil bubbleIncomingImage];
    self.outgoingBubbleImage            = [MQAssetUtil bubbleOutgoingImage];
    self.messageSendFailureImage        = [MQAssetUtil messageWarningImage];
    self.imageLoadErrorImage            = [MQAssetUtil imageLoadErrorImage];
    
    CGPoint stretchPoint                = CGPointMake(self.incomingBubbleImage.size.width / 4.0f, self.incomingBubbleImage.size.height * 3.0f / 4.0f);
    self.bubbleImageStretchInsets       = UIEdgeInsetsMake(stretchPoint.y, stretchPoint.x, self.incomingBubbleImage.size.height-stretchPoint.y+0.5, stretchPoint.x);
    
    self.incomingMsgSoundFileName       = @"MQNewMessageRing.mp3";
    
    self.maxVoiceDuration               = 60;
}

@end
