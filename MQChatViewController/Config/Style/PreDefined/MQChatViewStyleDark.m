//
//  MQChatViewStyleDark.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/30.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQChatViewStyleDark.h"

@implementation MQChatViewStyleDark

- (instancetype)init {
    if (self = [super init]) {
        self.navBarColor =  [UIColor colorWithHexString:midnightBlue];
        self.navTitleColor = [UIColor colorWithHexString:gallery];
        self.navBarTintColor = [UIColor colorWithHexString:clouds];
        
        self.incomingBubbleColor = [UIColor colorWithHexString:clouds];
        self.incomingMsgTextColor = [UIColor colorWithHexString:wetAsphalt];
        
        self.outgoingBubbleColor = [UIColor colorWithHexString:silver];
        self.outgoingMsgTextColor = [UIColor colorWithHexString:wetAsphalt];
        
        self.pullRefreshColor = [UIColor colorWithHexString:midnightBlue];
        
        self.backgroundColor = [UIColor colorWithHexString:midnightBlue];
        
        self.statusBarStyle = UIStatusBarStyleLightContent;
    }
    return self;
}

@end
