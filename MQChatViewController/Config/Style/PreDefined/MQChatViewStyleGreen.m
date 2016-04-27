//
//  MQChatViewStyleGreen.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/30.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQChatViewStyleGreen.h"

@implementation MQChatViewStyleGreen

- (instancetype)init {
    if (self = [super init]) {
        self.navBarColor =  [UIColor colorWithHexString:greenSea];
        self.navTitleColor = [UIColor colorWithHexString:gallery];
        self.navBarTintColor = [UIColor colorWithHexString:clouds];
        
        self.incomingBubbleColor = [UIColor colorWithHexString:turquoise];
        self.incomingMsgTextColor = [UIColor colorWithHexString:gallery];
        
        self.outgoingBubbleColor = [UIColor colorWithHexString:gallery];
        self.outgoingMsgTextColor = [UIColor colorWithHexString:turquoise];
        
        self.pullRefreshColor = [UIColor colorWithHexString:turquoise];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}


@end
