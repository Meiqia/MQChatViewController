//
//  MQServiceToViewInterface.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/5.
//  Copyright © 2015年 ijinmao. All rights reserved.
//
/**
 *  该类是美洽开源UI层和美洽数据逻辑层的接口
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MQImageMessage.h"
#import "MQVoiceMessage.h"
#import "MQTextMessage.h"
#import "MQAgent.h"

/**
 *  该协议是UI层获取数据的委托方法
 */
@protocol MQServiceToViewInterfaceDelegate <NSObject>

/**
 * 获取到多个消息
 * @param messages 消息数组，元素为MQBaseMessage类型
 * @warning 该数组是按时间从旧到新排序
 */
- (void)didReceiveHistoryMessages:(NSArray *)messages totalNum:(NSInteger)totalNum;

/**
 *  收到了一条MQTextMessage类型的即时消息
 *
 *  @param message MQTextMessage类型
 */
- (void)didReceiveTextMessage:(MQTextMessage *)message;

/**
 *  收到了一条MQImageMessage类型的即时消息
 *
 *  @param message MQImageMessage类型
 */
- (void)didReceiveImageMessage:(MQImageMessage *)message;

/**
 *  收到了一条MQVoiceMessage类型的即时消息
 *
 *  @param message MQVoiceMessage类型
 */
- (void)didReceiveVoiceMessage:(MQVoiceMessage *)message;

/**
 * 发送文字消息结果
 * @param message 发送后的消息（包含该消息当前发送状态）
 */
- (void)didSendMessageWithNewMessageId:(NSString *)newMessageId
                          oldMessageId:(NSString *)oldMessageId
                        newMessageDate:(NSDate *)newMessageDate
                            sendStatus:(MQChatMessageSendStatus)sendStatus;

/**
 *  得到为该client服务的客服信息
 *
 *  @param agent 客服实体
 */
- (void)didScheduledWithAgent:(MQAgent *)agent;

@end

/**
 *  界面发送的请求出错的委托方法
 */
@protocol MQServiceToViewInterfaceErrorDelegate <NSObject>
/**
 *  收到获取历史消息的错误
 */
- (void)getLoadHistoryMessageError;

@end

/**
 *  MQServiceToViewInterface是美洽开源UI层和美洽数据逻辑层的接口
 */
@interface MQServiceToViewInterface : NSObject

/**
 * 从服务端获取更多消息
 *
 * @param msgDate 获取该日期之前的历史消息;
 * @param messagesNum 获取消息的数量
 */
+ (void)getServerHistoryMessagesWithMsgDate:(NSDate *)msgDate
                             messagesNumber:(NSInteger)messagesNumber
                            successDelegate:(id<MQServiceToViewInterfaceDelegate>)successDelegate
                              errorDelegate:(id<MQServiceToViewInterfaceErrorDelegate>)errorDelegate;

/**
 * 从本地获取更多消息
 *
 * @param msgDate 获取该日期之前的历史消息;
 * @param messagesNum 获取消息的数量
 */
+ (void)getDatabaseHistoryMessagesWithMsgDate:(NSDate *)msgDate
                               messagesNumber:(NSInteger)messagesNumber
                                     delegate:(id<MQServiceToViewInterfaceDelegate>)delegate;

/**
 * 发送文字消息
 * @param content 消息内容。会做前后去空格处理，处理后的消息长度不能为0，否则不执行发送操作
 * @param localMessageId 本地消息id
 * @param delegate 发送消息的代理，如果发送成功，会返回完整的消息对象，代理函数：-(void)didSendMessage:expcetion:
 */
+ (void)sendTextMessageWithContent:(NSString *)content
                         messageId:(NSString *)localMessageId
                          delegate:(id<MQServiceToViewInterfaceDelegate>)delegate;

/**
 * 发送图片消息。该函数会做图片压缩操作，尺寸将会限制在最大1280px
 *
 * @param image 图片
 * @param localMessageId 本地消息id
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)didSendMessage:expcetion:
 */
+ (void)sendImageMessageWithImage:(UIImage *)image
                        messageId:(NSString *)localMessageId
                         delegate:(id<MQServiceToViewInterfaceDelegate>)delegate;

/**
 * 发送语音消息。使用该接口，需要开发者提供一条amr格式的语音.
 *
 * @param audio 需要发送的语音消息，格式为amr。
 * @param localMessageId 本地消息id
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)didSendMessage:expcetion:
 */
+ (void)sendAudioMessage:(NSData *)audio
               messageId:(NSString *)localMessageId
                delegate:(id<MQServiceToViewInterfaceDelegate>)delegate;

/**
 * 将用户正在输入的内容，提供给客服查看。该接口没有调用限制，但每1秒内只会向服务器发送一次数据
 * @param content 提供给客服看到的内容
 */
+ (void)sendClientInputtingWithContent:(NSString *)content;

/**
 * 设置顾客上线
 * @param ;
 */
+ (void)setClientOnlineWithSuccess:(void (^)(BOOL completion))success;

/**
 * 设置顾客离线
 * @param ;
 */
+ (void)setClientOfflineWithSuccess:(void (^)(BOOL completion))success;

@end
