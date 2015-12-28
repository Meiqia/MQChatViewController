//
//  MQServiceToViewInterface.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/5.
//  Copyright © 2015年 ijinmao. All rights reserved.
//
/**
 *  该文件的作用是：开源聊天界面调用美洽 SDK 接口的中间层，目的是剥离开源界面中的美洽业务逻辑。这样就能让该聊天界面用于非美洽项目中，开发者只需要实现 `MQServiceToViewInterface` 中的方法，即可将自己项目的业务逻辑和该聊天界面对接。
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MQImageMessage.h"
#import "MQVoiceMessage.h"
#import "MQTextMessage.h"
#import "MQEventMessage.h"

/**
 *  该协议是UI层获取数据的委托方法
 */
@protocol MQServiceToViewInterfaceDelegate <NSObject>

/**
 * 获取到多个消息
 * @param messages 消息数组，元素为MQBaseMessage类型
 * @warning 该数组是按时间从旧到新排序
 */
- (void)didReceiveHistoryMessages:(NSArray *)messages;

/**
 * 获取到了新消息
 * @param messages 消息数组，元素为MQBaseMessage类型
 * @warning 该数组是按时间从旧到新排序
 */
- (void)didReceiveNewMessages:(NSArray *)messages;

/**
 *  收到了一条辅助信息（目前只有“客服不在线”、“被转接的消息”）
 *
 *  @param tipsContent 辅助信息
 */
- (void)didReceiveTipsContent:(NSString *)tipsContent;

/**
 * 发送文字消息结果
 * @param message 发送后的消息（包含该消息当前发送状态）
 */
- (void)didSendMessageWithNewMessageId:(NSString *)newMessageId
                          oldMessageId:(NSString *)oldMessageId
                        newMessageDate:(NSDate *)newMessageDate
                            sendStatus:(MQChatMessageSendStatus)sendStatus;

/**
 *  顾客已被转接
 *
 *  @param agentName 被转接的客服名字
 */
- (void)didRedirectWithAgentName:(NSString *)agentName;

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

@property (nonatomic, weak) id<MQServiceToViewInterfaceDelegate> serviceToViewDelegate;

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
 * 根据开发者自定义的id，登陆美洽客服系统
 * @param ;
 */
- (void)setClientOnlineWithCustomizedId:(NSString *)customizedId
                                success:(void (^)(BOOL completion, NSString *agentName, NSArray *receivedMessages))success
                 receiveMessageDelegate:(id<MQServiceToViewInterfaceDelegate>)receiveMessageDelegate;

/**
 * 根据美洽的顾客id，登陆美洽客服系统
 * @param ;
 */
- (void)setClientOnlineWithClientId:(NSString *)clientId
                            success:(void (^)(BOOL completion, NSString *agentName, NSArray *receivedMessages))success
             receiveMessageDelegate:(id<MQServiceToViewInterfaceDelegate>)receiveMessageDelegate;

/**
 *  设置指定分配的客服或客服组
 *
 */
+ (void)setScheduledAgentWithAgentId:(NSString *)agentId
                        agentGroupId:(NSString *)agentGroupId;

/**
 * 设置顾客离线
 * @param ;
 */
+ (void)setClientOffline;

/**
 *  点击了某消息
 *
 *  @param messageId 消息id
 */
+ (void)didTapMessageWithMessageId:(NSString *)messageId;

/**
 *  获取当前客服名字
 */
+ (NSString *)getCurrentAgentName;

/**
 *  当前是否有客服
 *
 */
+ (BOOL)isThereAgent;

/**
 *  下载多媒体消息的多媒体内容
 *
 *  @param messageId     消息id
 *  @param progressBlock 下载进度
 *  @param completion    完成回调
 */
+ (void)downloadMediaWithUrlString:(NSString *)urlString
                          progress:(void (^)(float progress))progressBlock
                        completion:(void (^)(NSData *mediaData, NSError *error))completion;


/**
 *  将数据库中某个message删除
 *
 *  @param messageId 消息id
 */
+ (void)removeMessageInDatabaseWithId:(NSString *)messageId
                           completion:(void (^)(BOOL success, NSError *error))completion;


/**
 *  获取当前顾客的顾客信息
 *
 *  @return 当前的顾客的信息
 *
 */
+ (NSDictionary *)getCurrentClientInfo;

/**
 *  上传顾客的头像
 *
 *  @param avatarImage 头像image
 *  @param completion  上传的回调
 */
+ (void)uploadClientAvatar:(UIImage *)avatarImage
                completion:(void (^)(BOOL success, NSError *error))completion;

@end
