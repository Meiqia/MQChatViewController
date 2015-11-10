//
//  MQEventMessage.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/9.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQEventMessage.h"

@implementation MQEventMessage

- (instancetype)initWithEventContent:(NSString *)eventContent {
    if (self = [super init]) {
        self.content = eventContent;
    }
    return self;
}

@end
