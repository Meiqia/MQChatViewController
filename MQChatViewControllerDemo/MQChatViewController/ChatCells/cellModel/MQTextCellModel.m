//
//  MQTextCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTextCellModel.h"
#import "MQTextMessageCell.h"
#import "MQChatBaseCell.h"
#import "MQChatFileUtil.h"
#import "MQStringSizeUtil.h"
#import <UIKit/UIKit.h>
#import "MQChatViewConfig.h"

@interface MQTextCellModel()

/**
 * @brief cell中消息的id
 */
@property (nonatomic, readwrite, strong) NSString *messageId;

/**
 * @brief 消息的文字
 */
@property (nonatomic, readwrite, copy) NSString *cellText;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readwrite, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片名字
 */
@property (nonatomic, readwrite, copy) UIImage *avatarImage;

/**
 * @brief 聊天气泡的image
 */
@property (nonatomic, readwrite, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡的frame
 */
@property (nonatomic, readwrite, assign) CGRect bubbleImageFrame;

/**
 * @brief 消息气泡中的文字的frame
 */
@property (nonatomic, readwrite, assign) CGRect textLabelFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readwrite, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendingIndicatorFrame;

/**
 * @brief 发送出错图片的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendFailureFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readwrite, assign) MQChatCellFromType cellFromType;

/**
 * @brief 消息文字中，数字选中识别的字典 [number : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *numberRangeDic;

/**
 * @brief 消息文字中，url选中识别的字典 [url : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *linkNumberRangeDic;

/**
 * @brief 消息文字中，email选中识别的字典 [email : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *emailNumberRangeDic;

/**
 * @brief cell的宽度
 */
@property (nonatomic, readwrite, assign) CGFloat cellWidth;

/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;


@end

@implementation MQTextCellModel

- (MQTextCellModel *)initCellModelWithMessage:(MQTextMessage *)message cellWidth:(CGFloat)cellWidth {
    if (self = [super init]) {
        self.messageId = message.messageId;
        self.sendType = MQChatCellSending;
        self.cellText = message.content;
        self.date = message.date;
        if (message.userAvatarPath.length > 0) {
            self.avatarPath = message.userAvatarPath;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.userAvatarPath]];
                self.avatarImage = [UIImage imageWithData:imageData];
            });
        } else {
            self.avatarImage = [MQChatViewConfig sharedConfig].agentDefaultAvatarImage;
        }
        
        //文字最大宽度
        CGFloat maxLabelWidth = cellWidth - kMQCellAvatarToHorizontalEdgeSpacing - kMQCellAvatarDiameter - kMQCellAvatarToBubbleSpacing - kMQCellBubbleToTextHorizontalLargerSpacing - kMQCellBubbleToTextHorizontalSmallerSpacing - kMQCellBubbleMaxWidthToEdgeSpacing;
        //文字高度
        CGFloat messageTextHeight = [MQStringSizeUtil getHeightForText:message.content withFont:[UIFont systemFontOfSize:kMQCellTextFontSize] andWidth:maxLabelWidth];
        //文字宽度
        CGFloat messageTextWidth = [MQStringSizeUtil getWidthForText:message.content withFont:[UIFont systemFontOfSize:kMQCellTextFontSize] andHeight:messageTextHeight];
        if (messageTextWidth > maxLabelWidth) {
            messageTextWidth = maxLabelWidth;
        }
        //气泡高度
        CGFloat bubbleHeight = messageTextHeight + kMQCellBubbleToTextVerticalSpacing * 2;
        //气泡宽度
        CGFloat bubbleWidth = messageTextWidth + kMQCellBubbleToTextHorizontalLargerSpacing + kMQCellBubbleToTextHorizontalSmallerSpacing;
        
        //根据消息的来源，进行处理
        UIImage *bubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
        if (message.fromType == MQMessageOutgoing) {
            //发送出去的消息
            self.cellFromType = MQChatCellOutgoing;
            bubbleImage = [MQChatViewConfig sharedConfig].outgoingBubbleImage;
            
            //头像的frame
            if ([MQChatViewConfig sharedConfig].enableClientAvatar) {
                self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
            } else {
                self.avatarFrame = CGRectMake(0, 0, 0, 0);
            }
            //气泡的frame
            self.bubbleImageFrame = CGRectMake(cellWidth-self.avatarFrame.origin.x-kMQCellAvatarToBubbleSpacing-bubbleWidth, kMQCellAvatarToVerticalEdgeSpacing, bubbleWidth, bubbleHeight);
            //文字的frame
            self.textLabelFrame = CGRectMake(kMQCellBubbleToTextHorizontalSmallerSpacing, kMQCellBubbleToTextVerticalSpacing, messageTextWidth, messageTextHeight);
        } else {
            //收到的消息
            self.cellFromType = MQChatCellIncoming;
            
            //头像的frame
            self.avatarFrame = CGRectMake(kMQCellAvatarToHorizontalEdgeSpacing, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
            //气泡的frame
            self.bubbleImageFrame = CGRectMake(self.avatarFrame.origin.x+self.avatarFrame.size.width+kMQCellAvatarToBubbleSpacing, self.avatarFrame.origin.y, bubbleWidth, bubbleHeight);
            //文字的frame
            self.textLabelFrame = CGRectMake(kMQCellBubbleToTextHorizontalLargerSpacing, kMQCellBubbleToTextVerticalSpacing, messageTextWidth, messageTextHeight);
        }
        
        //气泡图片
        CGPoint centerArea = CGPointMake(bubbleImage.size.width / 4.0f, bubbleImage.size.height*3.0f / 4.0f);
        self.bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(centerArea.y, centerArea.x, bubbleImage.size.height-centerArea.y+1, centerArea.x)];
        
        //发送消息的indicator的frame
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kMQCellIndicatorDiameter, kMQCellIndicatorDiameter)];
        self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-indicatorView.frame.size.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-indicatorView.frame.size.height/2, indicatorView.frame.size.width, indicatorView.frame.size.height);
        //发送失败的图片frame
        UIImage *failureImage = [MQChatViewConfig sharedConfig].messageSendFailureImage;
        CGSize failureSize = CGSizeMake(ceil(failureImage.size.width * 2 / 3), ceil(failureImage.size.height * 2 / 3));
        self.sendFailureFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-failureSize.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-failureSize.height/2, failureSize.width, failureSize.height);
        
        //计算cell的高度
        self.cellHeight = self.bubbleImageFrame.origin.y + self.bubbleImageFrame.size.height + kMQCellAvatarToVerticalEdgeSpacing;
        
        //匹配消息文字中的正则
        //数字正则匹配
        NSMutableDictionary *numberRegexDic = [[NSMutableDictionary alloc] init];
        for (NSString *numberRegex in [MQChatViewConfig sharedConfig].numberRegexs) {
            NSRange range = [message.content rangeOfString:numberRegex options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                [numberRegexDic setValue:[NSValue valueWithRange:range] forKey:[message.content substringWithRange:range]];
            }
        }
        self.numberRangeDic = numberRegexDic;
        //链接正则匹配
        NSMutableDictionary *linkRegexDic = [[NSMutableDictionary alloc] init];
        for (NSString *linkRegex in [MQChatViewConfig sharedConfig].linkRegexs) {
            NSRange range = [message.content rangeOfString:linkRegex options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                [linkRegexDic setValue:[NSValue valueWithRange:range] forKey:[message.content substringWithRange:range]];
            }
        }
        self.linkNumberRangeDic = linkRegexDic;
        //email正则匹配
        NSMutableDictionary *emailRegexDic = [[NSMutableDictionary alloc] init];
        for (NSString *emailRegex in [MQChatViewConfig sharedConfig].emailRegexs) {
            NSRange range = [message.content rangeOfString:emailRegex options:NSRegularExpressionSearch];
            if (range.location != NSNotFound) {
                [emailRegexDic setValue:[NSValue valueWithRange:range] forKey:[message.content substringWithRange:range]];
            }
        }
        self.emailNumberRangeDic = emailRegexDic;
    }
    return self;
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight;
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
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

- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth {
    self.cellWidth = cellWidth;
    if (self.cellFromType == MQChatCellOutgoing) {
        //头像的frame
        if ([MQChatViewConfig sharedConfig].enableClientAvatar) {
            self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
        } else {
            self.avatarFrame = CGRectMake(0, 0, 0, 0);
        }
        //气泡的frame
        self.bubbleImageFrame = CGRectMake(cellWidth-self.avatarFrame.origin.x-kMQCellAvatarToBubbleSpacing-self.bubbleImageFrame.size.width, kMQCellAvatarToVerticalEdgeSpacing, self.bubbleImageFrame.size.width, self.bubbleImageFrame.size.height);
        //发送指示器的frame
        self.sendingIndicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-self.sendingIndicatorFrame.size.width, self.sendingIndicatorFrame.origin.y, self.sendingIndicatorFrame.size.width, self.sendingIndicatorFrame.size.height);
        //发送出错图片的frame
        self.sendFailureFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-self.sendFailureFrame.size.width, self.sendFailureFrame.origin.y, self.sendFailureFrame.size.width, self.sendFailureFrame.size.height);
    }
}


@end
