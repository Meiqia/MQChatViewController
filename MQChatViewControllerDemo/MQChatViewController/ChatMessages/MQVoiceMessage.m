//
//  MQVoiceMessage.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQVoiceMessage.h"

@implementation MQVoiceMessage

- (instancetype)init{
    if (self = [super init]) {
        self.voicePath = @"";
    }
    return self;
}

- (instancetype)initWithVoicePath:(NSString *)voicePath {
    self = [self init];
    self.voicePath = voicePath;
    return self;
}

- (instancetype)initWithVoiceData:(NSData *)voiceDate {
    self = [self init];
    self.voiceData = voiceDate;
    return self;
}

@end
