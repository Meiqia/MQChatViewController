//
//  MQMessage.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/23.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQMessage.h"

@implementation MQMessage

-(id)init
{
    if (self = [super init]) {
        self.messageId = [NSString stringWithFormat:@"%i",(arc4random() % 999999) + 100000];
        self.content = @"";
        self.action = MQMessageActionMessage;
        self.contentType = MQMessageContentTypeText;
        self.agentId = @"";
        self.createdOn = [NSDate new];
        self.fromType = MQMessageFromTypeClient;
        self.type = MQMessageTypeMessage;
        self.sendStatus = MQMessageSendStatusSending;
    }
    return self;
}


@end
