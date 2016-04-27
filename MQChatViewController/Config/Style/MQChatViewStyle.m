//
//  MQChatViewStyle.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/29.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQChatViewStyle.h"
#import "MQAssetUtil.h"
#import "MQChatViewStyleBlue.h"
#import "MQChatViewStyleGreen.h"
#import "MQChatViewStyleDark.h"

@interface MQChatViewStyle()

@property (nonatomic, assign) BOOL didSetStatusBarStyle;

@end

@implementation MQChatViewStyle

+ (instancetype)createWithStyle:(MQChatViewStyleType)type {
    switch (type) {
        case MQChatViewStyleTypeBlue:
            return [MQChatViewStyleBlue new];
        case MQChatViewStyleTypeGreen:
            return [MQChatViewStyleGreen new];
        case MQChatViewStyleTypeDark:
            return [MQChatViewStyleDark new];
        default:
            return [MQChatViewStyle new];
    }
}

+ (instancetype)defaultStyle {
    return [self createWithStyle:(MQChatViewStyleTypeDefault)];
}

+ (instancetype)blueStyle {
    return [self createWithStyle:(MQChatViewStyleTypeBlue)];
}

+ (instancetype)darkStyle {
    return [self createWithStyle:(MQChatViewStyleTypeDark)];
}

+ (instancetype)greenStyle {
    return [self createWithStyle:(MQChatViewStyleTypeGreen)];
}

- (instancetype)init {
    if (self = [super init]) {
        
        self.enableRoundAvatar       = false;
        self.enableIncomingAvatar    = true;
        self.enableOutgoingAvatar    = true;

        self.backgroundColor = [UIColor whiteColor];
        self.incomingMsgTextColor   = [UIColor darkTextColor];
        self.outgoingMsgTextColor   = [UIColor darkTextColor];
        self.eventTextColor         = [UIColor grayColor];
        self.pullRefreshColor       = nil;//[UIColor colorWithRed:104.0/255.0 green:192.0/255.0 blue:160.0/255.0 alpha:1.0];
        self.redirectAgentNameColor = [UIColor blueColor];
        self.navBarColor            = nil;//[UIColor colorWithHexString:MQBlueColor];
        self.navBarTintColor        = nil;//[UIColor whiteColor];
        self.incomingBubbleColor    = nil;//[UIColor colorWithHexString:MQSilverColor];
        self.outgoingBubbleColor    = nil;//[UIColor colorWithHexString:MQBlueColor];
        self.navTitleColor          = nil;//[UIColor whiteColor];
        
        self.photoSenderImage               = [MQAssetUtil messageCameraInputImage];
        self.photoSenderHighlightedImage    = nil;
        self.keyboardSenderImage            = [MQAssetUtil messageTextInputImage];
        self.keyboardSenderHighlightedImage = nil;
        self.voiceSenderImage               = [MQAssetUtil messageVoiceInputImage];
        self.voiceSenderHighlightedImage    = nil;
        self.resignKeyboardImage            = [MQAssetUtil messageResignKeyboardImage];
        self.resignKeyboardHighlightedImage = nil;
        self.incomingBubbleImage            = [MQAssetUtil bubbleIncomingImage];
        self.outgoingBubbleImage            = [MQAssetUtil bubbleOutgoingImage];
        self.messageSendFailureImage        = [MQAssetUtil messageWarningImage];
        self.imageLoadErrorImage            = [MQAssetUtil imageLoadErrorImage];
        
        CGPoint stretchPoint                = CGPointMake(self.incomingBubbleImage.size.width / 4.0f, self.incomingBubbleImage.size.height * 3.0f / 4.0f);
        self.bubbleImageStretchInsets       = UIEdgeInsetsMake(stretchPoint.y, stretchPoint.x, self.incomingBubbleImage.size.height-stretchPoint.y+0.5, stretchPoint.x);
                
        self.statusBarStyle                 = UIStatusBarStyleDefault;
        self.didSetStatusBarStyle = false;
    }
    return self;
}


- (void)setStatusBarStyle:(UIStatusBarStyle)statusBarStyle {
    _statusBarStyle = statusBarStyle;
    self.didSetStatusBarStyle = YES;
}

@end
