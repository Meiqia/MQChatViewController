//
//  MQVoiceMessageCell.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatBaseCell.h"

/**
 * MQVoiceMessageCell定义了客服聊天界面的语音消息cell
 */
@interface MQVoiceMessageCell : MQChatBaseCell

/**
 *  开始播放声音
 */
//- (void)playVoice;

/**
 *  停止播放声音
 */
- (void)stopVoiceDisplay;


@end
