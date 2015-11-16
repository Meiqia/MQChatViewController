//
//  MQChatViewConfig.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewConfig.h"
#import "MQDeviceFrameUtil.h"
#import "MQChatFileUtil.h"
#import "MQAssetUtil.h"

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
    self.isCustomizedChatViewFrame = false;
    self.chatViewFrame = [MQDeviceFrameUtil getDeviceScreenRect];

    self.numberRegexs = [[NSMutableArray alloc] initWithArray:@[@"^(\\d{3,4}-?)\\d{7,8}$", @"^1[3|4|5|7|8]\\d{9}", @"[1-9]\\d{4,10}"]];
    self.linkRegexs   = [[NSMutableArray alloc] initWithArray:@[@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"]];
    self.emailRegexs  = [[NSMutableArray alloc] initWithArray:@[@"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"]];
    
    self.agentOnlineTipText  = @"客服上线了";
    self.agentOfflineTipText = @"客服下线了";
    self.chatWelcomeText     = @"你好，请问有什么可以帮到您？";
    self.agentName           = @"美洽小助手";
    
    self.enableSyncServerMessage = true;
    self.enableEventDispaly      = true;
    self.enableVoiceMessage      = true;
    self.enableImageMessage      = true;
    self.enableTipsView          = true;
    self.enableAgentAvatar       = true;
    self.enableCustomRecordView  = true;
    self.enableMessageSound      = true;
    self.enableClientAvatar      = false;
    self.enableTopPullRefresh    = false;
    self.enableBottomPullRefresh = false;
    self.enableRoundAvatar       = false;
    self.enableWelcomeChat       = false;
    self.enableTopAutoRefresh    = true;
    self.isPresentChatView       = false;
    self.isPushChatView          = false;
    
    self.incomingMsgTextColor   = [UIColor darkTextColor];
    self.outgoingMsgTextColor   = [UIColor darkTextColor];
    self.eventTextColor         = [UIColor grayColor];
    self.navBarTintColor        = [UIColor blueColor];
    self.navBarColor            = [UIColor whiteColor];
    self.pullRefreshColor       = [UIColor colorWithRed:104.0/255.0 green:192.0/255.0 blue:160.0/255.0 alpha:1.0];
    self.redirectAgentNameColor = [UIColor colorWithRed:169.0/255.0 green:169.0/255.0 blue:49.0/255.0 alpha:1.0];
    
    self.agentDefaultAvatarImage  = [MQAssetUtil agentDefaultAvatarImage];
    self.clientDefaultAvatarImage = [MQAssetUtil clientDefaultAvatarImage];
    self.photoSenderImage         = [MQAssetUtil messageCameraInputImage];
    self.keyboardSenderImage      = [MQAssetUtil messageTextInputImage];
    self.voiceSenderImage         = [MQAssetUtil messageVoiceInputImage];
    self.incomingBubbleImage      = [MQAssetUtil bubbleIncomingImage];
    self.outgoingBubbleImage      = [MQAssetUtil bubbleOutgoingImage];
    self.messageSendFailureImage  = [MQAssetUtil messageWarningImage];
    self.navBarLeftButtomImage    = [MQAssetUtil returnCancelImage];
    
    self.incomingMsgSoundFileName = [MQAssetUtil resourceWithName:@"MQNewMessageRing.mp3"];
    
    self.maxVoiceDuration = 60;
}

@end
