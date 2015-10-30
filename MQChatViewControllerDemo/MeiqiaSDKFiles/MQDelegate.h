//
//  MQDelegate.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQDefinition.h"
#import "MQMessage.h"
#import "MQAgent.h"

@protocol MQExpcetionDelegate <NSObject>
@optional

/**
 * 发生异常
 * @param status 异常类型
 * @param description 异常描述
 */
- (void)receivedExpcetionStatus:(kMQExceptionStatus)staus desc:(NSString *)description;
@end


@protocol MQMessageDelegate <NSObject>
/**
 * 获取到多个消息
 * @param messages 消息数组，元素为MQMessage类型
 */
- (void)didReceiveMultipleMessage:(NSArray *)messages;

/**
 * 收到了一条即时消息
 * @param message MQMessage类型
 */
- (void)didReceiveMessage:(MQMessage *)message;

@optional
/**
 * 发送消息结果
 * @param message 发送后的消息（包含该消息当前发送状态）
 * @param expcetion 失败原因（如果为-1，则代表发送成功）
 */
- (void)didSendMessage:(MQMessage *)message expcetion:(kMQExceptionStatus)expcetion;

/**
 * 在关闭客服聊天界面的情况下，收到了未读消息数的数量
 * @param badgeNumber 未读的消息数量
 * @param expcetion 失败原因（如果为-1，则代表发送成功）
 */
- (void)didReceiveUnReadMessageNumber:(NSInteger)badgeNumber expcetion:(kMQExceptionStatus)expcetion;



@end

@protocol MQOfflinePushDelegate <NSObject>
@optional

/**
 * 收到了离线推送的绑定id
 * @param pushId 获得的推送绑定的id，将此id提供给极推送
 * @warning 需要将此id作为极推送alias参数传给函数: + (void)setAlias:callbackSelector:object，才能开启推送
 */
- (void)didRecieveOfflinePushId:(NSString *)pushId expcetion:(kMQExceptionStatus)expcetion;


/**
 * 开启/关闭离线推送
 * @param enable YES:开启离线推送  NO:关闭离线推送
 */
- (void)enableOfflineNotification:(BOOL)enable expcetion:(kMQExceptionStatus)expcetion;



@end


@protocol MQChatViewDelegate <NSObject>
@optional
/**
 * 客服改变。
 * 分配成功或发生客服转接时，agent有值，expcetion为nil；
 * 分配失败或客服下线时，agent为nil，expcetion有值
 */
- (void)didChangeAgent:(MQAgent *)agent expcetion:(kMQExceptionStatus)expcetion;

/**
 * 用户即将关闭视图
 */
- (void)chatViewWillDisappear;

/**
 * 用户已经关闭视图
 */
- (void)chatViewDidDisappear;

/**
 * 消息中与regexs中的正则表达式匹配上的内容被点击的协议（若regexs使用默认值，可以不用实现该方法）
 * @param content 被点击的消息
 * @param selectedContent 与正则表达式匹配的内容
 */
- (void)didSelectMessageContent:(NSString *)content selectedContent:(NSString *)selectedContent NS_AVAILABLE_IOS(7_0);

/**
 * 「用户准备录音」的回调
 * 如果使用了美洽的语音功能，建议在开始录音时暂停APP的音频播放，结束录音时恢复播放
 */
- (void)recordVoiceWillBegin;

/**
 * 「结束录音」的回调
 * 如果使用了美洽的语音功能，建议在开始录音时暂停APP的音频播放，结束录音时恢复播放
 */
- (void)recordVoiceDidEnd;

/**
 * 「录音的音量发生辩护」的回调
 */
- (void)recordVolumnDidUpdate;

@end


