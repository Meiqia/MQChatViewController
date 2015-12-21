//
//  MQChatViewConfig.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//是否引入美洽SDK
//#define INCLUDE_MEIQIA_SDK

/** 关闭键盘的通知 */
extern NSString * const MQChatViewKeyboardResignFirstResponderNotification;
/** 中断audio player的通知 */
extern NSString * const MQAudioPlayerDidInterruptNotification;

/**
 * @brief MQChatViewConfig为客服聊天界面的前置配置，由MQChatViewManager生成，在MQChatViewController内部逻辑消费
 *
 */
@interface MQChatViewConfig : NSObject

@property (nonatomic, assign) BOOL isCustomizedChatViewFrame;
@property (nonatomic, assign) CGRect chatViewFrame;
@property (nonatomic, assign) CGPoint chatViewControllerPoint;
@property (nonatomic, strong) NSMutableArray *numberRegexs;
@property (nonatomic, strong) NSMutableArray *linkRegexs;
@property (nonatomic, strong) NSMutableArray *emailRegexs;

@property (nonatomic, copy  ) NSString *chatWelcomeText;
@property (nonatomic, copy  ) NSString *agentName;
@property (nonatomic, copy  ) NSString *incomingMsgSoundFileName;
@property (nonatomic, copy  ) NSString *scheduledAgentId;
@property (nonatomic, copy  ) NSString *scheduledGroupId;
@property (nonatomic, copy  ) NSString *MQClientId;
@property (nonatomic, copy  ) NSString *customizedId;
@property (nonatomic, copy  ) NSString *navTitleText;

@property (nonatomic, assign) BOOL enableSyncServerMessage;
@property (nonatomic, assign) BOOL enableEventDispaly;
@property (nonatomic, assign) BOOL enableSendVoiceMessage;
@property (nonatomic, assign) BOOL enableSendImageMessage;
@property (nonatomic, assign) BOOL enableIncomingAvatar;
@property (nonatomic, assign) BOOL enableOutgoingAvatar;
@property (nonatomic, assign) BOOL enableMessageImageMask;
@property (nonatomic, assign) BOOL enableMessageSound;
@property (nonatomic, assign) BOOL enableTopPullRefresh;
@property (nonatomic, assign) BOOL enableBottomPullRefresh;
@property (nonatomic, assign) BOOL enableRoundAvatar;
@property (nonatomic, assign) BOOL enableChatWelcome;
@property (nonatomic, assign) BOOL enableTopAutoRefresh;
@property (nonatomic, assign) BOOL enableShowNewMessageAlert;
@property (nonatomic, assign) BOOL isPushChatView;

@property (nonatomic, copy) UIColor *incomingMsgTextColor;
@property (nonatomic, copy) UIColor *incomingBubbleColor;
@property (nonatomic, copy) UIColor *outgoingMsgTextColor;
@property (nonatomic, copy) UIColor *outgoingBubbleColor;
@property (nonatomic, copy) UIColor *eventTextColor;
@property (nonatomic, copy) UIColor *redirectAgentNameColor;
@property (nonatomic, copy) UIColor *navBarTintColor;
@property (nonatomic, copy) UIColor *navBarColor;
@property (nonatomic, copy) UIColor *pullRefreshColor;

@property (nonatomic, strong) UIImage *incomingDefaultAvatarImage;
@property (nonatomic, strong) UIImage *outgoingDefaultAvatarImage;
@property (nonatomic, strong) UIImage *messageSendFailureImage;
@property (nonatomic, strong) UIImage *photoSenderImage;
@property (nonatomic, strong) UIImage *photoSenderHighlightedImage;
@property (nonatomic, strong) UIImage *voiceSenderImage;
@property (nonatomic, strong) UIImage *voiceSenderHighlightedImage;
@property (nonatomic, strong) UIImage *keyboardSenderImage;
@property (nonatomic, strong) UIImage *keyboardSenderHighlightedImage;
@property (nonatomic, strong) UIImage *resignKeyboardImage;
@property (nonatomic, strong) UIImage *resignKeyboardHighlightedImage;
@property (nonatomic, strong) UIImage *incomingBubbleImage;
@property (nonatomic, strong) UIImage *outgoingBubbleImage;
@property (nonatomic, strong) UIImage *imageLoadErrorImage;

@property (nonatomic, assign) UIEdgeInsets bubbleImageStretchInsets;

@property (nonatomic, strong) UIButton *navBarLeftButton;
@property (nonatomic, strong) UIButton *navBarRightButton;

@property (nonatomic, assign) NSTimeInterval maxVoiceDuration;

+ (instancetype)sharedConfig;

/** 将配置设置为默认值 */
- (void)setConfigToDefault;

@end
