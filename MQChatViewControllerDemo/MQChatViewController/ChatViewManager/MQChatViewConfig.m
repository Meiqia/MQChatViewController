//
//  MQChatViewConfig.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewConfig.h"
#import "MQDeviceFrameUtil.h"

@implementation MQChatViewConfig

- (instancetype)init {
    if (self = [super init]) {
        self.chatViewFrame = [MQDeviceFrameUtil getDeviceScreenRect];
#warning 这里增加正则表达式
        self.chatRegexs = [[NSDictionary alloc] init];
        
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
        
        self.incomingMsgTextColor = [UIColor darkTextColor];
        self.outgoingMsgTextColor = [UIColor whiteColor];
        self.eventTextColor = [UIColor grayColor];
        self.navBarTintColor = [UIColor whiteColor];
        self.navBarColor = [UIColor blueColor];
        
#warning 这里需要增加图片名字
        self.agentDefaultAvatarImage = [UIImage imageNamed:@""];
        self.photoSenderImage = [UIImage imageNamed:@""];
        self.voiceSenderImage = [UIImage imageNamed:@""];
        self.incomingBubbleImage = [UIImage imageNamed:@""];
        self.outgoingBubbleImage = [UIImage imageNamed:@""];
#warning 这里需要增加声音文件名字
        self.incomingMsgSoundData = [NSData dataWithContentsOfFile:@""];
        self.outgoingMsgSoundData = [NSData dataWithContentsOfFile:@""];
    }
    return self;
}

@end
