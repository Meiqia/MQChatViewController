//
//  MQImageMessageCell.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQImageMessageCell.h"
#import "MQImageCellModel.h"
#import "MQChatFileUtil.h"
#import "MQImageUtil.h"
#import "MQChatViewConfig.h"
#import "UIImageView+MHFacebookImageViewer.h"

@implementation MQImageMessageCell {
    UIImageView *avatarImageView;
    UIImageView *bubbleImageView;
    UIActivityIndicatorView *sendingIndicator;
    UIImageView *failureImageView;
    UIActivityIndicatorView *loadingIndicator;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化头像
        avatarImageView = [[UIImageView alloc] init];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:avatarImageView];
        //初始化气泡
        bubbleImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:bubbleImageView];
        //初始化indicator
        sendingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sendingIndicator.hidden = YES;
        [self.contentView addSubview:sendingIndicator];
        //初始化出错image
        failureImageView = [[UIImageView alloc] initWithImage:[MQChatViewConfig sharedConfig].messageSendFailureImage];
        [self.contentView addSubview:failureImageView];
        //初始化加载数据的indicator
        loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.hidden = YES;
        [bubbleImageView addSubview:loadingIndicator];
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
        avatarImageView.image = cellModel.avatarLocalImage;
    } else {
#warning 使用SDWebImage或自己写获取远程图片的方法
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cellModel.avatarPath]];
            avatarImageView.image = [UIImage imageWithData:imageData];
        });
    }
    avatarImageView.frame = cellModel.avatarFrame;
    
    //刷新气泡
    bubbleImageView.frame = cellModel.bubbleImageFrame;
    
    //消息图片
    loadingIndicator.frame = cellModel.loadingIndicatorFrame;
    if (cellModel.image) {
        bubbleImageView.image = cellModel.image;
        loadingIndicator.hidden = true;
        [loadingIndicator stopAnimating];
    } else {
        bubbleImageView.image = cellModel.bubbleImage;
        loadingIndicator.hidden = false;
        [loadingIndicator startAnimating];
    }
    [bubbleImageView setupImageViewer];
    [MQImageUtil makeMaskView:bubbleImageView withImage:cellModel.bubbleImage];
    
    //刷新indicator
    sendingIndicator.hidden = true;
    [sendingIndicator stopAnimating];
    if (cellModel.sendType == MQChatCellSending && cellModel.cellFromType == MQChatCellOutgoing) {
        sendingIndicator.frame = cellModel.sendingIndicatorFrame;
        [sendingIndicator startAnimating];
    }
    
    //刷新出错图片
    failureImageView.hidden = true;
    if (cellModel.sendType == MQChatCellSentFailure) {
        failureImageView.hidden = false;
        failureImageView.frame = cellModel.sendFailureFrame;
    }
}

@end
