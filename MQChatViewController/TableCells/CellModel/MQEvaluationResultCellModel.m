//
//  MQEvaluationResultCellModel.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 16/3/1.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQEvaluationResultCellModel.h"
#import "MQEvaluationResultCell.h"
#import "MQStringSizeUtil.h"
#import "MQImageUtil.h"
#import "MQAssetUtil.h"

static CGFloat const kMQEvaluationCellLabelVerticalMargin = 6.0;
static CGFloat const kMQEvaluationCellLabelHorizontalMargin = 8.0;
static CGFloat const kMQEvaluationCellLabelHorizontalSpacing = 8.0;
static CGFloat const kMQEvaluationCellVerticalSpacing = 12.0;
static CGFloat const kMQEvaluationCommentHorizontalSpacing = 36.0;
CGFloat const kMQEvaluationCellFontSize = 14.0;

@interface MQEvaluationResultCellModel()

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 评价的等级
 */
@property (nonatomic, readwrite, assign) MQEvaluationType evaluationType;

/**
 * @brief 评价的评论
 */
@property (nonatomic, readwrite, copy) NSString *comment;

/**
 * @brief 评价的等级
 */
@property (nonatomic, readwrite, copy) NSString *levelText;

/**
 * @brief 等级图片的 frame
 */
@property (nonatomic, readwrite, assign) CGRect evaluationImageFrame;

/**
 * @brief 评价 level label 的 frame
 */
@property (nonatomic, readwrite, assign) CGRect evaluationTextLabelFrame;

/**
 * @brief 评价等级 label 的 frame
 */
@property (nonatomic, readwrite, assign) CGRect evaluationLabelFrame;

/**
 * @brief 评价评论的 frame
 */
@property (nonatomic, readwrite, assign) CGRect commentLabelFrame;

/**
 * @brief 评价的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief 评价 label 的 color
 */
@property (nonatomic, readwrite, copy) UIColor *evaluationLabelColor;

@end

@implementation MQEvaluationResultCellModel

#pragma initialize
/**
 *  根据tips内容来生成cell model
 */
- (MQEvaluationResultCellModel *)initCellModelWithEvaluation:(MQEvaluationType)evaluationType
                                                     comment:(NSString *)comment
                                                   cellWidth:(CGFloat)cellWidth
{
    if (self = [super init]) {
        self.date = [NSDate date];
        self.comment = comment;
        self.evaluationType = evaluationType;
        switch (evaluationType) {
            case MQEvaluationTypeNegative:
                self.evaluationLabelColor = [UIColor colorWithRed:255.0/255.0 green:92.0/255.0 blue:94.0/255.0 alpha:1];
                self.levelText = @"差评";
                break;
            case MQEvaluationTypeModerate:
                self.evaluationLabelColor = [UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:82.0/255.0 alpha:1];
                self.levelText = @"中评";
                break;
            case MQEvaluationTypePositive:
                self.evaluationLabelColor = [UIColor colorWithRed:0.0/255.0 green:206.0/255.0 blue:125.0/255.0 alpha:1];
                self.levelText = @"好评";
                break;
            default:
                self.evaluationLabelColor = [UIColor colorWithRed:0.0/255.0 green:206.0/255.0 blue:125.0/255.0 alpha:1];
                self.levelText = @"好评";
                break;
        }
        
        //评价的 label frame
        CGFloat levelTextWidth = [MQStringSizeUtil getWidthForText:self.levelText withFont:[UIFont systemFontOfSize:kMQEvaluationCellFontSize] andHeight:200];
        CGFloat levelTextHeight = [MQStringSizeUtil getHeightForText:self.levelText withFont:[UIFont systemFontOfSize:kMQEvaluationCellFontSize] andWidth:levelTextWidth];
        UIImage *evaluationImage = [MQAssetUtil getEvaluationImageWithLevel:0];
        CGFloat evaluationLabelWidth = kMQEvaluationCellLabelHorizontalMargin * 2 + evaluationImage.size.width + levelTextWidth + kMQEvaluationCellLabelHorizontalSpacing;
        CGFloat evaluationLabelHeight = kMQEvaluationCellLabelVerticalMargin * 2 + evaluationImage.size.height;
        self.evaluationLabelFrame = CGRectMake(cellWidth/2 - evaluationLabelWidth/2, kMQEvaluationCellVerticalSpacing, evaluationLabelWidth, evaluationLabelHeight);
        
        self.evaluationImageFrame = CGRectMake(kMQEvaluationCellLabelHorizontalMargin, kMQEvaluationCellLabelVerticalMargin, evaluationImage.size.width, evaluationImage.size.height);
        self.evaluationTextLabelFrame = CGRectMake(self.evaluationImageFrame.origin.x + self.evaluationImageFrame.size.width + kMQEvaluationCellLabelHorizontalSpacing, self.evaluationLabelFrame.size.height/2 - levelTextHeight/2, levelTextWidth, levelTextHeight);
        
        //评价的评论 label frame
        CGFloat commentTextWidth = cellWidth - kMQEvaluationCommentHorizontalSpacing * 2;
        CGFloat commentTextHeight = [MQStringSizeUtil getHeightForText:comment withFont:[UIFont systemFontOfSize:kMQEvaluationCellFontSize] andWidth:commentTextWidth];
        self.commentLabelFrame = comment.length > 0 ? CGRectMake(kMQEvaluationCommentHorizontalSpacing, self.evaluationLabelFrame.origin.y + self.evaluationLabelFrame.size.height + kMQEvaluationCellVerticalSpacing, commentTextWidth, commentTextHeight) : CGRectMake(0, 0, 0, 0);
        
        if (self.commentLabelFrame.size.height > 0) {
            self.cellHeight = self.commentLabelFrame.origin.y + self.commentLabelFrame.size.height + kMQEvaluationCellVerticalSpacing;
        } else {
            self.cellHeight = self.evaluationLabelFrame.origin.y + self.evaluationLabelFrame.size.height + kMQEvaluationCellVerticalSpacing;
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
    return [[MQEvaluationResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
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
    //评价的 label frame
    CGFloat levelTextWidth = [MQStringSizeUtil getWidthForText:self.levelText withFont:[UIFont systemFontOfSize:kMQEvaluationCellFontSize] andHeight:200];
    CGFloat levelTextHeight = [MQStringSizeUtil getHeightForText:self.levelText withFont:[UIFont systemFontOfSize:kMQEvaluationCellFontSize] andWidth:levelTextWidth];
    UIImage *evaluationImage = [MQAssetUtil getEvaluationImageWithLevel:0];
    CGFloat evaluationLabelWidth = kMQEvaluationCellLabelHorizontalMargin * 2 + evaluationImage.size.width + levelTextWidth + kMQEvaluationCellLabelHorizontalSpacing;
    CGFloat evaluationLabelHeight = kMQEvaluationCellLabelVerticalMargin * 2 + evaluationImage.size.height;
    self.evaluationLabelFrame = CGRectMake(cellWidth/2 - evaluationLabelWidth/2, kMQEvaluationCellVerticalSpacing, evaluationLabelWidth, evaluationLabelHeight);
    
    self.evaluationImageFrame = CGRectMake(kMQEvaluationCellLabelHorizontalMargin, kMQEvaluationCellLabelVerticalMargin, evaluationImage.size.width, evaluationImage.size.height);
    self.evaluationTextLabelFrame = CGRectMake(self.evaluationImageFrame.origin.x + self.evaluationImageFrame.size.width + kMQEvaluationCellLabelHorizontalSpacing, self.evaluationLabelFrame.size.height/2 - levelTextHeight/2, levelTextWidth, levelTextHeight);
    
    //评价的评论 label frame
    CGFloat commentTextWidth = cellWidth - kMQEvaluationCommentHorizontalSpacing * 2;
    CGFloat commentTextHeight = [MQStringSizeUtil getHeightForText:self.comment withFont:[UIFont systemFontOfSize:kMQEvaluationCellFontSize] andWidth:commentTextWidth];
    self.commentLabelFrame = self.comment.length > 0 ? CGRectMake(kMQEvaluationCommentHorizontalSpacing, self.evaluationLabelFrame.origin.y + self.evaluationLabelFrame.size.height + kMQEvaluationCellVerticalSpacing, commentTextWidth, commentTextHeight) : CGRectMake(0, 0, 0, 0);
    
    if (self.commentLabelFrame.size.height > 0) {
        self.cellHeight = self.commentLabelFrame.origin.y + self.commentLabelFrame.size.height + kMQEvaluationCellVerticalSpacing;
    } else {
        self.cellHeight = self.evaluationLabelFrame.origin.y + self.evaluationLabelFrame.size.height + kMQEvaluationCellVerticalSpacing;
    }
}



@end
