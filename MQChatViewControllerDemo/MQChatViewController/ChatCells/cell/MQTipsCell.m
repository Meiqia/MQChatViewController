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


@implementation MQTipsCell {
    UILabel *tipsLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化提示label
        tipsLabel = [[UILabel alloc] init];
        tipsLabel.textColor = [UIColor grayColor];
        tipsLabel.textAlignment = NSTextAlignmentCenter;
        tipsLabel.font = [UIFont systemFontOfSize:kMQMessageTipsLabelFontSize];
        [self.contentView addSubview:tipsLabel];
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

}

@end
