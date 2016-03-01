//
//  MQEvaluationResultCell.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 16/3/1.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQEvaluationResultCell.h"
#import "MQEvaluationResultCellModel.h"
#import "MQAssetUtil.h"
#import "MQImageUtil.h"

@implementation MQEvaluationResultCell {
    UILabel *evaluationLabel;
    UILabel *commentLabel;
    UIImageView *evaluationImageView;
    UILabel *evaluationTextLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化
        evaluationLabel = [[UILabel alloc] init];
        evaluationTextLabel = [[UILabel alloc] init];
        evaluationTextLabel.font = [UIFont systemFontOfSize:kMQEvaluationCellFontSize];
        evaluationTextLabel.textColor = [UIColor whiteColor];
        evaluationImageView = [[UIImageView alloc] initWithImage:[MQAssetUtil getEvaluationImageWithLevel:0]];
        commentLabel = [[UILabel alloc] init];
        commentLabel.font = [UIFont systemFontOfSize:kMQEvaluationCellFontSize];
        commentLabel.textColor = [UIColor lightGrayColor];
        commentLabel.textAlignment = NSTextAlignmentCenter;
        commentLabel.numberOfLines = 0;
        [evaluationLabel addSubview:evaluationImageView];
        [evaluationLabel addSubview:evaluationTextLabel];
        [self.contentView addSubview:evaluationLabel];
        [self.contentView addSubview:commentLabel];
    }
    return self;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQEvaluationResultCellModel class]]) {
        NSAssert(NO, @"传给MQTipsCell的Model类型不正确");
        return ;
    }
    
    MQEvaluationResultCellModel *cellModel = (MQEvaluationResultCellModel *)model;
    
    evaluationLabel.backgroundColor = cellModel.evaluationLabelColor;
    evaluationLabel.frame = cellModel.evaluationLabelFrame;
    evaluationLabel.layer.cornerRadius = evaluationLabel.frame.size.height / 2;
    evaluationLabel.layer.masksToBounds = true;
    
    evaluationImageView.frame = cellModel.evaluationImageFrame;
    NSInteger level = 2;
    switch (cellModel.evaluationType) {
        case MQEvaluationTypePositive:
            level = 2;
            break;
        case MQEvaluationTypeModerate:
            level = 1;
            break;
        case MQEvaluationTypeNegative:
            level = 0;
            break;
        default:
            break;
    }
    if (cellModel.evaluationImageFrame.size.height > 0) {
        evaluationImageView.image = [MQImageUtil convertImageColorWithImage:[MQAssetUtil getEvaluationImageWithLevel:level] toColor:[UIColor whiteColor]];
        evaluationImageView.hidden = false;
    } else {
        evaluationImageView.hidden = true;
    }
    evaluationTextLabel.frame = cellModel.evaluationTextLabelFrame;
    evaluationTextLabel.text = cellModel.levelText;
    
    commentLabel.frame = cellModel.commentLabelFrame;
    commentLabel.text = cellModel.comment;
}

@end
