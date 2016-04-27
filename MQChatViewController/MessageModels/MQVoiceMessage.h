//
//  MQVoiceMessage.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQBaseMessage.h"
#import <UIKit/UIKit.h>

@interface MQVoiceMessage : MQBaseMessage

/** 消息voice path */
@property (nonatomic, copy) NSString *voicePath;

/** 消息voice */
@property (nonatomic, strong) NSData *voiceData;

/** 该语音是否已经播放了 */
@property (nonatomic, assign) BOOL isPlayed;

- (instancetype)initWithVoicePath:(NSString *)voicePath;

- (instancetype)initWithVoiceData:(NSData *)voiceDate;

+ (void)setVoiceHasPlayedToDBWithMessageId:(NSString *)messageId;

- (void)handleAccessoryData:(NSDictionary *)accessoryData;

@end
