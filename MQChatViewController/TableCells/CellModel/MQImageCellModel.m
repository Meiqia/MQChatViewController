//
//  MQImageCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQImageCellModel.h"
#import "MQChatBaseCell.h"
#import "MQImageMessageCell.h"
#import "MQChatViewConfig.h"
#import "MQImageUtil.h"
#import "MQServiceToViewInterface.h"
#ifndef INCLUDE_MEIQIA_SDK
#import "UIImageView+WebCache.h"
#endif
@interface MQImageCellModel()

/**
 * @brief cell中消息的id
 */
@property (nonatomic, readwrite, strong) NSString *messageId;

/**
 * @brief 用户名字，暂时没用
 */
@property (nonatomic, readwrite, copy) NSString *userName;

/**
 * @brief cell的宽度
 */
@property (nonatomic, readwrite, assign) CGFloat cellWidth;

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 图片path
 */
//@property (nonatomic, readwrite, copy) NSString *imagePath;

/**
 * @brief 图片image(当imagePath不存在时使用)
 */
@property (nonatomic, readwrite, strong) UIImage *image;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readwrite, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片
 */
@property (nonatomic, readwrite, copy) UIImage *avatarImage;

/**
 * @brief 聊天气泡的image（该气泡image已经进行了resize）
 */
@property (nonatomic, readwrite, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡的frame
 */
@property (nonatomic, readwrite, assign) CGRect bubbleImageFrame;

/**
 * bubble中的imageView的frame，该frame是在关闭bubble mask情况下生效
 */
@property (nonatomic, readwrite, assign) CGRect contentImageViewFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readwrite, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendingIndicatorFrame;

/**
 * @brief 读取照片的指示器的frame
 */
@property (nonatomic, readwrite, assign) CGRect loadingIndicatorFrame;

/**
 * @brief 发送出错图片的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendFailureFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readwrite, assign) MQChatCellFromType cellFromType;

@end

@implementation MQImageCellModel

#pragma initialize
/**
 *  根据MQMessage内容来生成cell model
 */
- (MQImageCellModel *)initCellModelWithMessage:(MQImageMessage *)message
                                     cellWidth:(CGFloat)cellWidth
                                      delegate:(id<MQCellModelDelegate>)delegator{
    if (self = [super init]) {
        self.cellWidth = cellWidth;
        self.delegate = delegator;
        self.messageId = message.messageId;
        self.sendStatus = message.sendStatus;
        self.date = message.date;
        self.avatarPath = @"";
        self.cellHeight = 44.0;
        if (message.userAvatarImage) {
            self.avatarImage = message.userAvatarImage;
        } else if (message.userAvatarPath.length > 0) {
            self.avatarPath = message.userAvatarPath;
            //这里使用美洽接口下载多媒体消息的图片，开发者也可以替换成自己的图片缓存策略
#ifdef INCLUDE_MEIQIA_SDK
            [MQServiceToViewInterface downloadMediaWithUrlString:message.userAvatarPath progress:^(float progress) {
            } completion:^(NSData *mediaData, NSError *error) {
                if (mediaData && !error) {
                    self.avatarImage = [UIImage imageWithData:mediaData];
                } else {
                    self.avatarImage = message.fromType == MQChatMessageIncoming ? [MQChatViewConfig sharedConfig].incomingDefaultAvatarImage : [MQChatViewConfig sharedConfig].outgoingDefaultAvatarImage;
                }
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(didUpdateCellDataWithMessageId:)]) {
                        //通知ViewController去刷新tableView
                        [self.delegate didUpdateCellDataWithMessageId:self.messageId];
                    }
                }
            }];
#else
            __block UIImageView *tempImageView = [UIImageView new];
            [tempImageView sd_setImageWithURL:[NSURL URLWithString:message.userAvatarPath] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                self.avatarImage = tempImageView.image.copy;
                if (self.delegate) {
                    if ([self.delegate respondsToSelector:@selector(didUpdateCellDataWithMessageId:)]) {
                        //通知ViewController去刷新tableView
                        [self.delegate didUpdateCellDataWithMessageId:self.messageId];
                    }
                }
            }];
#endif
        } else {
            self.avatarImage = [MQChatViewConfig sharedConfig].incomingDefaultAvatarImage;
            if (message.fromType == MQChatMessageOutgoing) {
                self.avatarImage = [MQChatViewConfig sharedConfig].outgoingDefaultAvatarImage;
            }
        }
        
        //内容图片
        self.image = message.image;
        if (!message.image) {
            if (message.imagePath.length > 0) {
                
                //默认cell高度为图片显示的最大高度
                self.cellHeight = cellWidth / 2;
                
//                [self setModelsWithContentImage:[MQChatViewConfig sharedConfig].incomingBubbleImage cellFromType:message.fromType cellWidth:cellWidth];
                
                //这里使用美洽接口下载多媒体消息的图片，开发者也可以替换成自己的图片缓存策略
#ifdef INCLUDE_MEIQIA_SDK
                [MQServiceToViewInterface downloadMediaWithUrlString:message.imagePath progress:^(float progress) {
                } completion:^(NSData *mediaData, NSError *error) {
                    if (mediaData && !error) {
                        self.image = [UIImage imageWithData:mediaData];
                        [self setModelsWithContentImage:self.image cellFromType:message.fromType cellWidth:cellWidth];
                    } else {
                        self.image = [MQChatViewConfig sharedConfig].imageLoadErrorImage;
                        [self setModelsWithContentImage:self.image cellFromType:message.fromType cellWidth:cellWidth];
                    }
                    if (self.delegate) {
                        if ([self.delegate respondsToSelector:@selector(didUpdateCellDataWithMessageId:)]) {
                            [self.delegate didUpdateCellDataWithMessageId:self.messageId];
                        }
                    }
                }];
#else
                //非美洽SDK用户，使用了SDWebImage来做图片缓存
                __block UIImageView *tempImageView = [[UIImageView alloc] init];
                [tempImageView sd_setImageWithURL:[NSURL URLWithString:message.imagePath] placeholderImage:nil options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    if (image) {
                        self.image = tempImageView.image.copy;
                        [self setModelsWithContentImage:self.image message:message cellWidth:cellWidth];
                    } else {
                        self.image = [MQChatViewConfig sharedConfig].imageLoadErrorImage;
                        [self setModelsWithContentImage:self.image message:message cellWidth:cellWidth];
                    }
                    if (self.delegate) {
                        if ([self.delegate respondsToSelector:@selector(didUpdateCellDataWithMessageId:)]) {
                            [self.delegate didUpdateCellDataWithMessageId:self.messageId];
                        }
                    }
                }];
#endif
            } else {
                self.image = [MQChatViewConfig sharedConfig].imageLoadErrorImage;
                [self setModelsWithContentImage:self.image cellFromType:message.fromType cellWidth:cellWidth];
            }
        } else {
            [self setModelsWithContentImage:self.image cellFromType:message.fromType cellWidth:cellWidth];
        }
        
    }
    return self;
}

//根据气泡中的图片生成其他model
- (void)setModelsWithContentImage:(UIImage *)contentImage
                          cellFromType:(MQChatMessageFromType)cellFromType
                        cellWidth:(CGFloat)cellWidth
{
    //限定图片的最大直径
    CGFloat maxBubbleDiameter = ceil(cellWidth / 2);  //限定图片的最大直径
    CGSize contentImageSize = contentImage ? contentImage.size : CGSizeMake(20, 20);
    
    //先限定图片宽度来计算高度
    CGFloat imageWidth = contentImageSize.width < maxBubbleDiameter ? contentImageSize.width : maxBubbleDiameter;
    CGFloat imageHeight = ceil(contentImageSize.height / contentImageSize.width * imageWidth);
    //判断如果气泡高度计算结果超过图片的最大直径，则限制高度
    if (imageHeight > maxBubbleDiameter) {
        imageHeight = maxBubbleDiameter;
        imageWidth = ceil(contentImageSize.width / contentImageSize.height * imageHeight);
    }
    
    //根据消息的来源，进行处理
    UIImage *bubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
    if ([MQChatViewConfig sharedConfig].incomingBubbleColor) {
        bubbleImage = [MQImageUtil convertImageColorWithImage:bubbleImage toColor:[MQChatViewConfig sharedConfig].incomingBubbleColor];
    }
    
    if (cellFromType == MQChatMessageOutgoing) {
        //发送出去的消息
        self.cellFromType = MQChatCellOutgoing;
        bubbleImage = [MQChatViewConfig sharedConfig].outgoingBubbleImage;
        if ([MQChatViewConfig sharedConfig].outgoingBubbleColor) {
            bubbleImage = [MQImageUtil convertImageColorWithImage:bubbleImage toColor:[MQChatViewConfig sharedConfig].outgoingBubbleColor];
        }
        //头像的frame
        if ([MQChatViewConfig sharedConfig].enableOutgoingAvatar) {
            self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
        } else {
            self.avatarFrame = CGRectMake(0, 0, 0, 0);
        }
        
        //content内容
        self.contentImageViewFrame = CGRectMake(kMQCellBubbleToImageHorizontalSmallerSpacing, kMQCellBubbleToImageVerticalSpacing, imageWidth, imageHeight);
        //气泡的frame
        self.bubbleImageFrame = CGRectMake(
                                           cellWidth - self.avatarFrame.size.width - kMQCellAvatarToHorizontalEdgeSpacing - kMQCellAvatarToBubbleSpacing - imageWidth - kMQCellBubbleToImageHorizontalSmallerSpacing - kMQCellBubbleToImageHorizontalLargerSpacing,
                                           kMQCellAvatarToVerticalEdgeSpacing,
                                           imageWidth + kMQCellBubbleToImageHorizontalSmallerSpacing + kMQCellBubbleToImageHorizontalLargerSpacing,
                                           imageHeight + kMQCellBubbleToImageVerticalSpacing * 2);
        if ([MQChatViewConfig sharedConfig].enableMessageImageMask) {
            self.bubbleImageFrame = CGRectMake(cellWidth-self.avatarFrame.size.width-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarToBubbleSpacing-imageWidth, kMQCellAvatarToVerticalEdgeSpacing, imageWidth, imageHeight);
        }
    } else {
        //收到的消息
        self.cellFromType = MQChatCellIncoming;
        
        //头像的frame
        if ([MQChatViewConfig sharedConfig].enableIncomingAvatar) {
            self.avatarFrame = CGRectMake(kMQCellAvatarToHorizontalEdgeSpacing, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
        } else {
            self.avatarFrame = CGRectMake(0, 0, 0, 0);
        }
        self.contentImageViewFrame = CGRectMake(kMQCellBubbleToImageHorizontalLargerSpacing, kMQCellBubbleToImageVerticalSpacing, imageWidth, imageHeight);
        //气泡的frame
        self.bubbleImageFrame = CGRectMake(
                                           self.avatarFrame.origin.x+self.avatarFrame.size.width+kMQCellAvatarToBubbleSpacing,
                                           self.avatarFrame.origin.y,
                                           imageWidth + kMQCellBubbleToImageHorizontalSmallerSpacing + kMQCellBubbleToImageHorizontalLargerSpacing,
                                           imageHeight + kMQCellBubbleToImageVerticalSpacing * 2);
        if ([MQChatViewConfig sharedConfig].enableMessageImageMask) {
            self.bubbleImageFrame = CGRectMake(self.avatarFrame.origin.x+self.avatarFrame.size.width+kMQCellAvatarToBubbleSpacing, self.avatarFrame.origin.y, imageWidth, imageHeight);
        }
    }
    
    //loading image的indicator
    self.loadingIndicatorFrame = CGRectMake(self.bubbleImageFrame.size.width/2-kMQCellIndicatorDiameter/2, self.bubbleImageFrame.size.height/2-kMQCellIndicatorDiameter/2, kMQCellIndicatorDiameter, kMQCellIndicatorDiameter);
    
    //气泡图片
    self.bubbleImage = [bubbleImage resizableImageWithCapInsets:[MQChatViewConfig sharedConfig].bubbleImageStretchInsets];
    
    //发送消息的indicator的frame
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kMQCellIndicatorDiameter, kMQCellIndicatorDiameter)];
    self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-indicatorView.frame.size.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-indicatorView.frame.size.height/2, indicatorView.frame.size.width, indicatorView.frame.size.height);
    
    //发送失败的图片frame
    UIImage *failureImage = [MQChatViewConfig sharedConfig].messageSendFailureImage;
    CGSize failureSize = CGSizeMake(ceil(failureImage.size.width * 2 / 3), ceil(failureImage.size.height * 2 / 3));
    self.sendFailureFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-failureSize.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-failureSize.height/2, failureSize.width, failureSize.height);
    
    //计算cell的高度
    self.cellHeight = self.bubbleImageFrame.origin.y + self.bubbleImageFrame.size.height + kMQCellAvatarToVerticalEdgeSpacing;

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
    return [[MQImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (NSDate *)getCellDate {
    return self.date;
}

- (BOOL)isServiceRelatedCell {
    return true;
}

- (NSString *)getCellMessageId {
    return self.messageId;
}

- (void)updateCellSendStatus:(MQChatMessageSendStatus)sendStatus {
    self.sendStatus = sendStatus;
}

- (void)updateCellMessageId:(NSString *)messageId {
    self.messageId = messageId;
}

- (void)updateCellMessageDate:(NSDate *)messageDate {
    self.date = messageDate;
}

- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth {
    self.cellWidth = cellWidth;
//    if (self.cellFromType == MQChatCellOutgoing) {
//        //头像的frame
//        if ([MQChatViewConfig sharedConfig].enableOutgoingAvatar) {
//            self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
//        } else {
//            self.avatarFrame = CGRectMake(0, 0, 0, 0);
//        }
//        //气泡的frame
//        self.bubbleImageFrame = CGRectMake(cellWidth-self.avatarFrame.size.width-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarToBubbleSpacing-self.bubbleImageFrame.size.width, kMQCellAvatarToVerticalEdgeSpacing, self.bubbleImageFrame.size.width, self.bubbleImageFrame.size.height);
//        //发送指示器的frame
//        self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-self.sendingIndicatorFrame.size.width, self.sendingIndicatorFrame.origin.y, self.sendingIndicatorFrame.size.width, self.sendingIndicatorFrame.size.height);
//        //发送出错图片的frame
//        self.sendFailureFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-self.sendFailureFrame.size.width, self.sendFailureFrame.origin.y, self.sendFailureFrame.size.width, self.sendFailureFrame.size.height);
//    }
    
    [self setModelsWithContentImage:self.image cellFromType:(MQChatMessageFromType)self.cellFromType cellWidth:cellWidth];
}

- (void)updateOutgoingAvatarImage:(UIImage *)avatarImage {
    if (self.cellFromType == MQChatCellOutgoing) {
        self.avatarImage = avatarImage;
    }
}


@end
