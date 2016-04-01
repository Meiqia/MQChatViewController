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
#import "MQChatViewConfig.h"

//上下两条线与cell垂直边沿的间距
static CGFloat const kMQMessageTipsLabelLineVerticalMargin = 2.0;
static CGFloat const kMQMessageTipsCellVerticalSpacing = 24.0;
static CGFloat const kMQMessageTipsCellHorizontalSpacing = 24.0;
static CGFloat const kMQMessageTipsLineHeight = 0.5;
CGFloat const kMQMessageTipsFontSize = 13.0;

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
 *  是否显示上下两个线条
 */
@property (nonatomic, readwrite, assign) BOOL enableLinesDisplay;

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
- (MQTipsCellModel *)initCellModelWithTips:(NSString *)tips
                                 cellWidth:(CGFloat)cellWidth
                        enableLinesDisplay:(BOOL)enableLinesDisplay
{
    if (self = [super init]) {
        self.date = [NSDate date];
        self.tipText = tips;
        self.enableLinesDisplay = enableLinesDisplay;
        
        //tip frame
        CGFloat tipCellHoriSpacing = enableLinesDisplay ? kMQMessageTipsCellHorizontalSpacing : 8.0;
        CGFloat tipCellVerSpacing = enableLinesDisplay ? kMQMessageTipsCellVerticalSpacing : 8.0;
        CGFloat tipsWidth = cellWidth - tipCellHoriSpacing * 2;
        CGFloat tipsHeight = [MQStringSizeUtil getHeightForText:tips withFont:[UIFont systemFontOfSize:kMQMessageTipsFontSize] andWidth:tipsWidth];
        CGRect tipLabelFrame = CGRectMake(tipCellHoriSpacing, tipCellVerSpacing, tipsWidth, tipsHeight);
        self.tipLabelFrame = tipLabelFrame;
        
        self.cellHeight = tipCellVerSpacing * 2 + tipsHeight;
        
        //上线条的frame
        CGFloat lineWidth = cellWidth;
        self.topLineFrame = CGRectMake(cellWidth/2-lineWidth/2, kMQMessageTipsLabelLineVerticalMargin, lineWidth, kMQMessageTipsLineHeight);
        
        //下线条的frame
        self.bottomLineFrame = CGRectMake(self.topLineFrame.origin.x, self.cellHeight - kMQMessageTipsLabelLineVerticalMargin - kMQMessageTipsLineHeight, lineWidth, kMQMessageTipsLineHeight);
        
        //tip的文字额外属性
        if (tips.length > 4) {
            if ([[tips substringToIndex:3] isEqualToString:@"接下来"]) {
                NSRange firstRange = [tips rangeOfString:@" "];
                NSString *subTips = [tips substringFromIndex:firstRange.location+1];
                NSRange lastRange = [subTips rangeOfString:@" "];
                NSRange agentNameRange = NSMakeRange(firstRange.location+1, lastRange.location);
                self.tipExtraAttributesRange = agentNameRange;
                self.tipExtraAttributes = @{
                                            NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:13],
                                            NSForegroundColorAttributeName : [MQChatViewConfig sharedConfig].redirectAgentNameColor
                                            };
            }
        }
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
    //tip frame
    CGFloat tipsWidth = cellWidth - kMQMessageTipsCellHorizontalSpacing * 2;
    self.tipLabelFrame = CGRectMake(kMQMessageTipsCellHorizontalSpacing, kMQMessageTipsCellVerticalSpacing, tipsWidth, self.tipLabelFrame.size.height);
    
    //上线条的frame
    CGFloat lineWidth = cellWidth;
    self.topLineFrame = CGRectMake(cellWidth/2-lineWidth/2, kMQMessageTipsLabelLineVerticalMargin, lineWidth, kMQMessageTipsLineHeight);
    
    //下线条的frame
    self.bottomLineFrame = CGRectMake(self.topLineFrame.origin.x, self.cellHeight - kMQMessageTipsLabelLineVerticalMargin - kMQMessageTipsLineHeight, lineWidth, kMQMessageTipsLineHeight);
}


@end
