//
//  MQEventMessageCell.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQEventMessageCell.h"
#import "MQEventCellModel.h"
#import "MQChatViewConfig.h"

static CGFloat const kMQMessageEventLabelFontSize = 14.0;

@implementation MQEventMessageCell {
    UILabel *eventLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化事件label
        eventLabel = [[UILabel alloc] init];
        eventLabel.textColor = [MQChatViewConfig sharedConfig].eventTextColor;
        eventLabel.textAlignment = NSTextAlignmentCenter;
        eventLabel.font = [UIFont systemFontOfSize:kMQMessageEventLabelFontSize];
        [self.contentView addSubview:eventLabel];
    }
    return self;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQEventCellModel class]]) {
        NSAssert(NO, @"传给MQEventMessageCell的Model类型不正确");
        return ;
    }
    MQEventCellModel *cellModel = (MQEventCellModel *)model;
    
    //刷新时间label
    eventLabel.text = cellModel.eventContent;
    eventLabel.frame = cellModel.eventLabelFrame;
}

@end
