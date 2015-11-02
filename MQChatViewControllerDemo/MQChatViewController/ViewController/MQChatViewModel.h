//
//  MQChatViewModel.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQBaseMessage.h"
#import <UIKit/UIKit.h>
//是否是调试SDK
//#define INCLUDE_MEIQIA_SDK

@protocol MQChatViewModelDelegate <NSObject>

/**
 *  获取到了更多历史消息
 */
- (void)didGetHistoryMessages;

/**
 *  已经更新了这条消息的数据，通知tableView刷新界面
 */
- (void)didUpdateCellWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  通知viewController更新tableView；
 */
- (void)reloadChatTableView;


@end

/**
 * @brief 聊天界面的ViewModel
 *
 * MQChatViewModel管理者MQChatViewController中的数据
 */
@interface MQChatViewModel : NSObject 

/** MQChatViewModel的委托 */
@property (nonatomic, weak) id<MQChatViewModelDelegate>delegate;

/** cellModel的缓存 */
@property (nonatomic, strong) NSMutableArray *cellModels;

/** 聊天界面的宽度 */
@property (nonatomic, assign) CGFloat chatViewWidth;

/**
 * 获取更多历史聊天消息
 */
- (void)startGettingHistoryMessages;

/**
 * 发送文字消息
 */
- (void)sendTextMessageWithContent:(NSString *)content;

/**
 * 发送图片消息
 */
- (void)sendImageMessageWithImage:(UIImage *)image;

/**
 * 发送语音消息
 */
- (void)sendVoiceMessageWithAMRFilePath:(NSString *)filePath;

/**
 * 发送“用户正在输入”的消息
 */
- (void)sendUserInputtingWithContent:(NSString *)content;

#ifndef INCLUDE_MEIQIA_SDK
/**
 * 使用MQChatViewControllerDemo的时候，调试用的方法，用于收取和上一个message一样的消息
 */
- (void)loadLastMessage;
#endif

@end
