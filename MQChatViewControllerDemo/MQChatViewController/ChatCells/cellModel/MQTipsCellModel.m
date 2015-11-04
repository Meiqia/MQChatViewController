//
//  MQTipsCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTipsCellModel.h"
#import "MQChatBaseCell.h"
#import "MQTipsCell.h"
#import "MQStringSizeUtil.h"

//上下两条线与cell垂直边沿的间距
static CGFloat const kMQMessageTipsLabelLineVerticalMargin = 2.0;
//上下两条线超过文字label的距离
static CGFloat const kMQMessageTipsLabelToLineSpacing = 48.0;
static CGFloat const kMQMessageTipsCellHeight = 54.0;
static CGFloat const kMQMessageTipsFontSize = 15.0;
static CGFloat const kMQMessageTipsLineHeight = 0.5;

@interface MQTipsCellModel()
/**
 * @brief cell的宽度
 */
@property (nonatomic, readwrite, assign) CGFloat cellWidth;

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 提示文字
 */
@property (nonatomic, readwrite, copy) NSString *tipText;

/**
 * @brief 提示label的frame
 */
@property (nonatomic, readwrite, assign) CGRect tipLabelFrame;

/**
 * @brief 上线条的frame
 */
@property (nonatomic, readwrite, assign) CGRect topLineFrame;

/**
 * @brief 下线条的frame
 */
@property (nonatomic, readwrite, assign) CGRect bottomLineFrame;

/**
 * @brief 提示的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

@end

@implementation MQTipsCellModel

#pragma initialize
/**
 *  根据tips内容来生成cell model
 */
- (MQTipsCellModel *)initCellModelWithTips:(NSString *)tips cellWidth:(CGFloat)cellWidth {
    if (self = [super init]) {
        self.date = [NSDate date];
        self.tipText = tips;
        
        //tip frame
        CGFloat maxTipWidth = ceil(cellWidth * 2 / 3);
        CGFloat tipsHeight = [MQStringSizeUtil getHeightForText:tips withFont:[UIFont systemFontOfSize:kMQMessageTipsFontSize] andWidth:maxTipWidth];
        CGFloat tipsWidth = [MQStringSizeUtil getWidthForText:tips withFont:[UIFont systemFontOfSize:kMQMessageTipsFontSize] andHeight:tipsHeight];
        self.tipLabelFrame = CGRectMake(cellWidth/2-tipsWidth/2, kMQMessageTipsCellHeight/2-tipsHeight/2, tipsWidth, tipsHeight);
        
        //上线条的frame
        CGFloat lineWidth = tipsWidth + kMQMessageTipsLabelToLineSpacing * 2;
        self.topLineFrame = CGRectMake(cellWidth/2-lineWidth/2, kMQMessageTipsLabelLineVerticalMargin, lineWidth, kMQMessageTipsLineHeight);
        
        //下线条的frame
        self.bottomLineFrame = CGRectMake(self.topLineFrame.origin.x, kMQMessageTipsCellHeight-kMQMessageTipsLabelLineVerticalMargin-kMQMessageTipsLineHeight, lineWidth, kMQMessageTipsLineHeight);
        
        self.cellHeight = self.bottomLineFrame.origin.y + self.bottomLineFrame.size.height;
    }
    return self;
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight;
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQTipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
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
    self.tipLabelFrame = CGRectMake(cellWidth/2-self.tipLabelFrame.size.width/2, kMQMessageTipsCellHeight/2-self.tipLabelFrame.size.height/2, self.tipLabelFrame.size.width, self.tipLabelFrame.size.height);
    self.topLineFrame = CGRectMake(cellWidth/2-self.topLineFrame.size.width/2, kMQMessageTipsLabelLineVerticalMargin, self.topLineFrame.size.width, kMQMessageTipsLineHeight);
    self.bottomLineFrame = CGRectMake(self.topLineFrame.origin.x, kMQMessageTipsCellHeight-kMQMessageTipsLabelLineVerticalMargin-kMQMessageTipsLineHeight, self.topLineFrame.size.width, kMQMessageTipsLineHeight);
}


@end
