//
//  MQChatBaseCell.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatBaseCell.h"
#import "MQChatFileUtil.h"
#import "MQChatViewConfig.h"

@implementation MQChatBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.incomingBubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
        self.outgoingBubbleImage = [MQChatViewConfig sharedConfig].outgoingBubbleImage;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    return self;
}

- (void)setCellFrame:(CGRect)cellFrame {
    self.contentView.frame = cellFrame;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    NSAssert(NO, @"MQChatBaseCell的子类没有实现updateCellWithCellModel的协议方法");
}

@end
