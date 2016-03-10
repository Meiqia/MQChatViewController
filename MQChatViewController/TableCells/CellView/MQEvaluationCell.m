//
//  MQEvaluationCell.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 16/1/19.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQEvaluationCell.h"
#import "MQAssetUtil.h"

static CGFloat const kMQEvaluationCellVerticalSpacing = 12.0;
static CGFloat const kMQEvaluationCellHorizontalSpacing = 12.0;
static CGFloat const kMQEvaluationCellTextWidth = 80.0;
static CGFloat const kMQEvaluationCellTextHeight = 30.0;

@implementation MQEvaluationCell {
    UIImageView *levelImageView;
    UILabel *levelLabel;
    UIView *bottomLine;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //cell 的配置
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //评价的头像
        levelImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:levelImageView];
        //评价文字
        levelLabel = [[UILabel alloc] init];
        levelLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
        levelLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:levelLabel];
        //画上下两条线
        bottomLine = [[UIView alloc] init];
        bottomLine.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
        [self.contentView addSubview:bottomLine];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    UIImage *defaultImage = [MQAssetUtil getEvaluationImageWithLevel:0];
    levelImageView.frame = CGRectMake(0, frame.size.height/2-defaultImage.size.height/2, defaultImage.size.width, defaultImage.size.height);
    levelLabel.frame = CGRectMake(levelImageView.frame.origin.x+levelImageView.frame.size.width+kMQEvaluationCellHorizontalSpacing, frame.size.height/2-kMQEvaluationCellTextHeight/2, kMQEvaluationCellTextWidth, kMQEvaluationCellTextHeight);
    bottomLine.frame = CGRectMake(0, frame.size.height - 1, frame.size.width, 0.5);
}

- (void)setLevel:(NSInteger)level {
    levelImageView.image = [MQAssetUtil getEvaluationImageWithLevel:level];
    switch (level) {
        case 0:
        {
            levelLabel.text = @"差评";
            break;
        }
        case 1:
        {
            levelLabel.text = @"中评";
            break;
        }
        case 2:
        {
            levelLabel.text = @"好评";
            break;
        }
        default:
            break;
    }
}

+ (CGFloat)getCellHeight {
    CGFloat cellHeight = 0;
    cellHeight += kMQEvaluationCellVerticalSpacing;
    UIImage *defaultImage = [MQAssetUtil getEvaluationImageWithLevel:0];
    cellHeight += defaultImage.size.height;
    cellHeight += kMQEvaluationCellVerticalSpacing;
    cellHeight += 1;
    return cellHeight;
}

- (void)hideBottomLine {
    bottomLine.hidden = true;
}

@end
