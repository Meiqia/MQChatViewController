//
//  MQChatViewModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//


#import "MQChatViewModel.h"
#import "MQTextMessage.h"
#import "MQImageMessage.h"
#import "MQVoiceMessage.h"
#import "MQTextCellModel.h"
#import "MQImageCellModel.h"
#import "MQVoiceCellModel.h"
#import "MQMessageDateCellModel.h"

#ifdef INCLUDE_MEIQIA_SDK
#import "MQManager.h"
#endif

static NSInteger const kMQChatMessageMaxTimeInterval = 60;

/** 一次获取历史消息数的个数 */
static NSInteger const kMQChatGetHistoryMessageNumber = 20;


#ifdef INCLUDE_MEIQIA_SDK
@interface MQChatViewModel() <MQMessageDelegate>

@end
#endif

@implementation MQChatViewModel {
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellModels = [[NSMutableArray alloc] init];
    }
    return self;
}

/**
 * 获取更多历史聊天消息
 */
- (void)startGettingHistoryMessages {
    
#ifdef INCLUDE_MEIQIA_SDK
    id<MQCellModelProtocol> cellModel = [self.cellModels lastObject];
    [MQManager getHistoryMessagesWithMsgDate:[cellModel getCellDate] messagesNumber:kMQChatGetHistoryMessageNumber delegate:self];
#endif
}

/**
 * 发送文字消息
 */
- (void)sendTextMessageWithContent:(NSString *)content {
    MQTextMessage *message = [[MQTextMessage alloc] initWithContent:content];
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self.cellModels addObject:cellModel];
#ifdef INCLUDE_MEIQIA_SDK
    [MQManager sendTextMessageWithContent:content delegate:self];
#endif
    
}

/**
 * 发送图片消息
 */
- (void)sendImageMessageWithImage:(UIImage *)image {
    MQImageMessage *message = [[MQImageMessage alloc] initWithImage:image];
    MQImageCellModel *cellModel = [[MQImageCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self.cellModels addObject:cellModel];
#ifdef INCLUDE_MEIQIA_SDK
    [MQManager sendImageMessageWithImage:image delegate:self];
#endif
}

/**
 * 发送语音消息
 */
- (void)sendVoiceMessageWithVoice:(NSData *)voiceData {
    MQVoiceMessage *message = [[MQVoiceMessage alloc] initWithVoiceData:voiceData];
    MQVoiceCellModel *cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self.cellModels addObject:cellModel];
#ifdef INCLUDE_MEIQIA_SDK
    [MQManager sendAudioMessage:voiceData delegate:self];
#endif
}

/**
 * 发送“用户正在输入”的消息
 */
- (void)sendUserInputtingWithContent:(NSString *)content {
#ifdef INCLUDE_MEIQIA_SDK
    [MQManager sendClientInputtingWithContent:content];
#endif
}

#ifdef INCLUDE_MEIQIA_SDK

#pragma MQMessageDelegate
- (void)didReceiveMultipleMessage:(NSArray *)messages {
    
}

- (void)didReceiveMessage:(MQMessage *)message {
    
}

- (void)didSendMessage:(MQMessage *)message expcetion:(kMQExceptionStatus)expcetion {
    
}

/**
 * 判断两个时间间隔是否过大，如果过大，返回一个MessageDateCellModel
 */
- (void)generateMessageDateCellWithCurrentCellModel:(id<MQCellModelProtocol>)currentCellModel {
    NSDate *lastDate = [self getBussinessCellModelDateWithIndex:self.cellModels.count];
    NSDate *nextDate = [currentCellModel getCellDate];
    //如果上一个cell的时间比下一个cell还要大（说明currentCell是第一个业务cell，此时显示时间cell）
    BOOL isLastDateLargerThanNextDate = lastDate.timeIntervalSince1970 > nextDate.timeIntervalSince1970;
    //如果下一个cell比上一个cell的时间间隔没有超过阈值
    bool isDateTimeIntervalSmallerThanThreshold = nextDate.timeIntervalSince1970 - lastDate.timeIntervalSince1970 < kMQChatMessageMaxTimeInterval;
    if (!isLastDateLargerThanNextDate && isDateTimeIntervalSmallerThanThreshold) {
        return ;
    }
    MQMessageDateCellModel *cellModel = [[MQMessageDateCellModel alloc] initCellModelWithDate:nextDate cellWidth:self.chatViewWidth];
    [self.cellModels addObject:cellModel];
}

/**
 * 从cellModels中获取到业务相关的cellModel的时间，即text, image, voice的时间；
 */
- (NSDate *)getBussinessCellModelDateWithIndex:(NSInteger)index {
    id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
    if ([cellModel isKindOfClass:[MQTextCellModel class]] || [cellModel isKindOfClass:[MQImageCellModel class]] || [cellModel isKindOfClass:[MQVoiceCellModel class]]){
        return [cellModel getCellDate];
    }
    [self getBussinessCellModelDateWithIndex:index - 1];
    return [NSDate date];
}




#endif


@end
