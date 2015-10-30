//
//  MQManager.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQDelegate.h"
#import <UIKit/UIKit.h>

/**
 * @brief 美洽SDK的配置管理类
 *
 * 开发者可以通过MQManager中提供的接口，对SDK进行配置；
 */
@interface MQManager : NSObject

/**
 * 初始化SDK
 * @param appkey 在美洽管理后台申请的appkey
 * @param delegate 可空，发生异常时的代理函数：-(void)receivedExpcetionStatus:desc:
 */
+ (void)initWithAppkey:(NSString*)appkey expcetionDelegate:(id<MQExpcetionDelegate>)delegate;


/**
 * 设置用户开发者自定义该用户需要展示给客服的信息。键值都必须为字符串
 * @param clientInfo 美洽已定义的用户信息。详见开发文档
 * @param otherInfo 其他信息，键值可以为任意字符串
 */
+ (void)setClientInfo:(NSDictionary*)clientInfo addOtherInfo:(NSDictionary*)otherInfo;

/**
 * 设置用户的设备唯一标识
 * @param deviceToken 设备唯一标识，用于推送服务;
 */
+ (void)registerDeviceToken:(NSString *)deviceToken;

/**
 * 设置当没有在客服聊天界面时，收到客服消息，是否有声音提醒
 * @param enable YES:开启声音提醒  NO:关闭声音提醒;
 */
+ (void)enableInAppMessageSound:(BOOL)enable;

/**
 * 设置将顾客分配给某一个客服组
 * @warning 该接口需要在用户上线前进行配置
 * @param groupId 客服组id;
 */
+ (void)setClientToSpecifiedAgentGroupWithGroupId:(NSString *)groupId;

/**
 * 设置将顾客分配给某一个客服
 * @warning 该接口需要在用户上线前进行配置
 * @param groupId 客服id;
 */
+ (void)setClientToSpecifiedAgentWithAgentId:(NSString *)agentId;

/**
 * 设置顾客上线
 * @param ;
 */
#warning 这里需要修改
+ (void)setClientOnline;

/**
 * 设置顾客离线
 * @param ;
 */
#warning 这里需要修改
+ (void)setClientOffline;

/**
 * 从服务端获取更多消息
 * @param msgDate 获取该日期之前的历史消息;
 * @param messagesNum 获取消息的数量
 */
+ (void)getHistoryMessagesWithMsgDate:(NSDate *)msgDate messagesNumber:(NSInteger)messagesNumber delegate:(id<MQMessageDelegate>)delegate;

/**
 * 发送文字消息
 * @param content 消息内容。会做前后去空格处理，处理后的消息长度不能为0，否则不执行发送操作
 * @param delegate 发送消息的代理，如果发送成功，会返回完整的消息对象，代理函数：-(void)didSendMessage:expcetion:
 * @return 该条文字消息。此时该消息状态为发送中.
 * @warning MQChatViewController已经调用了该函数。如果使用了MQChatViewController，请勿重复使用该函数。
 */
+ (MQMessage *)sendTextMessageWithContent:(NSString *)content delegate:(id<MQMessageDelegate>)delegate;

/**
 * 发送图片消息。该函数会做图片压缩操作，尺寸将会限制在最大1280px
 * @param image 图片
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)didSendMessage:expcetion:
 * @return 该条图片消息。此时该消息状态为发送中，message的content属性是本地图片路径（已压缩），没有网络图片路径
 * @warning MQChatViewController已经调用了该函数。如果使用了MQChatViewController，请勿重复使用该函数。
 */
+ (MQMessage *)sendImageMessageWithImage:(UIImage *)image delegate:(id<MQMessageDelegate>)delegate;

/**
 * 发送语音消息。使用该接口，需要开发者提供一条amr格式的语音.
 * @param audio 需要发送的语音消息，格式为amr。
 * @param delegate 发送消息的代理，会返回完整的消息对象，代理函数：-(void)didSendMessage:expcetion:
 * @return 该条语音消息。此时该消息状态为发送中，message的content属性是本地语音路径.
 * @warning MCChatViewController已经调用了该函数。如果使用了MCChatViewController，请勿重复使用该函数。
 */
+ (MQMessage *)sendAudioMessage:(NSData *)audio delegate:(id<MQMessageDelegate>)delegate;

/**
 * 将用户正在输入的内容，提供给客服查看。该接口没有调用限制，但每1秒内只会向服务器发送一次数据
 * @param content 提供给客服看到的内容
 */
+ (void)sendClientInputtingWithContent:(NSString *)content;

/**
 * 获取离线推送的绑定id，将此id提供给极推送，完成推送设备的绑定
 * @param content 提供给客服看到的内容
 */
+ (void)getOfflinePushIdWithDelegate:(id<MQOfflinePushDelegate>)delegate;

/**
 * 为了使美洽获取到推送消息，在AppDelegate.m中application:didReceiveRemoteNotification收到了远程推送后，判断消息字典中的"origin"key是否为"meiqia"，如果是meiqia的远程消息，需要将消息的字典传给meiqia
 *  @param notification 收到的消息字典
 * Example usage
 *  - (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
 *  {
 *      if ([[userInfo objectForKey:@"origin"] isEqualToString:@"meiqia"]) {
 *          [MQManager handleRemoteNotification:userInfo];
 *      }
 *  }
 */
+ (void)handleRemoteNotification:(NSDictionary *)notification;

/**
 * 获得当前美洽SDK的版本号
 */
+ (NSString *)getMeiQiaSDKVerstion;

/**
 * 获取当前正在交流的客服基本信息
 * @param content 提供给客服看到的内容
 */
+ (void)getCurrentAgentInfo:(MQAgent *)agentInfo;


@end
