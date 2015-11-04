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
    
    self.agentOnlineTipText = @"客服上线了";
    self.agentOfflineTipText = @"客服下线了";
    self.chatWelcomText = @"你好，请问有什么可以帮到您？";
    
    self.enableSyncServerMessage = false;
    self.enableEventDispaly = true;
    self.enableVoiceMessage = true;
    self.enableImageMessage = true;
    self.enableTipsView = true;
    self.enableAgentAvatar = true;
    self.enableCustomRecordView = true;
    self.enableMessageSound = true;
    self.enableClientAvatar = false;
    
    self.incomingMsgTextColor = [UIColor darkTextColor];
    self.outgoingMsgTextColor = [UIColor whiteColor];
    self.eventTextColor = [UIColor grayColor];
    self.navBarTintColor = [UIColor whiteColor];
    self.navBarColor = [UIColor blueColor];
    
    self.agentDefaultAvatarImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQIcon"]];
    self.photoSenderImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQMessageCameraInputImage"]];
    self.keyboardSenderImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQMessageTextInputImage"]];
    self.voiceSenderImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQMessageVoiceInputImage"]];
    self.incomingBubbleImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQBubbleIncoming"]];
    self.outgoingBubbleImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQBubbleOutgoing"]];
    self.messageSendFailureImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQMessageWarning"]];
#warning 这里需要增加声音文件名字
    self.incomingMsgSoundData = [NSData dataWithContentsOfFile:@""];
    self.outgoingMsgSoundData = [NSData dataWithContentsOfFile:@""];
    
    self.maxVoiceDuration = 60;
}

@end
