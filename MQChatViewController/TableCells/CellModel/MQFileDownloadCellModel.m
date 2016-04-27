//
//  MQFileDownloadCellModel.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/6.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQFileDownloadCellModel.h"
#import "MQFileDownloadMessage.h"
#import "MQChatFileUtil.h"
#import "MQFileDownloadCell.h"
#import "MQServiceToViewInterface.h"
#import "MQBundleUtil.h"
#import "MQToast.h"

@interface MQFileDownloadCellModel()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) MQFileDownloadMessage *message;
@property (nonatomic, strong) UIDocumentInteractionController *interactionController;
@property (nonatomic, copy) NSString *downloadingURL;

@end

@implementation MQFileDownloadCellModel

- (id)initCellModelWithMessage:(MQFileDownloadMessage *)message cellWidth:(CGFloat)cellWidth delegate:(id<MQCellModelDelegate>)delegator {
    if (self = [super init]) {
        self.message = message;
        if ([MQChatFileUtil fileExistsAtPath:[self savedFilePath] isDirectory:NO]) {
            self.fileDownloadStatus = MQFileDownloadStatusDownloadComplete;
        }
        self.fileName = message.fileName;
        self.fileSize = [self fileSizeStringWithFileSize:(CGFloat)message.fileSize];
        if (message.expireDate.timeIntervalSinceReferenceDate > [NSDate new].timeIntervalSinceReferenceDate) {
            self.timeBeforeExpire = [NSString stringWithFormat:@"%.1f",(message.expireDate.timeIntervalSinceReferenceDate - [NSDate new].timeIntervalSinceReferenceDate) / 3600];
            self.isExpired = NO;
        } else {
            self.timeBeforeExpire = @"";
            self.isExpired = YES;
        }
        
        __weak typeof(self)wself = self;
        [MQServiceToViewInterface downloadMediaWithUrlString:message.userAvatarPath progress:nil completion:^(NSData *mediaData, NSError *error) {
            if (mediaData) {
                __strong typeof (wself) sself = wself;
                sself.avartarImage = [UIImage imageWithData:mediaData];
                if (sself.avatarLoaded) {
                    sself.avatarLoaded(sself.avartarImage);
                }
            }
        }];
    }
    return self;
}

- (NSString *)fileSizeStringWithFileSize:(CGFloat)fileSize {
    NSString *fileSizeString = [NSString stringWithFormat:@"%.1f MB", fileSize / 1024 / 1024];
    
    if (fileSizeString.floatValue < 1) {
        fileSizeString = [NSString stringWithFormat:@"%.1f KB", fileSize / 1024];
    }
    
    if (fileSizeString.floatValue < 1) {
        fileSizeString = [NSString stringWithFormat:@"%.0f B", fileSize];
    }
    
    return fileSizeString;
}

- (void)requestForFileURLComplete:(void(^)(NSString *url))action {
    BOOL isURLReady = NO;
    if ([self.message.filePath length] > 0) {
        isURLReady = YES;
        action(self.message.filePath);
    }
    
    //用于统计
    [MQServiceToViewInterface clientDownloadFileWithMessageId:self.message.messageId conversatioId:self.message.conversationId andCompletion:^(NSString *url, NSError *error) {
        if (!isURLReady) {
            action(url);
        }
    }];
}

- (void)startDownloadWitchProcess:(void(^)(CGFloat process))block {
    
    if (!block) {
        return;
    }
    
    if (self.isExpired) {
        [MQToast showToast:[MQBundleUtil localizedStringForKey:@"file_download_file_is_expired"] duration:2 window:[UIApplication sharedApplication].keyWindow];
        return;
    }
    
    self.fileDownloadStatus = MQFileDownloadStatusDownloading;
    if (self.needsToUpdateUI) {
        self.needsToUpdateUI();
    }
    block(0);
    
    [self requestForFileURLComplete:^(NSString *url) {
        url = [url stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        self.downloadingURL = url;
       [MQServiceToViewInterface downloadMediaWithUrlString:url progress:^(float progress) {
           self.fileDownloadStatus = MQFileDownloadStatusDownloading;
           block(progress);
       } completion:^(NSData *mediaData, NSError *error) {
           self.downloadingURL = nil;
           if (!error) {
               self.fileDownloadStatus = MQFileDownloadStatusDownloadComplete;
               self.file = mediaData;
               [self saveFile:mediaData];
               block(100);
           } else {
               [MQToast showToast:[NSString stringWithFormat:@"%@ %@",[MQBundleUtil localizedStringForKey:@"file_download_failed"],error.localizedDescription] duration:2 window:[UIApplication sharedApplication].keyWindow];
               self.fileDownloadStatus = MQFileDownloadStatusNotDownloaded;
               block(-1);
           }
       }];
    }];
}

- (void)cancelDownload {
    [MQToast showToast:[MQBundleUtil localizedStringForKey:@"file_download_canceld"] duration:2 window:[UIApplication sharedApplication].keyWindow];
    [MQServiceToViewInterface cancelDownloadForUrl:self.downloadingURL];
    self.downloadingURL = nil;
    self.fileDownloadStatus = MQFileDownloadStatusNotDownloaded;
    if (self.needsToUpdateUI) {
        self.needsToUpdateUI();
    }
}

- (void)openFile:(UIView *)sender {
    NSLog(@"open file");
    NSURL *url = [NSURL fileURLWithPath:[self savedFilePath]];
    self.interactionController = [UIDocumentInteractionController interactionControllerWithURL:url];
    [self.interactionController setDelegate:self];
    [self.interactionController presentOptionsMenuFromRect:CGRectZero inView:sender.superview animated:YES];
}

#pragma mark - private

- (NSString *)savedFilePath {
    return [DIR_RECEIVED_FILE stringByAppendingString:[self persistenceFileName]];
}

- (void)saveFile:(NSData *)data {
    [MQChatFileUtil saveFileWithName:[self persistenceFileName] data:data];
}

- (NSString *)persistenceFileName {
    NSString *fileName = [NSString stringWithFormat:@"%@-%@",self.message.messageId, self.message.fileName];
    return fileName;
}

#pragma mark - delegate

- (CGFloat)getCellHeight {
    if (self.cellHeight) {
        return self.cellHeight();
    }
    return 80;
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQFileDownloadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (NSDate *)getCellDate {
    return self.message.date;
}

- (BOOL)isServiceRelatedCell {
    return true;
}

- (NSString *)getCellMessageId {
    return self.message.messageId;
}

- (void)updateCellSendStatus:(MQChatMessageSendStatus)sendStatus {
    self.message.sendStatus = sendStatus;
}

- (void)updateCellMessageId:(NSString *)messageId {
    self.message.messageId = messageId;
}

- (void)updateCellMessageDate:(NSDate *)messageDate {
    self.message.date = messageDate;
}

- (void)updateCellFrameWithCellWidth:(CGFloat)cellWidth {
    if (self.needsToUpdateUI) {
        self.needsToUpdateUI();
    }
}

@end
