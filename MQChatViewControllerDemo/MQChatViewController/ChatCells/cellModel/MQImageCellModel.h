//
//  MQImageCellModel.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"

/**
 * MQImageCellModel定义了图片消息的基本类型数据，包括产生cell的内部所有view的显示数据，cell内部元素的frame等
 * @warning MQImageCellModel必须满足MQCellModelProtocol协议
 */
@interface MQImageCellModel : NSObject <MQCellModelProtocol>

/**
 * @brief 图片path
 */
@property (nonatomic, readonly, copy) NSString *imagePath;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readonly, copy) NSString *messageDate;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readonly, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片名字 (如果在头像path不存在的情况下，才使用这个属性)
 */
@property (nonatomic, readonly, copy) NSString *avatarLocolImageName;

/**
 * @brief 聊天气泡的image（该气泡image已经进行了resize）
 */
@property (nonatomic, readonly, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡的frame
 */
@property (nonatomic, readonly, assign) CGRect bubbleImageFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readonly, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readonly, assign) CGRect indicatorFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readonly, assign) MQChatCellFromType cellFromType;

/**
 * @brief 消息的发送状态
 */
@property (nonatomic, readonly, assign) MQChatCellSendType sendType;


/**
 *  根据MQMessage内容来生成cell model
 */
- (MQImageCellModel *)initCellModelWithMessage:(MQMessage *)message;


@end
