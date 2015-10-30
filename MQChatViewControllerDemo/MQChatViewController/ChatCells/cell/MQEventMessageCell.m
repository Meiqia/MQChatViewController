//
//  MQEventMessageCell.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQEventMessageCell.h"
#import "MQEventCellModel.h"

static CGFloat const kMQMessageEventLabelFontSize = 14.0;

@implementation MQEventMessageCell {
    UILabel *eventLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化事件label
        eventLabel = [[UILabel alloc] init];
        eventLabel.textColor = [UIColor grayColor];
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
    eventLabel.text = cellModel.eventText;
    eventLabel.frame = cellModel.eventLabelFrame;
}

@end
