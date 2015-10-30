//
//  MQChatViewConfig.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * @brief MQChatViewConfig为客服聊天界面的前置配置，由MQChatViewManager生成，在MQChatViewController中消费
 *
 */
@interface MQChatViewConfig : NSObject

@property (nonatomic, assign) CGRect chatViewFrame;
@property (nonatomic, strong) NSDictionary *chatRegexs;

@property (nonatomic, copy) NSString *agentOnlineTipText;
@property (nonatomic, copy) NSString *agentOfflineTipText;
@property (nonatomic, copy) NSString *chatWelcomText;

@property (nonatomic, assign) BOOL enableSyncServerMessage;
@property (nonatomic, assign) BOOL enableEventDispaly;
@property (nonatomic, assign) BOOL enableVoiceMessage;
@property (nonatomic, assign) BOOL enableImageMessage;
@property (nonatomic, assign) BOOL enableTipsView;
@property (nonatomic, assign) BOOL enableAgentAvatar;
@property (nonatomic, assign) BOOL enableCustomRecordView;
@property (nonatomic, assign) BOOL enableMessageSound;

@property (nonatomic, copy) UIColor *incomingMsgTextColor;
@property (nonatomic, copy) UIColor *outgoingMsgTextColor;
@property (nonatomic, copy) UIColor *eventTextColor;
@property (nonatomic, copy) UIColor *navBarTintColor;
@property (nonatomic, copy) UIColor *navBarColor;

@property (nonatomic, strong) UIImage *agentDefaultAvatarImage;
@property (nonatomic, strong) UIImage *photoSenderImage;
@property (nonatomic, strong) UIImage *voiceSenderImage;
@property (nonatomic, strong) UIImage *incomingBubbleImage;
@property (nonatomic, strong) UIImage *outgoingBubbleImage;

@property (nonatomic, strong) NSData *incomingMsgSoundData;
@property (nonatomic, strong) NSData *outgoingMsgSoundData;

@end
