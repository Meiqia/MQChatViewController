//
//  MQChatViewManager.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/27.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQChatViewController.h"
#import "MQChatViewConfig.h"

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
 *  push视图时，隐藏底部TabBar
 *
 *  @param hide 默认为YES
 */
- (void)hidesBottomBarWhenPushed:(BOOL)hide;

/**
 *  设置是否开启自定义聊天界面的坐标，默认不自定义
 *
 *  @param enable YES 自定义 NO 不自定义
 */
- (void)enableCustomChatViewFrame:(BOOL)enable;

/**
 * 设置客服聊天界面的坐标。
 * @warning 默认聊天界面全屏显示。
 * @param viewFrame 客服聊天tableView的界面的坐标
 */
- (void)setChatViewFrame:(CGRect)viewFrame;

/**
 *  设置客服聊天 viewController 的起始坐标点
 *
 *  @param viewPoint 其实坐标点
 *  @warning 默认聊天界面从(0,0)开始，全屏显示。默认支持系统的 navigationController。如果开发者自定义导航栏，可调用此接口调整起始坐标。
 */
- (void)setViewControllerPoint:(CGPoint)viewPoint;

/**
 * 增加消息中可选中的数字的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
 * @param numberRegex 数字的正则表达式
 */
- (void)setMessageNumberRegex:(NSString *)numberRegex;

/**
 * 增加消息中可选中的链接的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
 * @param numberRegex 链接的正则表达式
 */
- (void)setMessageLinkRegex:(NSString *)linkRegex;

/**
 * 增加消息中可选中的email的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
 * @param emailRegex email的正则表达式
 */
- (void)setMessageEmailRegex:(NSString *)emailRegex;

/**
 * 设置顾客第一次进入界面显示的欢迎文字；
 * @param tipText 提示文字
 */
- (void)setChatWelcomeText:(NSString *)welcomText;

/**
 *  设置客服的名字
 *
 *  @param agentName 客服名字
 */
- (void)setAgentName:(NSString *)agentName;

/**
 * 设置收到消息的声音；
 * @param soundFileName 声音文件
 */
- (void)setIncomingMessageSoundFileName:(NSString *)soundFileName;

/**
 * 是否支持发送语音消息；默认支持
 * @param enable YES:支持发送语音消息 NO:不支持发送语音消息
 */
- (void)enableSendVoiceMessage:(BOOL)enable;

/**
 * 是否支持发送图片消息；默认支持
 * @param enable YES:支持发送图片消息 NO:不支持发送图片消息
 */
- (void)enableSendImageMessage:(BOOL)enable;

/**
 *  客服聊天界面打开时，收到新消息，是否显示收到新消息提示；默认支持
 *
 * @param enable YES:支持 NO:不支持
 */
- (void)enableShowNewMessageAlert:(BOOL)enable;

/**
 * 是否支持对方头像的显示；默认支持
 * @param enable YES:支持 NO:不支持
 */
- (void)enableIncomingAvatar:(BOOL)enable;

/**
 *  是否支持当前用户头像的显示；默认不支持
 *
 * @param enable YES:支持 NO:不支持
 */
- (void)enableOutgoingAvatar:(BOOL)enable;

/**
 * 是否开启接受/发送消息的声音；默认开启
 * @param enable YES:开启声音 NO:关闭声音
 */
- (void)enableMessageSound:(BOOL)enable;

/**
 *  是否开启下拉刷新（顶部刷新）；默认开启
 *
 * @warning 如果开发者要禁用下拉刷新，则需要将enableTopPullRefresh和enableTopAutoRefresh都置为false
 * @param enable YES:支持 NO:不支持
 */
- (void)enableTopPullRefresh:(BOOL)enable;

/**
 *  是否开启上拉刷新（底部刷新）；默认关闭
 *
 * @param enable YES:支持 NO:不支持
 */
- (void)enableBottomPullRefresh:(BOOL)enable;

/**
 *  是否开启顶部自动刷新历史消息；默认开启
 *
 * @warning 如果开发者要禁用下拉刷新，则需要将enableTopPullRefresh和enableTopAutoRefresh都置为false
 * @param enable YES:支持 NO:不支持
 */
- (void)enableTopAutoRefresh:(BOOL)enable;

/**
 *  是否开启圆形头像；默认不支持
 *
 * @param enable YES:支持 NO:不支持
 */
- (void)enableRoundAvatar:(BOOL)enable;

/**
 *  是否支持欢迎语；默认不支持
 *
 * @param enable YES:支持 NO:不支持
 */
- (void)enableChatWelcome:(BOOL)enable;

/**
 * 设置发送过来的message的文字颜色；
 * @param textColor 文字颜色
 */
- (void)setIncomingMessageTextColor:(UIColor *)textColor;

/**
 *  设置发送过来的message气泡颜色
 *
 *  @param bubbleColor 气泡颜色
 */
- (void)setIncomingBubbleColor:(UIColor *)bubbleColor;

/**
 * 设置发送出去的message的文字颜色；
 * @param textColor 文字颜色
 */
- (void)setOutgoingMessageTextColor:(UIColor *)textColor;

/**
 *  设置发送的message气泡颜色
 *
 *  @param bubbleColor 气泡颜色
 */
- (void)setOutgoingBubbleColor:(UIColor *)bubbleColor;

/**
 * 开启图片消息的无边框遮罩效果。无边框遮罩效果更加美观，但是更消耗资源，存在图片的聊天界面下，转屏会出现卡顿，所以可能不适用没有锁定转屏的app
 * 默认开启
 * @param enable YES:开启 NO:关闭
 */
- (void)enableMessageImageMask:(BOOL)enable;

/**
 * 设置导航栏上的元素颜色；
 * @param tintColor 导航栏上的元素颜色
 */
- (void)setNavigationBarTintColor:(UIColor *)tintColor;

/**
 * 设置导航栏的背景色；
 * @param barColor 导航栏背景颜色
 */
- (void)setNavigationBarColor:(UIColor *)barColor;

/**
 *  设置导航栏右键的图片
 *
 *  @param rightButtonImage 右键图片
 */
- (void)setNavRightButton:(UIButton *)rightButton;

/**
 *  设置导航栏左键的图片
 *
 *  @param leftButton 左键图片
 */
- (void)setNavLeftButton:(UIButton *)leftButton;

/**
 *  设置导航栏标题
 *
 *  @param titleText 标题文字
 */
- (void)setNavTitleText:(NSString *)titleText;

/**
 *  设置下拉/上拉刷新的颜色；默认绿色
 *
 *  @param pullRefreshColor 颜色
 */
- (void)setPullRefreshColor:(UIColor *)pullRefreshColor;

/**
 * 设置客服的缺省头像图片；
 * @param image 头像image
 */
- (void)setincomingDefaultAvatarImage:(UIImage *)image;

/**
 * 设置顾客的缺省头像图片；
 * @param image 头像image
 */
- (void)setoutgoingDefaultAvatarImage:(UIImage *)image;

/**
 *  设置底部自定义发送图片的按钮图片；
 *  @param image 图片发送按钮image
 *  @param highlightedImage 图片发送按钮选中image
 */
- (void)setPhotoSenderImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

/**
 *  设置底部自定义发送语音的按钮图片；
 *  @param image 语音发送按钮image
 *  @param highlightedImage 语音发送按钮选中image
 */
- (void)setVoiceSenderImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

/**
 *  设置底部自定义发送文字的按钮图片
 *
 *  @param image            文字发送按钮image
 *  @param highlightedImage 文字发送按钮选中image
 */
- (void)setTextSenderImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

/**
 *  设置底部自定义取消键盘的按钮图片
 *
 *  @param image            取消键盘按钮image
 *  @param highlightedImage 取消键盘按钮选中image
 */
- (void)setResignKeyboardImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage;

/**
 * 设置自定义客服的消息气泡（发送过来的消息气泡）的背景图片；
 * @param bubbleImage 气泡图片
 */
- (void)setIncomingBubbleImage:(UIImage *)bubbleImage;

/**
 * 设置自定义顾客的消息气泡（发送出去的消息气泡）的背景图片；
 * @param bubbleImage 气泡图片
 */
- (void)setOutgoingBubbleImage:(UIImage *)bubbleImage;

/**
 *  设置消息气泡的拉伸insets
 *
 *  @param stretchInsets 拉伸insets
 */
- (void)setBubbleImageStretchInsets:(UIEdgeInsets)stretchInsets;

/**
 *  设置录音的最大时长；默认60秒；
 *
 *  @param recordDuration 时长
 */
- (void)setMaxRecordDuration:(NSTimeInterval)recordDuration;

#pragma 以下配置是美洽SDK用户所用到的配置
#ifdef INCLUDE_MEIQIA_SDK
/**
 * 显示的历史聊天消息是否去主动同步服务端的消息记录。因为有可能顾客在其他客户端产生了消息记录，如果设置为NO，则SDK本地消息会与服务端实际的历史消息不相符；默认NO
 * @warning 如果开启同步，将会产生一定网络请求。所以建议顾客端只使用美洽SDK的用户保持默认值
 * @warning 如果开启同步，下拉获取历史消息则会从服务端去获取；如果关闭同步，下拉获取历史消息则是从SDK本地数据库中获取；
 * @param enable YES:同步 NO:不同步
 */
- (void)enableSyncServerMessage:(BOOL)enable;

/**
 *  设置分配给指定的客服id
 *
 *  @param agentId 客服id
 */
- (void)setScheduledAgentId:(NSString *)agentId;

/**
 *  设置分配给指定的客服组id
 *
 *  @warning 如果设置了分配给客服id，以分配给客服id为优先
 *  @param groupId 客服组id
 */
- (void)setScheduledGroupId:(NSString *)groupId;

/**
 *  设置登录客服的开发者自定义id，设置该id后，聊天将会以该自定义id的顾客上线
 *
 *  @warning 如果setLoginMQClientId接口，优先使用setLoginMQClientId来进行登录
 *  @param customizedId 开发者自定义id
 */
- (void)setLoginCustomizedId:(NSString *)customizedId;

/**
 *  设置登录客服的顾客的id，设置该id后，聊天将会以该顾客id的顾客上线
 *
 *  @warning 如果调用了setLoginCustomizedId接口，优先使用此接口来进行登录
 *  @param MQClientId 顾客id
 */
- (void)setLoginMQClientId:(NSString *)MQClientId;

/**
 * 是否显示事件状态流；事件的状态流有：初始化对话、对话被转接给其他客服、对话超时、客服主动结束了对话、客服正在输入；默认不支持；
 * @param enable YES:开启事件状态流 NO:关闭事件状态流
 */
- (void)enableEventDispaly:(BOOL)enable;

/**
 * 设置事件流的显示文字的颜色；
 * @param textColor 文字颜色
 */
- (void)setEventTextColor:(UIColor *)textColor;

#endif


@end
