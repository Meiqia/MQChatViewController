//
//  MQVoiceCellModel.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"
#import "MQVoiceMessage.h"

/**
 * MQVoiceCellModel定义了语音消息的基本类型数据，包括产生cell的内部所有view的显示数据，cell内部元素的frame等
 * @warning MQVoiceCellModel必须满足MQCellModelProtocol协议
 */
@interface MQVoiceCellModel : NSObject <MQCellModelProtocol>

/**
 * @brief cell中消息的id
 */
@property (nonatomic, readonly, strong) NSString *messageId;

/**
 * @brief 用户名字，暂时没用
 */
@property (nonatomic, readonly, copy) NSString *userName;

/**
 * @brief 该cellModel的委托对象
 */
@property (nonatomic, weak) id<MQCellModelDelegate> delegate;

/**
 * @brief cell的高度
 */
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/**
 * @brief 语音data
 */
@property (nonatomic, readonly, copy) NSData *voiceData;

/**
 * @brief 语音的时长
 */
@property (nonatomic, readonly, assign) NSInteger voiceDuration;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readonly, copy) NSDate *date;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readonly, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片
 */
@property (nonatomic, readonly, copy) UIImage *avatarImage;

/**
 * @brief 聊天气泡的image
 */
@property (nonatomic, readonly, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡button的frame
 */
@property (nonatomic, readonly, assign) CGRect bubbleImageFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readonly, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readonly, assign) CGRect sendingIndicatorFrame;

/**
 * @brief 读取语音数据的指示器的frame
 */
@property (nonatomic, readonly, assign) CGRect loadingIndicatorFrame;

/**
 * @brief 语音市场的frame
 */
@property (nonatomic, readonly, assign) CGRect durationLabelFrame;

/**
 * @brief 语音图片的frame
 */
@property (nonatomic, readonly, assign) CGRect voiceImageFrame;

/**
 * @brief 发送出错图片的frame
 */
@property (nonatomic, readonly, assign) CGRect sendFailureFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readonly, assign) MQChatCellFromType cellFromType;

/**
 * @brief 消息的发送状态
 */
@property (nonatomic, assign) MQChatMessageSendStatus sendStatus;

/**
 * @brief 该语音消息是否已经播放过了
 */
@property (nonatomic, assign) BOOL isPlayed;

/**
 * @brief 语音未播放的小红点view的frame
 */
@property (nonatomic, readonly, assign) CGRect notPlayViewFrame;

/**
 * @brief 语音是否加载成功
 */
@property (nonatomic, readonly, assign) BOOL isLoadVoiceSuccess;

/**
 *  根据MQMessage内容来生成cell model
 */
- (MQVoiceCellModel *)initCellModelWithMessage:(MQVoiceMessage *)message
                                     cellWidth:(CGFloat)cellWidth
                                      delegate:(id<MQCellModelDelegate>)delegator;

- (void)setVoiceHasPlayed;


@end
