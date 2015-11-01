//
//  MQVoiceCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQVoiceCellModel.h"
#import "MQChatBaseCell.h"
#import "MQVoiceMessageCell.h"
#import "MQChatViewConfig.h"

/**
 * 语音播放图片与聊天气泡的间距
 */
static CGFloat const kMQCellVoiceImageToBubbleSpacing = 24.0;


@interface MQVoiceCellModel()
/**
 * @brief cell的高度
 */
@property (nonatomic, readwrite, assign) CGFloat cellHeight;

/**
 * @brief 语音data
 */
@property (nonatomic, readwrite, copy) NSData *voiceData;

/**
 * @brief 语音的时长
 */
@property (nonatomic, readwrite, assign) NSInteger voiceDuration;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *date;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readwrite, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片名字 (如果在头像path不存在的情况下，才使用这个属性)
 */
@property (nonatomic, readwrite, copy) UIImage *avatarLocalImage;

/**
 * @brief 聊天气泡的image
 */
@property (nonatomic, readwrite, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡button的frame
 */
@property (nonatomic, readwrite, assign) CGRect bubbleImageFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readwrite, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readwrite, assign) CGRect indicatorFrame;

/**
 * @brief 语音时长的frame
 */
@property (nonatomic, readwrite, assign) CGRect durationLabelFrame;

/**
 * @brief 语音图片的frame
 */
@property (nonatomic, readwrite, assign) CGRect voiceImageFrame;

/**
 * @brief 发送出错图片的frame
 */
@property (nonatomic, readwrite, assign) CGRect sendFailureFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readwrite, assign) MQChatCellFromType cellFromType;

@end

@implementation MQVoiceCellModel

#pragma initialize
/**
 *  根据MQMessage内容来生成cell model
 */
- (MQVoiceCellModel *)initCellModelWithMessage:(MQVoiceMessage *)message cellWidth:(CGFloat)cellWidth {
    if (self = [super init]) {
        self.sendType = MQChatCellSending;
        self.date = message.date;
        self.avatarPath = @"";
        self.avatarLocalImage = [MQChatViewConfig sharedConfig].agentDefaultAvatarImage;
        if (message.userAvatarPath) {
            self.avatarPath = message.userAvatarPath;
        }
        
        //语音图片size
        UIImage *voiceImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQBubble_voice_animation_gray3"]];
        CGSize voiceImageSize = voiceImage.size;
        
        //获取语音数据
        self.voiceData = message.voiceData;
        if (self.voiceData) {
#warning 这里增加获取网络data的逻辑
        }
        self.voiceDuration = [MQChatFileUtil getAudioDurationWithData:self.voiceData];
        
        //气泡高度
        CGFloat bubbleHeight = kMQCellAvatarDiameter;
        //根据语音时长来确定气泡宽度
        CGFloat maxBubbleWidth = cellWidth - kMQCellAvatarToHorizontalEdgeSpacing - kMQCellAvatarDiameter - kMQCellAvatarToBubbleSpacing - kMQCellBubbleMaxWidthToEdgeSpacing;
        CGFloat bubbleWidth = maxBubbleWidth;
        if (self.voiceDuration < [MQChatViewConfig sharedConfig].maxVoiceDuration) {
            bubbleWidth = ceil(maxBubbleWidth * self.voiceDuration / [MQChatViewConfig sharedConfig].maxVoiceDuration);
        }

        //根据消息的来源，进行处理
        UIImage *bubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
        if (message.fromType == MQMessageOutgoing) {
            //发送出去的消息
            self.cellFromType = MQChatCellOutgoing;
            bubbleImage = [MQChatViewConfig sharedConfig].outgoingBubbleImage;
            
            //头像的frame
//            self.avatarFrame = CGRectMake(cellWidth-kMQCellAvatarToHorizontalEdgeSpacing-kMQCellAvatarDiameter, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
            self.avatarFrame = CGRectMake(0, 0, 0, 0);
            //气泡的frame
            self.bubbleImageFrame = CGRectMake(cellWidth-kMQCellAvatarToBubbleSpacing-bubbleWidth, kMQCellAvatarToVerticalEdgeSpacing, bubbleWidth, bubbleHeight);
            //语音图片的frame
            self.voiceImageFrame = CGRectMake(self.bubbleImageFrame.size.width-kMQCellVoiceImageToBubbleSpacing-voiceImageSize.width, self.bubbleImageFrame.size.height/2-voiceImageSize.height/2, voiceImageSize.width, voiceImageSize.height);
        } else {
            //收到的消息
            self.cellFromType = MQChatCellIncoming;
            
            //头像的frame
            self.avatarFrame = CGRectMake(kMQCellAvatarToHorizontalEdgeSpacing, kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarDiameter, kMQCellAvatarDiameter);
            //气泡的frame
            self.bubbleImageFrame = CGRectMake(self.avatarFrame.origin.x+self.avatarFrame.size.width+kMQCellAvatarToBubbleSpacing, self.avatarFrame.origin.y, bubbleWidth, bubbleHeight);
            //语音图片的frame
            self.voiceImageFrame = CGRectMake(kMQCellVoiceImageToBubbleSpacing, self.bubbleImageFrame.size.height/2-voiceImageSize.height/2, voiceImageSize.width, voiceImageSize.height);
        }
        
        //气泡图片
        CGPoint centerArea = CGPointMake(bubbleImage.size.width / 4.0f, bubbleImage.size.height*3.0f / 4.0f);
        self.bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(centerArea.y, centerArea.x, bubbleImage.size.height-centerArea.y+1, centerArea.x)];
        
        //发送消息的indicator的frame
        UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, kMQCellIndicatorDiameter, kMQCellIndicatorDiameter)];
        self.indicatorFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-indicatorView.frame.size.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-indicatorView.frame.size.height/2, indicatorView.frame.size.width, indicatorView.frame.size.height);
        //发送失败的图片frame
        UIImage *failureImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQMessageWarning"]];
        self.sendFailureFrame = CGRectMake(self.bubbleImageFrame.origin.x-kMQCellBubbleToIndicatorSpacing-failureImage.size.width, self.bubbleImageFrame.origin.y+self.bubbleImageFrame.size.height/2-failureImage.size.height/2, failureImage.size.width, failureImage.size.height);
        
        //计算cell的高度
        self.cellHeight = self.bubbleImageFrame.origin.y + self.bubbleImageFrame.size.height + kMQCellAvatarToVerticalEdgeSpacing;
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
    return [[MQVoiceMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (NSDate *)getCellDate {
    return self.date;
}

- (BOOL)isServiceRelatedCell {
    return true;
}


@end
