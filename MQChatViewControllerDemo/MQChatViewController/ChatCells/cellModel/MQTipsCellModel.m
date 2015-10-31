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
static CGFloat const kMQMessageTipsLabelToLineSpacing = 8.0;
static CGFloat const kMQMessageTipsLabelHeight = 0.5;
static CGFloat const kMQMessageTipsCellHeight = 54.0;
static CGFloat const kMQMessageTipsFontSize = 14.0;
static CGFloat const kMQMessageTipsLineHeight = 0.5;

@interface MQTipsCellModel()
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
        self.topLineFrame = CGRectMake(cellWidth/2-lineWidth/2, 0, lineWidth, kMQMessageTipsLineHeight);
        
        //下线条的frame
        self.bottomLineFrame = CGRectMake(self.topLineFrame.origin.x, kMQMessageTipsCellHeight-1-kMQMessageTipsLineHeight, lineWidth, kMQMessageTipsLineHeight);
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
    return @"MQTipsCell";
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

@end
