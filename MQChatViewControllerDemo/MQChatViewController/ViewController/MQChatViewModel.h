//
//  MQChatViewModel.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQBaseMessage.h"
#import <UIKit/UIKit.h>
//是否是调试SDK
#define INCLUDE_MEIQIA_SDK

@protocol MQChatViewModelDelegate

/**
 *  获取到了更多历史消息
 */
- (void)didGetHistoryMessages;

/**
 *  已经发送了这条消息（可能这条消息是发送成功/失败/正在发送）
 */
- (void)didSendMessageWithIndexPath:(NSIndexPath *)indexPath;

@end

/**
 * @brief 聊天界面的ViewModel
 *
 * MQChatViewModel管理者MQChatViewController中的数据
 */
@interface MQChatViewModel : NSObject

/** MQChatViewModel的委托 */
@property (nonatomic) id<MQChatViewModelDelegate>delegate;

/** cellModel的缓存 */
@property (nonatomic, strong) NSMutableArray *cellModels;

/**
 * 获取更多历史聊天消息
 */
- (void)startGettingHistoryMessages;

/**
 * 发送文字消息
 */
- (void)sendTextMessageWithContent:(NSString *)content;

/**
 * 发送图片消息
 */
- (void)sendImageMessageWithImage:(UIImage *)image;

/**
 * 发送语音消息
 */
- (void)sendVoiceMessageWithVoice:(NSData *)voiceData;

/**
 * 发送“用户正在输入”的消息
 */
- (void)sendUserInputtingWithContent:(NSString *)content;



@end
