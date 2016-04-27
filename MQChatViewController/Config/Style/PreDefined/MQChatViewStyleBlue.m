//
//  MQChatViewStyleBlue.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/30.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQChatViewStyleBlue.h"

@implementation MQChatViewStyleBlue

- (instancetype)init {
    if (self = [super init]) {
        self.navBarColor =  [UIColor colorWithHexString:belizeHole];
        self.navTitleColor = [UIColor colorWithHexString:gallery];
        self.navBarTintColor = [UIColor colorWithHexString:clouds];
        
        self.incomingBubbleColor = [UIColor colorWithHexString:dodgerBlue];
        self.incomingMsgTextColor = [UIColor colorWithHexString:gallery];
        
        self.outgoingBubbleColor = [UIColor colorWithHexString:gallery];
        self.outgoingMsgTextColor = [UIColor colorWithHexString:dodgerBlue];
        
        self.pullRefreshColor = [UIColor colorWithHexString:belizeHole];
        
        self.backgroundColor = [UIColor whiteColor];
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}

@end
