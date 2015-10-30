//
//  MQBaseMessage.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  message的来源枚举定义
 *  MQMessageIncoming - 收到的消息
 *  MQMessageOutgoing - 发送的消息
 */
typedef NS_ENUM(NSUInteger, MQChatMessageFromType) {
    MQMessageIncoming,
    MQMessageOutgoing
};


@interface MQBaseMessage : NSObject

/** 消息id */
@property (nonatomic, copy) NSString *messageId;

/** 消息的来源类型 */
@property (nonatomic, assign) MQChatMessageFromType messageFromType;

/** 消息时间 */
@property (nonatomic, copy) NSDate *messageDate;

/** 消息发送人姓名 */
@property (nonatomic, copy) NSString *userName;

/** 消息发送人头像Path */
@property (nonatomic, copy) NSString *userAvatarPath;


@end
