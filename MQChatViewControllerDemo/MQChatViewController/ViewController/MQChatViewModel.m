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

#ifdef INCLUDE_MEIQIA_SDK
#import "MQManager.h"
#endif

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
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message];
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
    MQImageCellModel *cellModel = [[MQImageCellModel alloc] initCellModelWithMessage:message];
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
    MQVoiceCellModel *cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message];
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




#endif


@end
