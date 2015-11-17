//
//  MQEventCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQEventCellModel.h"
#import "MQChatBaseCell.h"
#import "MQEventMessageCell.h" 
#import "MQStringSizeUtil.h"

static CGFloat const kMQEventCellTextToEdgeHorizontalSpacing = 32.0;
static CGFloat const kMQEventCellTextToEdgeVerticalSpacing = 16.0;
static CGFloat const kMQEventCellTextFontSize = 14.0;

@interface MQEventCellModel()
/**
 * @brief cell中消息的id
 */
@property (nonatomic, readwrite, strong) NSString *messageId;

/**
 * @brief 事件消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief cell的宽度
 */
@property (nonatomic, readwrite, assign) CGFloat cellWidth;

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 事件文字
 */
@property (nonatomic, readwrite, copy) NSString *eventContent;

/**
 * @brief 消息气泡button的frame
 */
@property (nonatomic, readwrite, assign) CGRect eventLabelFrame;

@end

@implementation MQEventCellModel

- (MQEventCellModel *)initCellModelWithMessage:(MQEventMessage *)message cellWidth:(CGFloat)cellWidth {
    if (self = [super init]) {
        self.messageId = message.messageId;
        self.date = message.date;
        self.eventContent = message.content;
        self.cellWidth = cellWidth;
        CGFloat labelWidth = cellWidth - kMQEventCellTextToEdgeHorizontalSpacing * 2;
        CGFloat labelHeight = [MQStringSizeUtil getHeightForText:message.content withFont:[UIFont systemFontOfSize:kMQEventCellTextFontSize] andWidth:labelWidth];
        self.eventLabelFrame = CGRectMake(kMQEventCellTextToEdgeHorizontalSpacing, kMQEventCellTextToEdgeVerticalSpacing, labelWidth, labelHeight);
        self.cellHeight = self.eventLabelFrame.origin.y + self.eventLabelFrame.size.height + kMQEventCellTextToEdgeVerticalSpacing;
    }
    return self;
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight > 0 ? self.cellHeight : 0;
}

- (NSDate *)getCellDate {
    return self.date;
}

- (NSString *)getCellMessageId {
    return self.messageId;
}

- (void)updateCellMessageId:(NSString *)messageId {
    self.messageId = messageId;
}

- (void)updateCellMessageDate:(NSDate *)messageDate {
    self.date = messageDate;
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQEventMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (BOOL)isServiceRelatedCell {
    return true;
}

- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth {
    self.cellWidth = cellWidth;
    self.eventLabelFrame = CGRectMake(cellWidth/2-self.eventLabelFrame.size.width/2, self.eventLabelFrame.origin.y, self.eventLabelFrame.size.width, self.eventLabelFrame.size.height);
}

@end
