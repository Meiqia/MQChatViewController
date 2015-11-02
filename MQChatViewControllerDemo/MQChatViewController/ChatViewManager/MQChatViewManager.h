//
//  MQChatViewManager.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQChatViewController.h"

/**
 * @brief 客服聊天界面的配置类
 *
 * 开发者可以通过MQChatViewManager中提供的接口，来对客服聊天界面进行自定义配置；
 */
@interface MQChatViewManager : NSObject

/**
 * 在一个ViewController中Push出一个客服聊天界面
 * @param viewController 在这个viewController中push出客服聊天界面
 */
- (MQChatViewController *)pushMQChatViewControllerInViewController:(UIViewController *)viewController;

/**
 * 在一个ViewController中Present出一个客服聊天界面的Modal视图
 * @param viewController 在这个viewController中push出客服聊天界面
 */
- (MQChatViewController *)presentMQChatViewControllerInViewController:(UIViewController *)viewController;

/**
 * 将客服聊天界面移除
 */
- (void)disappearMQChatViewController;

/**
 * 设置客服聊天界面的坐标
 * @param viewFrame 客服聊天界面的坐标
 */
- (void)setChatViewFrame:(CGRect)viewFrame;

/**
 * 数字的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
 * @param numberRegex 数字的正则表达式
 */
- (void)setMessageNumberRegex:(NSString *)numberRegex;

/**
 * 链接的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
 * @param numberRegex 链接的正则表达式
 */
- (void)setMessageLinkRegex:(NSString *)linkRegex;

/**
 * email的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
 * @param emailRegex email的正则表达式
 */
- (void)setMessageEmailRegex:(NSString *)emailRegex;

/**
 * 显示的历史聊天消息是否去主动同步服务端的消息记录。因为有可能顾客在其他客户端产生了消息记录，如果设置为NO，则SDK本地消息会与服务端实际的历史消息不相符；默认NO
 * @warning 如果开启同步，将会产生一定网络请求。所以建议顾客端只使用美洽SDK的用户保持默认值
 * @warning 如果开启同步，下拉获取历史消息则会从服务端去获取；如果关闭同步，下拉获取历史消息则是从SDK本地数据库中获取；
 * @param enable YES:同步 NO:不同步
 */
- (void)enableSyncServerMessage:(BOOL)enable;

/**
 * 是否显示事件状态流；事件的状态流有：初始化对话、对话被转接给其他客服、对话超时、客服主动结束了对话、客服正在输入；
 * @param enable YES:开启事件状态流 NO:关闭事件状态流
 */
- (void)enableEventDispaly:(BOOL)enable;

/**
 * 是否支持发送语音消息；
 * @param enable YES:支持发送语音消息 NO:不支持发送语音消息
 */
- (void)enableVoiceMessage:(BOOL)enable;

/**
 * 是否支持发送图片消息；
 * @param enable YES:支持发送图片消息 NO:不支持发送图片消息
 */
- (void)enableImageMessage:(BOOL)enable;

/**
 * 是否支持状态提示的alert界面，状态提示有：网络连接不正常、SDK初始化不正确；
 * @param enable YES:支持 NO:不支持
 */
- (void)enableTipsView:(BOOL)enable;

/**
 * 设置发送过来的message的文字颜色；
 * @param textColor 文字颜色
 */
- (void)setIncomingMessageTextColor:(UIColor *)textColor;

/**
 * 设置发送出去的message的文字颜色；
 * @param textColor 文字颜色
 */
- (void)setOutgoingMessageTextColor:(UIColor *)textColor;

/**
 * 设置事件流的显示文字的颜色；
 * @param textColor 文字颜色
 */
- (void)setEventTextColor:(UIColor *)textColor;

/**
 * 设置导航栏的文字背景色；
 * @param tintColor 导航栏文字颜色
 */
- (void)setNavigationBarTintColor:(UIColor *)tintColor;

/**
 * 设置导航栏的背景色；
 * @param barColor 导航栏背景颜色
 */
- (void)setNavigationBarColor:(UIColor *)barColor;

/**
 * 设置客服上线的提示文字；
 * @param tipText 提示文字
 */
- (void)setAgentOnlineTip:(NSString *)tipText;

/**
 * 设置客服下线的提示文字；
 * @param tipText 提示文字
 */
- (void)setAgentOfflineTip:(NSString *)tipText;

/**
 * 设置顾客第一次进入界面显示的欢迎文字；
 * @param tipText 提示文字
 */
- (void)setChatWelcomText:(NSString *)welcomText;

/**
 * 是否支持客服头像的显示；
 * @param enable YES:支持 NO:不支持
 */
- (void)enableAgentAvatar:(BOOL)enable;

/**
 * 设置客服的缺省头像图片；
 * @param image 头像image
 */
- (void)setAgentDefaultAvatarImage:(UIImage *)image;

/**
 * 设置底部自定义发送图片的按钮图片；
 * @param image 按钮image
 */
- (void)setPhotoSenderImage:(UIImage *)image;

/**
 * 设置底部自定义发送语音的按钮图片；
 * @param image 按钮image
 */
- (void)setVoiceSenderImage:(UIImage *)image;

/**
 * 设置自定义客服的消息气泡（发送过来的消息气泡）的背景图片；
 * @param bubbleImage 气泡图片
 */
#warning 增加气泡图片的比例限制
- (void)setIncomingBubbleImage:(UIImage *)bubbleImage;

/**
 * 设置自定义顾客的消息气泡（发送出去的消息气泡）的背景图片；
 * @param bubbleImage 气泡图片
 */
#warning 增加气泡图片的比例限制
- (void)setOutgoingBubbleImage:(UIImage *)bubbleImage;

/**
 * 是否支持自定义录音的界面；
 * @param enable YES:支持 NO:不支持
 */
- (void)enableCustomRecordView:(BOOL)enable;

/**
 * 是否开启接受/发送消息的声音；
 * @param enable YES:开启声音 NO:关闭声音
 */
- (void)enableMessageSound:(BOOL)enable;

/**
 * 设置发送消息后的声音；
 * @param enable YES:开启声音 NO:关闭声音
 */
- (void)setOutgoingMessageSound:(NSData *)soundData;

/**
 * 是否开启接受/发送消息的声音；
 * @param enable YES:开启声音 NO:关闭声音
 */
- (void)setIncomingMessageSound:(NSData *)soundData;







@end
