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
#import "MQAssetUtil.h"
#import "MQBundleUtil.h"

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
#ifdef INCLUDE_MEIQIA_SDK
    MQServiceToViewInterface *serviceToViewInterface;
    BOOL isThereNoAgent;   //用来判断当前是否没有客服
    BOOL addedNoAgentTip;  //是否已经说明了没有客服标记
#endif
}

- (instancetype)init {
    if (self = [super init]) {
        self.cellModels = [[NSMutableArray alloc] init];
#ifdef INCLUDE_MEIQIA_SDK
        [self setClientOnline];
        isThereNoAgent = false;
        addedNoAgentTip = false;
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
    NSDate *firstMessageDate = [self getFirstServiceCellModelDate];
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
- (NSDate *)getFirstServiceCellModelDate {
    for (NSInteger index = 0; index < self.cellModels.count; index++) {
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
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
    [self addMessageDateCellAtLastWithCurrentCellModel:cellModel];
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
    [self addMessageDateCellAtLastWithCurrentCellModel:cellModel];
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
    [self addMessageDateCellAtLastWithCurrentCellModel:cellModel];
    [self addCellModelAndReloadTableViewWithModel:cellModel];
#ifndef INCLUDE_MEIQIA_SDK
    //模仿发送成功
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cellModel.sendStatus = MQChatMessageSendStatusSuccess;
        [self reloadChatTableView];
    });
#endif
}

/**
 * 重新发送消息
 * @param index 需要重新发送的index
 * @param resendData 重新发送的字典 [text/image/voice : data]
 */
- (void)resendMessageAtIndex:(NSInteger)index resendData:(NSDictionary *)resendData {
    //通知逻辑层删除该message数据
#ifdef INCLUDE_MEIQIA_SDK
    NSString *messageId = [[self.cellModels objectAtIndex:index] getCellMessageId];
    [MQServiceToViewInterface removeMessageInDatabaseWithId:messageId completion:nil];
#endif
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
 *  在尾部增加cellModel之前，先判断两个时间间隔是否过大，如果过大，插入一个MessageDateCellModel
 *
 *  @param beAddedCellModel 准备被add的cellModel
 *  @return 是否插入了时间cell
 */
- (BOOL)addMessageDateCellAtLastWithCurrentCellModel:(id<MQCellModelProtocol>)beAddedCellModel {
    id<MQCellModelProtocol> lastCellModel = [self searchOneBussinessCellModelWithIndex:self.cellModels.count-1 isSearchFromBottomToTop:true];
    NSDate *lastDate = lastCellModel ? [lastCellModel getCellDate] : [NSDate date];
    NSDate *beAddedDate = [beAddedCellModel getCellDate];
    //判断被add的cell的时间比最后一个cell的时间是否要大（说明currentCell是第一个业务cell，此时显示时间cell）
    BOOL isLastDateLargerThanNextDate = lastDate.timeIntervalSince1970 > beAddedDate.timeIntervalSince1970;
    //判断被add的cell比最后一个cell的时间间隔是否超过阈值
    BOOL isDateTimeIntervalLargerThanThreshold = beAddedDate.timeIntervalSince1970 - lastDate.timeIntervalSince1970 >= kMQChatMessageMaxTimeInterval;
    if (!isLastDateLargerThanNextDate && !isDateTimeIntervalLargerThanThreshold) {
        return false;
    }
    MQMessageDateCellModel *cellModel = [[MQMessageDateCellModel alloc] initCellModelWithDate:beAddedDate cellWidth:self.chatViewWidth];
    [self.cellModels addObject:cellModel];
    return true;
}

/**
 *  在首部增加cellModel之前，先判断两个时间间隔是否过大，如果过大，插入一个MessageDateCellModel
 *
 *  @param beInsertedCellModel 准备被insert的cellModel
 *  @return 是否插入了时间cell
 */
- (BOOL)insertMessageDateCellAtFirstWithCellModel:(id<MQCellModelProtocol>)beInsertedCellModel {
    NSDate *firstDate = [NSDate date];
    if (self.cellModels.count == 0) {
        return false;
    }
    id<MQCellModelProtocol> firstCellModel = [self.cellModels objectAtIndex:0];
    if (![firstCellModel isServiceRelatedCell]) {
        return false;
    }
    NSDate *beInsertedDate = [beInsertedCellModel getCellDate];
    firstDate = [firstCellModel getCellDate];
    //判断被insert的Cell的date和第一个cell的date的时间间隔是否超过阈值
    BOOL isDateTimeIntervalLargerThanThreshold = firstDate.timeIntervalSince1970 - beInsertedDate.timeIntervalSince1970 >= kMQChatMessageMaxTimeInterval;
    if (!isDateTimeIntervalLargerThanThreshold) {
        return false;
    }
    MQMessageDateCellModel *cellModel = [[MQMessageDateCellModel alloc] initCellModelWithDate:firstDate cellWidth:self.chatViewWidth];
    [self.cellModels insertObject:cellModel atIndex:0];
    return true;
}

/**
 * 从后往前从cellModels中获取到业务相关的cellModel，即text, image, voice等；
 */
/**
 *  从cellModels中搜索第一个业务相关的cellModel，即text, image, voice等；
 *  @warning 业务相关的cellModel，必须满足协议方法isServiceRelatedCell
 *
 *  @param searchIndex             search的起始位置
 *  @param isSearchFromBottomToTop search的方向 YES：从后往前搜索  NO：从前往后搜索
 *
 *  @return 搜索到的第一个业务相关的cellModel
 */
- (id<MQCellModelProtocol>)searchOneBussinessCellModelWithIndex:(NSInteger)searchIndex isSearchFromBottomToTop:(BOOL)isSearchFromBottomToTop{
    if (self.cellModels.count <= searchIndex) {
        return nil;
    }
    id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:searchIndex];
    //判断获取到的cellModel是否是业务相关的cell，如果不是则继续往前取
    if ([cellModel isServiceRelatedCell]){
        return cellModel;
    }
    NSInteger nextSearchIndex = isSearchFromBottomToTop ? searchIndex - 1 : searchIndex + 1;
    [self searchOneBussinessCellModelWithIndex:nextSearchIndex isSearchFromBottomToTop:isSearchFromBottomToTop];
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
    id<MQCellModelProtocol> lastCellModel = [self searchOneBussinessCellModelWithIndex:self.cellModels.count-1 isSearchFromBottomToTop:true];
    if (lastCellModel) {
        if ([lastCellModel isKindOfClass:[MQTextCellModel class]]) {
            MQTextCellModel *textCellModel = (MQTextCellModel *)lastCellModel;
            MQTextMessage *message = [[MQTextMessage alloc] initWithContent:[textCellModel.cellText string]];
            message.fromType = MQChatMessageIncoming;
            MQTextCellModel *newCellModel = [[MQTextCellModel alloc] initCellModelWithMessage:message cellWidth:self.chatViewWidth delegate:self];
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
    }
    //text message
    MQTextMessage *textMessage = [[MQTextMessage alloc] initWithContent:@"Let's Rooooooooooock~"];
    textMessage.fromType = MQChatMessageIncoming;
    MQTextCellModel *textCellModel = [[MQTextCellModel alloc] initCellModelWithMessage:textMessage cellWidth:self.chatViewWidth delegate:self];
    [self.cellModels addObject:textCellModel];
    //image message
    MQImageMessage *imageMessage = [[MQImageMessage alloc] initWithImagePath:@"https://s3.cn-north-1.amazonaws.com.cn/pics.meiqia.bucket/65135e4c4fde7b5f"];
    imageMessage.fromType = MQChatMessageIncoming;
    MQImageCellModel *imageCellModel = [[MQImageCellModel alloc] initCellModelWithMessage:imageMessage cellWidth:self.chatViewWidth delegate:self];
    [self.cellModels addObject:imageCellModel];
    //tip message
//        MQTipsCellModel *tipCellModel = [[MQTipsCellModel alloc] initCellModelWithTips:@"主人，您的客服离线啦~" cellWidth:self.cellWidth enableLinesDisplay:true];
//        [self.cellModels addObject:tipCellModel];
    //voice message
    MQVoiceMessage *voiceMessage = [[MQVoiceMessage alloc] initWithVoicePath:@"http://7xiy8i.com1.z0.glb.clouddn.com/test.amr"];
    voiceMessage.fromType = MQChatMessageIncoming;
    MQVoiceCellModel *voiceCellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:voiceMessage cellWidth:self.chatViewWidth delegate:self];
    [self.cellModels addObject:voiceCellModel];
    
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
    if (![MQChatViewConfig sharedConfig].enableChatWelcome) {
        return ;
    }
    //消息时间
    MQMessageDateCellModel *dateCellModel = [[MQMessageDateCellModel alloc] initCellModelWithDate:[NSDate date] cellWidth:self.chatViewWidth];
    [self.cellModels addObject:dateCellModel];
    //欢迎消息
    MQTextMessage *welcomeMessage = [[MQTextMessage alloc] initWithContent:[MQChatViewConfig sharedConfig].chatWelcomeText];
    welcomeMessage.fromType = MQChatMessageIncoming;
    welcomeMessage.userName = [MQChatViewConfig sharedConfig].agentName;
    welcomeMessage.userAvatarImage = [MQChatViewConfig sharedConfig].incomingDefaultAvatarImage;
    welcomeMessage.sendStatus = MQChatMessageSendStatusSuccess;
    MQTextCellModel *cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:welcomeMessage cellWidth:self.chatViewWidth delegate:self];
    [self.cellModels addObject:cellModel];
    [self reloadChatTableView];
}

#pragma 点击了某个cell
- (void)didTapMessageCellAtIndex:(NSInteger)index {
    id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
    if ([cellModel isKindOfClass:[MQVoiceCellModel class]]) {
        MQVoiceCellModel *voiceCellModel = (MQVoiceCellModel *)cellModel;
        voiceCellModel.isPlayed = true;
#ifdef INCLUDE_MEIQIA_SDK
        [MQServiceToViewInterface didTapMessageWithMessageId:[cellModel getCellMessageId]];
#endif
    }
}

#pragma 播放声音
- (void)playReceivedMessageSound {
    if (![MQChatViewConfig sharedConfig].enableMessageSound) {
        return;
    }
    [MQChatFileUtil playSoundWithSoundFile:[MQAssetUtil resourceWithName:[MQChatViewConfig sharedConfig].incomingMsgSoundFileName]];
}

#pragma 开发者可将自定义的message添加到此方法中
/**
 *  将消息数组中的消息转换成cellModel，并添加到cellModels中去;
 *
 *  @param messages             消息实体array
 *  @param isInsertAtFirstIndex 是否将messages插入到顶部
 *
 *  @return 返回转换为cell的个数
 */
- (NSInteger)saveToCellModelsWithMessages:(NSArray *)messages isInsertAtFirstIndex:(BOOL)isInsertAtFirstIndex{
    NSInteger cellNumber = 0;
    NSMutableArray *historyMessages = [[NSMutableArray alloc] initWithArray:messages];
    if (isInsertAtFirstIndex) {
        //如果是历史消息，则将历史消息插入到cellModels的首部
        [historyMessages removeAllObjects];
        for (MQBaseMessage *message in messages) {
            [historyMessages insertObject:message atIndex:0];
        }
    }
    for (MQBaseMessage *message in historyMessages) {
        id<MQCellModelProtocol> cellModel;
        if ([message isKindOfClass:[MQTextMessage class]]) {
            cellModel = [[MQTextCellModel alloc] initCellModelWithMessage:(MQTextMessage *)message cellWidth:self.chatViewWidth delegate:self];
        } else if ([message isKindOfClass:[MQImageMessage class]]) {
            cellModel = [[MQImageCellModel alloc] initCellModelWithMessage:(MQImageMessage *)message cellWidth:self.chatViewWidth delegate:self];
        } else if ([message isKindOfClass:[MQVoiceMessage class]]) {
            cellModel = [[MQVoiceCellModel alloc] initCellModelWithMessage:(MQVoiceMessage *)message cellWidth:self.chatViewWidth delegate:self];
        } else if ([message isKindOfClass:[MQEventMessage class]]) {
            MQEventMessage *eventMessage = (MQEventMessage *)message;
            if (eventMessage.eventType == MQChatEventTypeInviteEvaluation) {
                if (!isInsertAtFirstIndex) {
                    //如果收到新评价消息，且当前不是正在录音状态，则显示评价 alertView
                    if (self.delegate) {
                        if ([self.delegate respondsToSelector:@selector(showEvaluationAlertView)] && [self.delegate respondsToSelector:@selector(isChatRecording)]) {
                            if (![self.delegate isChatRecording]) {
                                [self.delegate showEvaluationAlertView];
                            }
                        }
                    }
                }
            } else if (eventMessage.eventType == MQChatEventTypeClientEvaluation) {

            } else if ([MQChatViewConfig sharedConfig].enableEventDispaly) {
                if (eventMessage.eventType == MQChatEventTypeAgentInputting) {
                    if (self.delegate) {
                        if ([self.delegate respondsToSelector:@selector(showToastViewWithContent:)]) {
                            [self.delegate showToastViewWithContent:@"客服正在输入..."];
                        }
                    }
                } else {
                    cellModel = [[MQEventCellModel alloc] initCellModelWithMessage:eventMessage cellWidth:self.chatViewWidth];
                }
            }
        }
        if (cellModel) {
            if (isInsertAtFirstIndex) {
                BOOL isInsertDateCell = [self insertMessageDateCellAtFirstWithCellModel:cellModel];
                if (isInsertDateCell) {
                    cellNumber ++;
                }
                [self.cellModels insertObject:cellModel atIndex:0];
                cellNumber ++;
            } else {
                BOOL isAddDateCell = [self addMessageDateCellAtLastWithCurrentCellModel:cellModel];
                if (isAddDateCell) {
                    cellNumber ++;
                }
                [self.cellModels addObject:cellModel];
                cellNumber ++;
            }
        }
    }
    [self reloadChatTableView];
    return cellNumber;
}

/**
 *  发送用户评价
 */
- (void)sendEvaluationLevel:(NSInteger)level comment:(NSString *)comment {
    //生成评价结果的 cell
    NSString *levelText = @"好评";
    UIColor *levelColor = [UIColor colorWithRed:0.0/255.0 green:206.0/255.0 blue:125.0/255.0 alpha:1];
    switch (level) {
        case 0:
            levelText = @"差评";
            levelColor = [UIColor colorWithRed:255.0/255.0 green:92.0/255.0 blue:94.0/255.0 alpha:1];
            break;
        case 1:
            levelText = @"中评";
            levelColor = [UIColor colorWithRed:255.0/255.0 green:182.0/255.0 blue:82.0/255.0 alpha:1];
            break;
        case 2:
            levelText = @"好评";
            levelColor = [UIColor colorWithRed:0.0/255.0 green:206.0/255.0 blue:125.0/255.0 alpha:1];
            break;
        default:
            break;
    }
    [self showEvaluationCellWithText:levelText color:levelColor];
#ifdef INCLUDE_MEIQIA_SDK
    [MQServiceToViewInterface setEvaluationLevel:level comment:comment];
#endif
}

//显示用户评价的 cell
- (void)showEvaluationCellWithText:(NSString *)levelText color:(UIColor *)levelColor{
    NSRange attribuitedRange = NSMakeRange(5, levelText.length);
    levelText = [NSString stringWithFormat:@"你给出了 %@", levelText];
    NSDictionary<NSString *, id> *tipExtraAttributes = @{
                                                         NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:13],
                                                         NSForegroundColorAttributeName : levelColor
                                                         };
    MQTipsCellModel *cellModel = [[MQTipsCellModel alloc] initCellModelWithTips:levelText cellWidth:self.chatViewWidth enableLinesDisplay:false];
    cellModel.tipExtraAttributesRange = attribuitedRange;
    cellModel.tipExtraAttributes = tipExtraAttributes;
    [self.cellModels addObject:cellModel];
    [self reloadChatTableView];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(scrollTableViewToBottom)]) {
            [self.delegate scrollTableViewToBottom];
        }
    }
}

- (void)addTipCellModelWithTips:(NSString *)tips enableLinesDisplay:(BOOL)enableLinesDisplay {
    MQTipsCellModel *cellModel = [[MQTipsCellModel alloc] initCellModelWithTips:tips cellWidth:self.chatViewWidth enableLinesDisplay:enableLinesDisplay];
    [self.cellModels addObject:cellModel];
    [self reloadChatTableView];
}

#ifdef INCLUDE_MEIQIA_SDK

#pragma 顾客上线的逻辑
- (void)setClientOnline {
    //上线
    __weak __typeof(self) weakSelf = self;
    serviceToViewInterface = [[MQServiceToViewInterface alloc] init];
    [MQServiceToViewInterface setScheduledAgentWithAgentId:[MQChatViewConfig sharedConfig].scheduledAgentId agentGroupId:[MQChatViewConfig sharedConfig].scheduledGroupId scheduleRule:[MQChatViewConfig sharedConfig].scheduleRule];
    if ([MQChatViewConfig sharedConfig].MQClientId.length == 0 && [MQChatViewConfig sharedConfig].customizedId.length > 0) {
        [serviceToViewInterface setClientOnlineWithCustomizedId:[MQChatViewConfig sharedConfig].customizedId success:^(BOOL completion, NSString *agentName, NSArray *receivedMessages) {
            if (!completion) {
                //没有分配到客服
                agentName = [MQBundleUtil localizedStringForKey: agentName && agentName.length>0 ? agentName : @"no_agent_title"];
            }
            //获取顾客信息
            [weakSelf getClientInfo];
            //更新客服聊天界面标题
            [weakSelf updateChatTitleWithAgentName:agentName];
            if (receivedMessages) {
                [weakSelf saveToCellModelsWithMessages:receivedMessages isInsertAtFirstIndex:false];
                if (weakSelf.delegate) {
                    if ([weakSelf.delegate respondsToSelector:@selector(scrollTableViewToBottom)]) {
                        [weakSelf.delegate scrollTableViewToBottom];
                    }
                }
            }
        } receiveMessageDelegate:self];
        return;
    }
    [serviceToViewInterface setClientOnlineWithClientId:[MQChatViewConfig sharedConfig].MQClientId success:^(BOOL completion, NSString *agentName, NSArray *receivedMessages) {
        if (!completion) {
            //没有分配到客服
            agentName = [MQBundleUtil localizedStringForKey: agentName && agentName.length>0 ? agentName : @"no_agent_title"];
            [weakSelf.delegate hideRightBarButtonItem:YES];
        }else{
            [weakSelf.delegate hideRightBarButtonItem:NO];
        }
        //获取顾客信息
        [weakSelf getClientInfo];
        //更新客服聊天界面标题
        [weakSelf updateChatTitleWithAgentName:agentName];
        if (receivedMessages) {
            [weakSelf saveToCellModelsWithMessages:receivedMessages isInsertAtFirstIndex:false];
            if (weakSelf.delegate) {
                if ([weakSelf.delegate respondsToSelector:@selector(scrollTableViewToBottom)]) {
                    [weakSelf.delegate scrollTableViewToBottom];
                }
            }
        }
    } receiveMessageDelegate:self];
}

//获取顾客信息
- (void)getClientInfo {
    NSDictionary *clientInfo = [MQServiceToViewInterface getCurrentClientInfo];
    if ([[clientInfo objectForKey:@"avatar"] length] == 0) {
        return ;
    }
    [MQServiceToViewInterface downloadMediaWithUrlString:[clientInfo objectForKey:@"avatar"] progress:^(float progress) {
    } completion:^(NSData *mediaData, NSError *error) {
        [MQChatViewConfig sharedConfig].outgoingDefaultAvatarImage = [UIImage imageWithData:mediaData];
    }];
}

- (void)updateChatTitleWithAgentName:(NSString *)agentName {
    NSString *viewTitle = agentName;
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didScheduleClientWithViewTitle:)]) {
            [self.delegate didScheduleClientWithViewTitle:viewTitle];
        }
    }
}

- (void)addSystemTips{
    if (!isThereNoAgent) {
        return;
    }
    isThereNoAgent = false;
    if (!addedNoAgentTip) {
        addedNoAgentTip = true;
        [self addTipCellModelWithTips:[MQBundleUtil localizedStringForKey:@"no_agent_tips"] enableLinesDisplay:true];
    }
}

#pragma MQServiceToViewInterfaceDelegate
- (void)didReceiveHistoryMessages:(NSArray *)messages {
    NSInteger cellNumber = 0;
    NSInteger messageNumber = 0;
    if (messages.count > 0) {
        cellNumber = [self saveToCellModelsWithMessages:messages isInsertAtFirstIndex:true];
        messageNumber = messages.count;
    }
    //如果没有获取更多的历史消息，则也需要通知界面取消刷新indicator
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didGetHistoryMessagesWithCellNumber:isLoadOver:)]) {
            [self.delegate didGetHistoryMessagesWithCellNumber:cellNumber isLoadOver:messageNumber < kMQChatGetHistoryMessageNumber];
        }
    }
}

- (void)didReceiveNewMessages:(NSArray *)messages {
    if (messages.count == 0) {
        return;
    }
    //转换message to cellModel，并缓存
    [self saveToCellModelsWithMessages:messages isInsertAtFirstIndex:false];
    //eventMessage不响铃声
    if (messages.count > 1 || ![[messages firstObject] isKindOfClass:[MQEventMessage class]]) {
        [self playReceivedMessageSound];
    }
    //更新界面title
    [self updateChatTitleWithAgentName:[MQServiceToViewInterface getCurrentAgentName]];
    //通知界面收到了消息
    BOOL isRefreshView = true;
    if (![MQChatViewConfig sharedConfig].enableEventDispaly && [[messages firstObject] isKindOfClass:[MQEventMessage class]]) {
        isRefreshView = false;
    } else {
        if (messages.count == 1 && [[messages firstObject] isKindOfClass:[MQEventMessage class]]) {
            MQEventMessage *eventMessage = [messages firstObject];
            if (eventMessage.eventType == MQChatEventTypeAgentInputting) {
                isRefreshView = false;
            }
        }
    }
    //等待 0.1 秒，等待 tableView 更新后再滑动到底部，优化体验
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.delegate && isRefreshView) {
            if ([self.delegate respondsToSelector:@selector(didReceiveMessage)]) {
                [self.delegate didReceiveMessage];
            }
        }
    });
}

- (void)didReceiveTipsContent:(NSString *)tipsContent {
    MQTipsCellModel *cellModel = [[MQTipsCellModel alloc] initCellModelWithTips:tipsContent cellWidth:self.chatViewWidth enableLinesDisplay:true];
    [self addCellModelAfterReceivedWithCellModel:cellModel];
}

- (void)addCellModelAfterReceivedWithCellModel:(id<MQCellModelProtocol>)cellModel {
    [self addMessageDateCellAtLastWithCurrentCellModel:cellModel];
    [self didReceiveMessageWithCellModel:cellModel];
}

- (void)didReceiveMessageWithCellModel:(id<MQCellModelProtocol>)cellModel {
    [self addCellModelAndReloadTableViewWithModel:cellModel];
    [self playReceivedMessageSound];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(didReceiveMessage)]) {
            [self.delegate didReceiveMessage];
        }
    }
}

- (void)didRedirectWithAgentName:(NSString *)agentName {
    [self updateChatTitleWithAgentName:agentName];
}

- (void)didSendMessageWithNewMessageId:(NSString *)newMessageId
                          oldMessageId:(NSString *)oldMessageId
                        newMessageDate:(NSDate *)newMessageDate
                            sendStatus:(MQChatMessageSendStatus)sendStatus
{
    //如果新的messageId和旧的messageId不同，且是发送成功状态，则表明肯定是分配成功的
    if (![newMessageId isEqualToString:oldMessageId] && sendStatus == MQChatMessageSendStatusSuccess) {
        NSString *agentName = [MQServiceToViewInterface getCurrentAgentName];
        isThereNoAgent = ![MQServiceToViewInterface isThereAgent];
        if (agentName.length > 0) {
            [self updateChatTitleWithAgentName:agentName];
        }
    } else {
        isThereNoAgent = true;
    }
    if (isThereNoAgent) {
        [self.delegate hideRightBarButtonItem:YES];
        [self addSystemTips];
        [self updateChatTitleWithAgentName:[MQBundleUtil localizedStringForKey:@"no_agent_title"]];
    }else{
        //显示评价按钮
        [self.delegate hideRightBarButtonItem:NO];
    }
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCellWithIndex:index];
    });
}

/**
 *  刷新所有的本机用户的头像
 */
- (void)refreshOutgoingAvatarWithImage:(UIImage *)avatarImage {
    for (NSInteger index=0; index<self.cellModels.count; index++) {
        id<MQCellModelProtocol> cellModel = [self.cellModels objectAtIndex:index];
        if ([cellModel respondsToSelector:@selector(updateOutgoingAvatarImage:)]) {
            [cellModel updateOutgoingAvatarImage:avatarImage];
        }
    }
    [self reloadChatTableView];
}

#endif

@end
