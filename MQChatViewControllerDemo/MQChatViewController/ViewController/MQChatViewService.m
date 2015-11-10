//
//  MQChatViewService.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//


#import "MQChatViewService.h"
#import "MQTextMessage.h"
#import "MQImageMessage.h"
#import "MQVoiceMessage.h"
#import "MQTextCellModel.h"
#import "MQImageCellModel.h"
#import "MQVoiceCellModel.h"
#import "MQTipsCellModel.h"
#import "MQMessageDateCellModel.h"
#import <UIKit/UIKit.h>
#import "MQToast.h"
#import "VoiceConverter.h"
#import "MQEventCellModel.h"

static NSInteger const kMQChatMessageMaxTimeInterval = 60;

/** 一次获取历史消息数的个数 */
static NSInteger const kMQChatGetHistoryMessageNumber = 20;


#ifdef INCLUDE_MEIQIA_SDK
@interface MQChatViewService() <MQServiceToViewInterfaceDelegate, MQCellModelDelegate>

@end
#else
@interface MQChatViewService() <MQCellModelDelegate>

@end
#endif

@implementation MQChatViewService {
    
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellModels = [[NSMutableArray alloc] init];
#ifdef INCLUDE_MEIQIA_SDK
        [self setClientOnline];
#endif
    }
    return self;
}

#pragma 增加cellModel并刷新tableView
- (void)addCellModelAndReloadTableViewWithModel:(id<MQCellModelProtocol>)cellModel {
    [self.cellModels addObject:cellModel];
    [self reloadChatTableView];
}

/**
 * 获取更多历史聊天消息
 */
- (void)startGettingHistoryMessages {
#ifdef INCLUDE_MEIQIA_SDK
    NSDate *firstMessageDate = [self getServiceCellModelDate];
    if ([MQChatViewConfig sharedConfig].enableSyncServerMessage) {
        [MQServiceToViewInterface getServerHistoryMessagesWithMsgDate:firstMessageDate messagesNumber:kMQChatGetHistoryMessageNumber successDelegate:self errorDelegate:self.errorDelegate];
    } else {
        [MQServiceToViewInterface getDatabaseHistoryMessagesWithMsgDate:firstMessageDate messagesNumber:kMQChatGetHistoryMessageNumber delegate:self];
    }
#endif
}

/**
 *  获取最旧的cell的日期，例如text/image/voice等
 */
- (NSDate *)getServiceCellModelDate {
    for (NSInteger index = self.cellModels.count - 1; index >= 0; index--) {
        id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
#pragma 开发者可在下面添加自己更多的业务cellModel，以便能正确获取历史消息
        if ([cellModel isKindOfClass:[MQTextCellModel class]] ||
            [cellModel isKindOfClass:[MQImageCellModel class]] ||
            [cellModel isKindOfClass:[MQVoiceCellModel class]] ||
            [cellModel isKindOfClass:[MQEventCellModel class]]) {
            return [cellModel getCellDate];
        }
    }
    return [NSDate date];
}

/**
 * 发送文字消息
 */
- (void)sendTextMessageWithContent:(NSString *)content {
    MQTextMessage *message = [[MQTextMessage alloc] initWithContent:content];
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
#ifdef INCLUDE_MEIQIA_SDK
    [MQServiceToViewInterface sendTextMessageWithContent:content messageId:message.messageId delegate:self];
#else
    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendStatus = MQChatMessageSendStatusSuccess;
        [self reloadChatTableView];
    });
#endif
    
}

/**
 * 发送图片消息
 */
- (void)sendImageMessageWithImage:(UIImage *)image {
    MQImageMessage *message = [[MQImageMessage alloc] initWithImage:image];
    MQImageCellModel *cellModel = [[MQImageCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
#ifdef INCLUDE_MEIQIA_SDK
    [MQServiceToViewInterface sendImageMessageWithImage:image messageId:message.messageId delegate:self];
#else
    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendStatus = MQChatMessageSendStatusSuccess;
        [self reloadChatTableView];
    });
#endif
}

/**
 * 以AMR格式语音文件的形式，发送语音消息
 * @param filePath AMR格式的语音文件
 */
- (void)sendVoiceMessageWithAMRFilePath:(NSString *)filePath {
    //将AMR格式转换成WAV格式，以便使iPhone能播放
    NSData *wavData = [self convertToWAVDataWithAMRFilePath:filePath];
    MQVoiceMessage *message = [[MQVoiceMessage alloc] initWithVoiceData:wavData];
    [self sendVoiceMessageWithWAVData:wavData voiceMessage:message];
#ifdef INCLUDE_MEIQIA_SDK
    NSData *amrData = [NSData dataWithContentsOfFile:filePath];
    [MQServiceToViewInterface sendAudioMessage:amrData messageId:message.messageId delegate:self];
#endif
}

/**
 * 以WAV格式语音数据的形式，发送语音消息
 * @param wavData WAV格式的语音数据
 */
- (void)sendVoiceMessageWithWAVData:(NSData *)wavData voiceMessage:(MQVoiceMessage *)message{
    MQVoiceCellModel *cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
    [self generateMessageDateCellWithCurrentCellModel:cellModel];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendStatus = MQChatMessageSendStatusSuccess;
        [self reloadChatTableView];
    });
}

/**
 * 重新发送消息
 * @param index 需要重新发送的index
 * @param resendData 重新发送的字典 [text/image/voice : data]
 */
- (void)resendMessageAtIndex:(NSInteger)index resendData:(NSDictionary *)resendData {
    [self.cellModels removeObjectAtIndex:index];
    //判断删除这个model的之前的model是否为date，如果是，则删除时间cellModel
    if (index < 0 || self.cellModels.count <= index-1) {
        return;
    }
    id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index-1];
    if (cellModel && [cellModel isKindOfClass:[MQMessageDateCellModel class]]) {
        [self.cellModels removeObjectAtIndex:index-1];
    }
    //重新发送
    if (resendData[@"text"]) {
        [self sendTextMessageWithContent:resendData[@"text"]];
    }
    if (resendData[@"image"]) {
        [self sendImageMessageWithImage:resendData[@"image"]];
    }
    if (resendData[@"voice"]) {
        [self sendVoiceMessageWithAMRFilePath:resendData[@"voice"]];
    }
}

/**
 * 发送“用户正在输入”的消息
 */
- (void)sendUserInputtingWithContent:(NSString *)content {
#ifdef INCLUDE_MEIQIA_SDK
    [MQServiceToViewInterface sendClientInputtingWithContent:content];
#endif
}

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
    if ([lastCellModel isKindOfClass:[MQTextCellModel class]]) {
        MQTextCellModel *textCellModel = (MQTextCellModel *)lastCellModel;
        MQTextMessage *message = [[MQTextMessage alloc] initWithContent:textCellModel.cellText];
        message.fromType = MQChatMessageIncoming;
        MQTextCellModel *newCellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
        [self.cellModels addObject:newCellModel];
    } else if ([lastCellModel isKindOfClass:[MQImageCellModel class]]) {
        MQImageCellModel *imageCellModel = (MQImageCellModel *)lastCellModel;
        MQImageMessage *message = [[MQImageMessage alloc] initWithImage:imageCellModel.image];
        message.fromType = MQChatMessageIncoming;
        MQImageCellModel *newCellModel = [[MQImageCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
        [self.cellModels addObject:newCellModel];
    } else if ([lastCellModel isKindOfClass:[MQVoiceCellModel class]]) {
        MQVoiceCellModel *voiceCellModel = (MQVoiceCellModel *)lastCellModel;
        MQVoiceMessage *message = [[MQVoiceMessage alloc] initWithVoiceData:voiceCellModel.voiceData];
        message.fromType = MQChatMessageIncoming;
        MQVoiceCellModel *newCellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
        [self.cellModels addObject:newCellModel];
    }
    //text message
    MQTextMessage *textMessage = [[MQTextMessage alloc] initWithContent:@"测试测试kjdjfkadsjlfkadfasdkf"];
    textMessage.fromType = MQChatMessageIncoming;
    MQTextCellModel *textCellModel = [[MQTextCellModel alloc] initCellModelWithMessage:textMessage cellWidth:self.chatViewWidth];
    [self.cellModels addObject:textCellModel];
    //image message
//    MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:@"https://s3.cn-north-1.amazonaws.com.cn/pics.meiqia.bucket/65135e4c4fde7b5f"];
//    imageMessage.fromType = MQChatMessageIncoming;
//    MQImageCellModel *imageCellModel = [[MQImageCellModel alloc] initCellModelWithMessage:imageMessage cellWidth:self.chatViewWidth delegate:self];
//    [self.cellModels addObject:imageCellModel];
    //tip message
    MQTipsCellModel *tipCellModel = [[MQTipsCellModel alloc] initCellModelWithTips:@"主人，您的客服离线啦~" cellWidth:self.chatViewWidth];
    [self.cellModels addObject:tipCellModel];

    [self reloadChatTableView];
    [self playReceivedMessageSound];
}
#endif

#pragma MQCellModelDelegate
- (void)didUpdateCellDataWithMessageId:(NSString *)messageId {
    //获取又更新的cell的index
    NSInteger index = [self getIndexOfCellWithMessageId:messageId];
    if (index < 0) {
        return;
    }
    [self updateCellWithIndex:index];
}

- (NSInteger)getIndexOfCellWithMessageId:(NSString *)messageId {
    for (NSInteger index=0; index<self.cellModels.count; index++) {
        id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
        if ([[cellModel getCellMessageId] isEqualToString:messageId]) {
            //更新该cell
            return index;
        }
    }
    return -1;
}

//通知tableView更新该indexPath的cell
- (void)updateCellWithIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didUpdateCellModelWithIndexPath:)]) {
            [self.delegate didUpdateCellModelWithIndexPath:indexPath];
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

#pragma 更新cellModel中的frame
- (void)updateCellModelsFrame {
    for (id<MQCellModelProtocol> cellModel in self.cellModels) {
        [cellModel updateCellFrameWithCellWidth:self.chatViewWidth];
    }
}

#pragma 欢迎语
- (void)sendLocalWelcomeChatMessage {
    if (![MQChatViewConfig sharedConfig].enableWelcomeChat) {
        return ;
    }
    //消息时间
    MQMessageDateCellModel *dateCellModel = [[MQMessageDateCellModel alloc] initCellModelWithDate:[NSDate date] cellWidth:self.chatViewWidth];
    [self.cellModels addObject:dateCellModel];
    //欢迎消息
    MQTextMessage *welcomeMessage = [[MQTextMessage alloc] initWithContent:[MQChatViewConfig sharedConfig].chatWelcomeText];
    welcomeMessage.fromType = MQChatMessageIncoming;
    welcomeMessage.userName = [MQChatViewConfig sharedConfig].agentName;
    welcomeMessage.userAvatarImage = [MQChatViewConfig sharedConfig].agentDefaultAvatarImage;
    welcomeMessage.sendStatus = MQChatMessageSendStatusSuccess;
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:welcomeMessage cellWidth:self.chatViewWidth];
    [self.cellModels addObject:cellModel];
    [self reloadChatTableView];
}

#pragma 播放声音
- (void)playReceivedMessageSound {
    if (![MQChatViewConfig sharedConfig].enableMessageSound) {
        return;
    }
    [MQChatFileUtil playSoundWithSoundFile:[MQChatViewConfig sharedConfig].incomingMsgSoundFileName];
}

#pragma 开发者可将自定义的message添加到此方法中
//将消息数组中的消息转换成cellModel，并添加到cellModels中去
- (void)addMessagesToTableViewWithMessages:(NSArray *)messages {
    for (MQBaseMessage *message in messages) {
        id<MQCellModelProtocol> cellModel;
        if ([message isKindOfClass:[MQTextMessage class]]) {
            cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:(MQTextMessage *)message cellWidth:self.chatViewWidth];
        } else if ([message isKindOfClass:[MQImageMessage class]]) {
            cellModel = [[MQImageCellModel alloc] initCellModelWithMessage:(MQImageMessage *)message cellWidth:self.chatViewWidth delegate:self];
        } else if ([message isKindOfClass:[MQVoiceMessage class]]) {
            cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:(MQVoiceMessage *)message cellWidth:self.chatViewWidth delegate:self];
        } else if ([MQChatViewConfig sharedConfig].enableEventDispaly && [message isKindOfClass:[MQEventMessage class]]) {
            cellModel = [[MQEventCellModel alloc] initCellModelWithMessage:(MQEventMessage *)message cellWidth:self.chatViewWidth];
        }
        if (cellModel) {
            [self.cellModels addObject:cellModel];
        }
    }
    [self reloadChatTableView];
}

#ifdef INCLUDE_MEIQIA_SDK
#pragma 顾客上线的逻辑
- (void)setClientOnline {
    [MQServiceToViewInterface setClientOnlineWithSuccess:^(BOOL completion) {
    } receiveMessageDelegate:self];
}

#pragma MQServiceToViewInterfaceDelegate
- (void)didReceiveHistoryMessages:(NSArray *)messages totalNum:(NSInteger)totalNum {
    if (totalNum > 0) {
        [self addMessagesToTableViewWithMessages:messages];
    }
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didGetHistoryMessagesWithMessagesNumber:)]) {
            [self.delegate didGetHistoryMessagesWithMessagesNumber:totalNum];
        }
    }
}

- (void)didReceiveTextMessage:(MQTextMessage *)message {
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    [self playReceivedMessageSound];
}

- (void)didReceiveImageMessage:(MQImageMessage *)message {
    MQImageCellModel *cellModel = [[MQImageCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    [self playReceivedMessageSound];
}

- (void)didReceiveVoiceMessage:(MQVoiceMessage *)message {
    MQVoiceCellModel *cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    [self playReceivedMessageSound];
}

- (void)didReceiveEventMessage:(MQEventMessage *)eventMessage {
    if (![MQChatViewConfig sharedConfig].enableEventDispaly) {
        return;
    }
    MQEventCellModel *cellModel = [[MQEventCellModel alloc] initCellModelWithMessage:eventMessage cellWidth:self.chatViewWidth];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    [self playReceivedMessageSound];
}

- (void)didReceiveTipsContent:(NSString *)tipsContent {
    MQTipsCellModel *cellModel = [[MQTipsCellModel alloc] initCellModelWithTips:tipsContent cellWidth:self.chatViewWidth];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    [self playReceivedMessageSound];
}

- (void)didSendMessageWithNewMessageId:(NSString *)newMessageId
                          oldMessageId:(NSString *)oldMessageId
                        newMessageDate:(NSDate *)newMessageDate
                            sendStatus:(MQChatMessageSendStatus)sendStatus
{
    NSInteger index = [self getIndexOfCellWithMessageId:oldMessageId];
    if (index < 0) {
        return;
    }
    id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
    [cellModel updateCellMessageId:newMessageId];
    [cellModel updateCellSendStatus:sendStatus];
    if (newMessageDate) {
        [cellModel updateCellMessageDate:newMessageDate];
    }
}

#endif

@end
