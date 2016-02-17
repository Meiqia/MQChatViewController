//
//  MQBaseMessage.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  message的来源枚举定义
 *  MQChatMessageIncoming - 收到的消息
 *  MQChatMessageOutgoing - 发送的消息
 */
typedef NS_ENUM(NSUInteger, MQChatMessageFromType) {
    MQChatMessageIncoming,
    MQChatMessageOutgoing
};

/**
 *  message的来源枚举定义
 *  MQChatMessageIncoming - 收到的消息
 *  MQChatMessageOutgoing - 发送的消息
 */
typedef NS_ENUM(NSUInteger, MQChatMessageSendStatus) {
    MQChatMessageSendStatusSuccess,
    MQChatMessageSendStatusSending,
    MQChatMessageSendStatusFailure
};


@interface MQBaseMessage : NSObject

/** 消息id */
@property (nonatomic, copy) NSString *messageId;

/** 消息的来源类型 */
@property (nonatomic, assign) MQChatMessageFromType fromType;

/** 消息时间 */
@property (nonatomic, copy) NSDate *date;

/** 消息发送人姓名 */
@property (nonatomic, copy) NSString *userName;

/** 消息发送人头像Path */
@property (nonatomic, copy) NSString *userAvatarPath;

/** 消息发送人头像image */
@property (nonatomic, strong) UIImage *userAvatarImage;

/** 消息发送的状态 */
@property (nonatomic, assign) MQChatMessageSendStatus sendStatus;



@end
