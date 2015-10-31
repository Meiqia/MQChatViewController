//
//  MQBaseMessage.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQBaseMessage.h"

@implementation MQBaseMessage

- (instancetype)init {
    if (self = [super init]) {
        self.messageId = [[NSUUID UUID] UUIDString];
        self.messageFromType = MQMessageOutgoing;
        self.messageDate = [NSDate date];
        self.userName = @"";
        self.userAvatarPath = @"";
    }
    return self;
}

@end
