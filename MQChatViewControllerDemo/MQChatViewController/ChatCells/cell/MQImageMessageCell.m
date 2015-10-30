//
//  MQImageMessageCell.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQImageMessageCell.h"
#import "MQImageCellModel.h"
#import "MQChatFileUtil.h"
#import "MQImageUtil.h"

@implementation MQImageMessageCell {
    UIImageView *avatarImageView;
    UIImageView *bubbleImageView;
    UIActivityIndicatorView *sendMsgIndicator;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化头像
        avatarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:avatarImageView];
        //初始化气泡
        bubbleImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:bubbleImageView];
        //初始化indicator
        sendMsgIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sendMsgIndicator.hidden = YES;
        [self.contentView addSubview:sendMsgIndicator];
    }
    return self;
}



#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQImageCellModel class]]) {
        NSAssert(NO, @"传给MQImageMessageCell的Model类型不正确");
        return ;
    }
    MQImageCellModel *cellModel = (MQImageCellModel *)model;

    //刷新头像
    if (cellModel.avatarPath.length == 0) {
        avatarImageView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:cellModel.avatarLocolImageName]];
    } else {
#warning 使用SDWebImage或自己写获取远程图片的方法
    }
    avatarImageView.frame = cellModel.avatarFrame;
    
    //刷新气泡
    bubbleImageView.frame = cellModel.bubbleImageFrame;
    //消息图片
#warning 使用SDWebImage或自己写获取远程图片的方法
    [MQImageUtil makeMaskView:bubbleImageView withImage:cellModel.bubbleImage];
    
    //刷新indicator
    sendMsgIndicator.hidden = true;
    [sendMsgIndicator stopAnimating];
    if (cellModel.sendType == MQChatCellSending) {
        sendMsgIndicator.frame = cellModel.indicatorFrame;
        [sendMsgIndicator startAnimating];
    }
}

@end
