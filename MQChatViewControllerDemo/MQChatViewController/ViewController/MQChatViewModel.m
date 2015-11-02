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
#import <UIKit/UIKit.h>
#import "MQToast.h"
#import "VoiceConverter.h"

#ifdef INCLUDE_MEIQIA_SDK
#import "MQManager.h"
#endif

static NSInteger const kMQChatMessageMaxTimeInterval = 60;

/** 一次获取历史消息数的个数 */
static NSInteger const kMQChatGetHistoryMessageNumber = 20;


#ifdef INCLUDE_MEIQIA_SDK
@interface MQChatViewModel() <MQMessageDelegate, MQCellModelDelegate>

@end
#else
@interface MQChatViewModel() <MQCellModelDelegate>

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
    [self reloadChatTableView];
#ifdef INCLUDE_MEIQIA_SDK
    [MQManager sendTextMessageWithContent:content delegate:self];
#else
    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendType = MQChatCellSended;
        [self reloadChatTableView];
    });
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
    [self reloadChatTableView];
#ifdef INCLUDE_MEIQIA_SDK
    [MQManager sendImageMessageWithImage:image delegate:self];
#else
    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendType = MQChatCellSended;
        [self reloadChatTableView];
    });
#endif
}

/**
 * 发送语音消息
 */
- (void)sendVoiceMessageWithAMRFilePath:(NSString *)filePath {
#ifdef INCLUDE_MEIQIA_SDK
    NSData *amrData = [NSData dataWithContentsOfFile:filePath];
    [MQManager sendAudioMessage:amrData delegate:self];
#else
    //将AMR格式转换成WAV格式，以便使iPhone能播放
    NSData *wavData = [self convertToWAVDataWithAMRFilePath:filePath];
    MQVoiceMessage *message = [[MQVoiceMessage alloc] initWithVoiceData:wavData];
    MQVoiceCellModel *cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self.cellModels addObject:cellModel];
    [self reloadChatTableView];

    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendType = MQChatCellSended;
        [self reloadChatTableView];
    });
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

/**
 * 判断两个时间间隔是否过大，如果过大，返回一个MessageDateCellModel
 */
- (void)generateMessageDateCellWithCurrentCellModel:(id<MQCellModelProtocol>)currentCellModel {
    id<MQCellModelProtocol> lastCellModel = [self getBussinessCellModelWithIndex:self.cellModels.count-1];
    NSDate *lastDate = lastCellModel ? [lastCellModel getCellDate] : [NSDate date];
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
 * 从cellModels中获取到业务相关的cellModel，即text, image, voice等；
 */
- (id<MQCellModelProtocol>)getBussinessCellModelWithIndex:(NSInteger)index {
    if (self.cellModels.count <= index) {
        return nil;
    }
    id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
    //判断获取到的cellModel是否是业务相关的cell，如果不是则继续往前取
    if ([cellModel isServiceRelatedCell]){
        return cellModel;
    }
    [self getBussinessCellModelWithIndex:index - 1];
    return nil;
}

/**
 * 通知viewController更新tableView；
 */
- (void)reloadChatTableView {
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(reloadChatTableView)]) {
            [self.delegate reloadChatTableView];
        }
    }
}

#ifndef INCLUDE_MEIQIA_SDK
/**
 * 使用MQChatViewControllerDemo的时候，调试用的方法，用于收取和上一个message一样的消息
 */
- (void)loadLastMessage {
    id<MQCellModelProtocol> lastCellModel = [self getBussinessCellModelWithIndex:self.cellModels.count-1];
    if (!lastCellModel) {
        [MQToast showToast:@"请输入一条消息，再收取消息~" duration:2 window:[UIApplication sharedApplication].keyWindow];
        return ;
    }
    ;
    if ([lastCellModel isKindOfClass:[MQTextCellModel class]]) {
        MQTextCellModel *textCellModel = (MQTextCellModel *)lastCellModel;
        MQTextMessage *message = [[MQTextMessage alloc] initWithContent:textCellModel.cellText];
        message.fromType = MQMessageIncoming;
        MQTextCellModel *newCellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
        [self.cellModels addObject:newCellModel];
    } else if ([lastCellModel isKindOfClass:[MQImageCellModel class]]) {
        MQImageCellModel *imageCellModel = (MQImageCellModel *)lastCellModel;
        MQImageMessage *message = [[MQImageMessage alloc] initWithImage:imageCellModel.image];
        message.fromType = MQMessageIncoming;
        MQImageCellModel *newCellModel = [[MQImageCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
        [self.cellModels addObject:newCellModel];
    } else if ([lastCellModel isKindOfClass:[MQVoiceCellModel class]]) {
        MQVoiceCellModel *voiceCellModel = (MQVoiceCellModel *)lastCellModel;
        MQVoiceMessage *message = [[MQVoiceMessage alloc] initWithVoiceData:voiceCellModel.voiceData];
        message.fromType = MQMessageIncoming;
        MQVoiceCellModel *newCellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
        [self.cellModels addObject:newCellModel];
    }
    [self reloadChatTableView];
}
#endif

#pragma MQCellModelDelegate
- (void)didUpdateCellDataWithMessageId:(NSString *)messageId {
    //获取又更新的cell的index
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (NSInteger index=0; index<self.cellModels.count; index++) {
            id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
            if ([[cellModel getCellMessageId] isEqualToString:messageId]) {
                //更新该cell
                [self updateCellWithIndex:index];
                break;
            }
        }
    });
}

//通知tableView更新该indexPath的cell
- (void)updateCellWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didUpdateCellWithIndexPath:)]) {
            [self.delegate didUpdateCellWithIndexPath:indexPath];
        }
    }
}

#pragma AMR to WAV转换
- (NSData *)convertToWAVDataWithAMRFilePath:(NSString *)amrFilePath {
    NSString *tempPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    tempPath = [tempPath stringByAppendingPathComponent:@"record.wav"];
    [VoiceConverter amrToWav:amrFilePath wavSavePath:tempPath];
    NSData *wavData = [NSData dataWithContentsOfFile:tempPath];
    [[NSFileManager defaultManager] removeItemAtPath:tempPath error:nil];
    return wavData;
}


@end
