//
//  MQEventMessage.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/9.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQBaseMessage.h"

@interface MQEventMessage : MQBaseMessage

/** 事件content */
@property (nonatomic, copy) NSString *content;

/**
 * 初始化message
 */
- (instancetype)initWithEventContent:(NSString *)eventContent;

@end
