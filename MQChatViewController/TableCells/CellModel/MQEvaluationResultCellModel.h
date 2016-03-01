//
//  MQEvaluationResultCellModel.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 16/3/1.
//  Copyright © 2016年 ijinmao. All rights reserved.
//
/**
 * MQEvaluationCellModel 定义了评价 cell 的基本类型数据，包括产生cell的内部所有view的显示数据，cell内部元素的frame等
 * @warning MQEvaluationCellModel 必须满足 MQCellModelProtocol 协议
 */
#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"

extern CGFloat const kMQEvaluationCellFontSize;

@interface MQEvaluationResultCellModel : NSObject <MQCellModelProtocol>

/**
 *  评价的等级
 */
typedef NS_ENUM(NSUInteger, MQEvaluationType) {
    MQEvaluationTypeNegative    = 0,            //差评
    MQEvaluationTypeModerate    = 1,            //中评
    MQEvaluationTypePositive    = 2             //好评
};

/**
 * @brief cell的高度
 */
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/**
 * @brief 评价的等级
 */
@property (nonatomic, readonly, assign) MQEvaluationType evaluationType;

/**
 * @brief 评价的评论
 */
@property (nonatomic, readonly, copy) NSString *comment;

/**
 * @brief 评价的等级
 */
@property (nonatomic, readonly, copy) NSString *levelText;

/**
 * @brief 等级图片的 frame
 */
@property (nonatomic, readonly, assign) CGRect evaluationImageFrame;

/**
 * @brief 评价 level label 的 frame
 */
@property (nonatomic, readonly, assign) CGRect evaluationTextLabelFrame;

/**
 * @brief 评价等级 label 的 frame
 */
@property (nonatomic, readonly, assign) CGRect evaluationLabelFrame;

/**
 * @brief 评价评论的 frame
 */
@property (nonatomic, readonly, assign) CGRect commentLabelFrame;

/**
 * @brief 评价的时间
 */
@property (nonatomic, readonly, copy) NSDate *date;

/**
 * @brief 评价 label 的 color
 */
@property (nonatomic, readonly, copy) UIColor *evaluationLabelColor;

- (MQEvaluationResultCellModel *)initCellModelWithEvaluation:(MQEvaluationType)evaluationType
                                                     comment:(NSString *)comment
                                                   cellWidth:(CGFloat)cellWidth;


@end
