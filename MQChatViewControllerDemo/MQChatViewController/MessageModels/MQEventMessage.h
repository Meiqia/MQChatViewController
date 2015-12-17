//
//  MQEventMessage.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/9.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQBaseMessage.h"

typedef enum : NSUInteger {
    MQChatEventTypeInitConversation          = 0,//初始化对话 (init_conv)
    MQChatEventTypeAgentDidCloseConversation = 1,//客服结束对话 (end_conv_agent)
    MQChatEventTypeEndConversationTimeout    = 2,//对话超时，系统自动结束对话 (end_conv_timeout)
    MQChatEventTypeRedirect                  = 3,//顾客被转接 (agent_redirect)
    MQChatEventTypeAgentInputting            = 4 //客服正在输入 (agent_inputting)
} MQChatEventType;

@interface MQEventMessage : MQBaseMessage

/** 事件content */
@property (nonatomic, copy  ) NSString *content;

/** 事件类型 */
@property (nonatomic, assign) MQChatEventType eventType;

/**
 * 初始化message
 */
- (instancetype)initWithEventContent:(NSString *)eventContent
                           eventType:(MQChatEventType)eventType;

@end
