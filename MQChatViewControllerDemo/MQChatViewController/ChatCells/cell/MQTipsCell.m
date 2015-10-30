//
//  MQTipsCell.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTipsCell.h"
#import "MQTipsCellModel.h"

static CGFloat const kMQMessageTipsLabelFontSize = 12.0;
//上下两条线与cell垂直边沿的间距
static CGFloat const kMQMessageTipsLabelLineVerticalMargin = 2.0;
//上下两条线超过文字label的距离
static CGFloat const kMQMessageTipsLabelToLineSpacing = 8.0;
static CGFloat const kMQMessageTipsLabelHeight = 0.5;


@implementation MQTipsCell {
    UILabel *tipsLabel;
    CALayer *topLineLayer;
    CALayer *bottomLineLayer;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化提示label
        tipsLabel = [[UILabel alloc] init];
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:kMQMessageTipsLabelFontSize];
        [self.contentView addSubview:tipsLabel];
        //画上下两条线
        topLineLayer = [self gradientLine];
        [self.contentView.layer addSublayer:topLineLayer];
        bottomLineLayer = [self gradientLine];
        [self.contentView.layer addSublayer:bottomLineLayer];
    }
    return self;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQTipsCellModel class]]) {
        NSAssert(NO, @"传给MQTipsCell的Model类型不正确");
        return ;
    }
    
    MQTipsCellModel *cellModel = (MQTipsCellModel *)model;
    
    //刷新时间label
    tipsLabel.text = cellModel.tipText;
    tipsLabel.frame = cellModel.tipLabelFrame;
    
    //刷新上下两条线
    topLineLayer.frame = cellModel.topLineFrame;
    bottomLineLayer.frame = cellModel.bottomLineFrame;
}

- (CAGradientLayer*)gradientLine {
    CAGradientLayer* line = [CAGradientLayer layer];
    line.backgroundColor = [UIColor clearColor].CGColor;
    line.startPoint = CGPointMake(0, 0.5);
    line.endPoint = CGPointMake(1, 0.5);
    line.colors = @[(id)[UIColor clearColor].CGColor,
                    (id)[UIColor grayColor].CGColor,
                    (id)[UIColor grayColor].CGColor,
                    (id)[UIColor clearColor].CGColor];
    return line;
}

@end
