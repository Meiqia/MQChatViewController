//
//  MQCellModelProtocol.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQChatBaseCell.h"
#import "MQChatFileUtil.h"
#import "MQBaseMessage.h"
#import "MQDateFormatterUtil.h"

//定义cell中的布局间距等
/**
 * 头像距离屏幕水平边沿距离
 */
static CGFloat const kMQCellAvatarToHorizontalEdgeSpacing = 16.0;
/**
 * 头像距离屏幕垂直边沿距离
 */
static CGFloat const kMQCellAvatarToVerticalEdgeSpacing = 16.0;
/**
 * 头像与聊天气泡之间的距离
 */
static CGFloat const kMQCellAvatarToBubbleSpacing = 8.0;
/**
 * 聊天气泡和其中的文字较大一边的水平间距
 */
static CGFloat const kMQCellBubbleToTextHorizontalLargerSpacing = 16.0;
/**
 * 聊天气泡和其中的文字较小一边的水平间距
 */
static CGFloat const kMQCellBubbleToTextHorizontalSmallerSpacing = 10.0;
/**
 * 聊天气泡和其中的文字垂直间距
 */
static CGFloat const kMQCellBubbleToTextVerticalSpacing = 8.0;
/**
 * 聊天气泡最大宽度与边沿的距离
 */
static CGFloat const kMQCellBubbleMaxWidthToEdgeSpacing = 32.0;
/**
 * 聊天头像的直径
 */
static CGFloat const kMQCellAvatarDiameter = 36.0;
/**
 * 聊天内容的文字大小
 */
static CGFloat const kMQCellTextFontSize = 16.0;
/**
 * 聊天内容间隔的时间cell高度
 */
static CGFloat const kMQChatMessageDateCellHeight = 36.0;
/**
 * 聊天内容间隔的时间的label向下偏移的数量
 */
static CGFloat const kMQChatMessageDateLabelVerticalOffset = 8.0;
/**
 * 聊天内容间隔的时间fontSize
 */
static CGFloat const kMQChatMessageDateLabelFontSize = 12.0;
/**
 * 聊天内容间隔的时间距离cell两端的间距
 */
static CGFloat const kMQChatMessageDateLabelToEdgeSpacing = 16.0;
/**
 * 聊天气泡和Indicator的间距
 */
static CGFloat const kMQCellBubbleToIndicatorSpacing = 8.0;
/**
 * indicator的diameter
 */
static CGFloat const kMQCellIndicatorDiameter = 33.0;
/**
 * 语音时长label的font size
 */
static CGFloat const kMQCellVoiceDurationLabelFontSize = 12.0;
/**
 * text label的line spacing
 */
static CGFloat const kMQTextCellLineSpacing = 6.0;


/**
 *  cell的来源枚举定义
 *  MQCellIncoming - 收到的消息cell
 *  MQCellOutgoing - 发送的消息cell
 */
typedef NS_ENUM(NSUInteger, MQChatCellFromType) {
    MQChatCellIncoming,
    MQChatCellOutgoing
};

/**
 *  cell的发送状态
 *  MQChatCellSending       - 正在发消息
 *  MQChatCellSended        - 消息已发送
 *  MQChatCellSentFailure   - 消息发送失败
 */
//typedef NS_ENUM(NSUInteger, MQChatMessageSendStatus) {
//    MQChatCellSending,
//    MQChatCellSended,
//    MQChatCellSentFailure
//};

/**
 * MQCellModelProtocol协议定义了ChatCell的view需要满足的方法，开发者也可根据自身需要，增加协议方法
 *
 */
@protocol MQCellModelProtocol <NSObject>

/**
 *  @return cell中的view.
 */
- (CGFloat)getCellHeight;

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (UITableViewCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer;

/**
 *  @return cell的消息时间.
 */
- (NSDate *)getCellDate;

/**
 *  该协议方法定义了，某一个cell是否是业务相关的cell，比如文字消息、图片消息、语音消息、链接消息即是业务相关cell等，而时间cell、提示cell等不属于业务相关cell
 *  该协议方法用于，判断两个业务相关cell时间相差过大，如果时间相差过大，他们之间需要插入一个时间cell
 *  @return 是否是业务相关的cell
 */
- (BOOL)isServiceRelatedCell;

/**
 *  @warning 非业务相关的cellModel，返回空字符串即可；
 *  @return cell的消息id.
 */
- (NSString *)getCellMessageId;

/**
 *  根据cellWidth来重新布局
 *
 *  @param cellWidth cell宽度
 */
- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth;

@optional
/**
 *  更新cell的sendType
 *
 *  @param sendType 发送类型
 */
- (void)updateCellSendStatus:(MQChatMessageSendStatus)sendStatus;

/**
 *  更新cell的messageId
 *
 *  @param messageId 消息id
 */
- (void)updateCellMessageId:(NSString *)messageId;

/**
 *  更新cell的messageDate
 *
 *  @param messageDate 消息时间
 */
- (void)updateCellMessageDate:(NSDate *)messageDate;

@end

/**
 * MQCellModelDataLoadDelegate协议定义了cellModel中的委托方法，需要在ViewModel进行实现；
 */
@protocol MQCellModelDelegate <NSObject>

/**
 * 该委托定义了cell中有数据更新，通知tableView可以进行cell的刷新了；
 * @param messageId 该cell中的消息id
 */
- (void)didUpdateCellDataWithMessageId:(NSString *)messageId;

@end
