//
//  MQMessageDateCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQMessageDateCellModel.h"
#import "MQChatBaseCell.h"
#import "MQMessageDateCell.h"
#import "MQDateFormatterUtil.h"
#import "MQStringSizeUtil.h"


@interface MQMessageDateCellModel()
/**
 * @brief cell的宽度
 */
@property (nonatomic, readwrite, assign) CGFloat cellWidth;

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief 消息的中文时间
 */
@property (nonatomic, readwrite, copy) NSString *dateString;

/**
 * @brief 消息气泡button的frame
 */
@property (nonatomic, readwrite, assign) CGRect dateLabelFrame;

@end

@implementation MQMessageDateCellModel

#pragma initialize
/**
 *  根据时间来生成cell model
 */
- (MQMessageDateCellModel *)initCellModelWithDate:(NSDate *)date cellWidth:(CGFloat)cellWidth{
    if (self = [super init]) {
        self.date = date;
        self.dateString = [[MQDateFormatterUtil sharedFormatter] meiqiaStyleDateForDate:date];
        //时间文字size
        CGFloat dateLabelWidth = cellWidth - kMQChatMessageDateLabelToEdgeSpacing * 2;
        CGFloat dateLabelHeight = [MQStringSizeUtil getHeightForText:self.dateString withFont:[UIFont systemFontOfSize:kMQChatMessageDateLabelFontSize] andWidth:dateLabelWidth];
        self.dateLabelFrame = CGRectMake(cellWidth/2-dateLabelWidth/2, kMQChatMessageDateCellHeight/2-dateLabelHeight/2+kMQChatMessageDateLabelVerticalOffset, dateLabelWidth, dateLabelHeight);
        
        self.cellHeight = kMQChatMessageDateCellHeight;
    }
    return self;
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight > 0 ? self.cellHeight : 0;
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQMessageDateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (NSDate *)getCellDate {
    return self.date;
}

- (BOOL)isServiceRelatedCell {
    return false;
}

- (NSString *)getCellMessageId {
    return @"";
}

- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth {
    self.cellWidth = cellWidth;
    self.dateLabelFrame = CGRectMake(cellWidth/2-self.dateLabelFrame.size.width/2, kMQChatMessageDateCellHeight/2-self.dateLabelFrame.size.height/2+kMQChatMessageDateLabelVerticalOffset, self.dateLabelFrame.size.width, self.dateLabelFrame.size.height);
}


@end
