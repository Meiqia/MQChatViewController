//
//  MQCustomizedUIText.h
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/26.
//  Copyright © 2016年 Meiqia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MQUITextKey) {
    
    MQUITextKeyMessageInputPlaceholder,
    MQUITextKeyMessageNoMoreMessage,
    MQUITextKeyMessageNewMessaegArrived,
    MQUITextKeyMessageConfirmResend,
    MQUITextKeyMessageRefreshFail,
    MQUITextKeyMessageLoadHistoryMessageFail,
    
    MQUITextKeyRecordButtonBegin,
    MQUITextKeyRecordButtonEnd,
    MQUITextKeyRecordButtonCancel,
    MQUITextKeyRecordDurationTooShort,
    MQUITextKeyRecordSwipeUpToCancel,
    MQUITextKeyRecordReleaseToCancel,
    MQUITextKeyRecordFail,
    
    MQUITextKeyImageSelectFromImageRoll,
    MQUITextKeyImageSelectCamera,
    MQUITextKeyImageSaveFail,
    MQUITextKeyImageSaveComplete,
    MQUITextKeyImageSave,
    
    MQUITextKeyTextCopy,
    MQUITextKeyTextCopied,
    
    MQUITextKeyNetworkTrafficJam,
    MQUITextKeyDefaultAssistantName,
    
    MQUITextKeyNoAgentTitle,
    MQUITextKeySchedulingAgent,
    MQUITextKeyNoAgentTip,
    
    MQUITextKeyContactMakeCall,
    MQUITextKeyContactSendSMS,
    MQUITextKeyContactSendEmail,
    
    MQUITextKeyOpenLinkWithSafari,
    
    MQUITextKeyRequestEvaluation,
    
    MQUITextKeyFileDownloadOverdue,
    MQUITextKeyFileDownloadCancel,
    MQUITextKeyFileDownloadDownloading,
    MQUITextKeyFileDownloadComplete,
    MQUITextKeyFileDownloadFail,
    
    MQUITextKeyBlacklistMessageRejected,
    MQUITextKeyBlacklistListedInBlacklist,
};

@interface MQCustomizedUIText : NSObject

///自定义 UI 中的文案
+ (void)setCustomiedTextForKey:(MQUITextKey)key text:(NSString *)string;

+ (void)reset;

+ (NSString *)customiedTextForBundleKey:(NSString *)bundleKey;

@end
