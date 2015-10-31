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
#import "MQChatDateUtil.h"
#import "MQStringSizeUtil.h"


@interface MQMessageDateCellModel()
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
        self.dateString = [MQChatDateUtil convertToChineseDateWithDate:date];
        //时间文字size
        CGFloat dateLabelWidth = cellWidth - kMQChatMessageDateLabelToEdgeSpacing * 2;
        CGFloat dateLabelHeight = [MQStringSizeUtil getHeightForText:self.dateString withFont:[UIFont systemFontOfSize:kMQChatMessageDateLabelFontSize] andWidth:dateLabelWidth];
        self.dateLabelFrame = CGRectMake(cellWidth/2-dateLabelWidth/2, kMQChatMessageDateCellHeight/2-dateLabelHeight/2, dateLabelWidth, dateLabelHeight);
        
        self.cellHeight = kMQChatMessageDateCellHeight;
    }
    return self;
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight;
}

/**
 *  @return cell重用的名字.
 */
- (NSString *)getCellReuseIdentifier {
    return @"MQMessageDateCell";
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

@end
