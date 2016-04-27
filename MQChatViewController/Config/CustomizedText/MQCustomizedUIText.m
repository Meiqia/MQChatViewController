//
//  MQCustomizedUIText.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/26.
//  Copyright © 2016年 Meiqia. All rights reserved.
//

#import "MQCustomizedUIText.h"

static NSDictionary * keyTextMap;
static NSMutableDictionary * customizedTextMap;

@implementation MQCustomizedUIText

+ (void)load {
    keyTextMap = @{
        @(MQUITextKeyMessageInputPlaceholder) : @"new_message",
        @(MQUITextKeyMessageNoMoreMessage) : @"no_more_messages",
        @(MQUITextKeyMessageNewMessaegArrived) : @"display_new_message",
        @(MQUITextKeyMessageConfirmResend) : @"retry_send_message",
        @(MQUITextKeyMessageRefreshFail) : @"cannot_refresh",
        @(MQUITextKeyMessageLoadHistoryMessageFail) : @"load_history_message_error",
        
        @(MQUITextKeyRecordButtonBegin) : @"record_speak",
        @(MQUITextKeyRecordButtonEnd) : @"record_end",
        @(MQUITextKeyRecordButtonCancel) : @"cancel",
        @(MQUITextKeyRecordDurationTooShort) : @"recode_time_too_short",
        @(MQUITextKeyRecordSwipeUpToCancel) : @"record_cancel_swipe",
        @(MQUITextKeyRecordReleaseToCancel) : @"record_cancel_realse",
        @(MQUITextKeyRecordFail) : @"record_error",
        
        @(MQUITextKeyImageSelectFromImageRoll) : @"select_gallery",
        @(MQUITextKeyImageSelectCamera) : @"select_camera",
        @(MQUITextKeyImageSaveFail) : @"save_photo_error",
        @(MQUITextKeyImageSaveComplete) : @"save_photo_success",
        @(MQUITextKeyImageSave) : @"save_photo",
        
        @(MQUITextKeyTextCopy) : @"save_text",
        @(MQUITextKeyTextCopied) : @"save_text_success",
        
        @(MQUITextKeyNetworkTrafficJam) : @"network_jam",
        
        @(MQUITextKeyDefaultAssistantName) : @"default_assistant",
        
        @(MQUITextKeyNoAgentTitle) : @"no_agent_title",
        @(MQUITextKeySchedulingAgent) : @"wait_agent",
        @(MQUITextKeyNoAgentTip) : @"no_agent_tips",
        
        @(MQUITextKeyContactMakeCall) : @"make_call_to",
        @(MQUITextKeyContactSendSMS) : @"send_message_to",
        @(MQUITextKeyContactSendEmail) : @"make_email_to",
        
        @(MQUITextKeyOpenLinkWithSafari) : @"open_url_by_safari",
        
        @(MQUITextKeyRequestEvaluation) : @"meiqia_evaluation_sheet",
        
        @(MQUITextKeyFileDownloadOverdue) : @"file_download_file_is_expired",
        @(MQUITextKeyFileDownloadCancel) : @"file_download_canceld",
        @(MQUITextKeyFileDownloadFail) : @"file_download_failed",
        @(MQUITextKeyFileDownloadDownloading) : @"file_download_downloading",
        @(MQUITextKeyFileDownloadComplete) : @"file_download_complete",
        
        @(MQUITextKeyBlacklistMessageRejected) : @"message_tips_send_message_fail_listed_in_black_list",
        @(MQUITextKeyBlacklistListedInBlacklist) : @"message_tips_online_failed_listed_in_black_list",
        };
    
    customizedTextMap = [NSMutableDictionary new];
}

+ (void)setCustomiedTextForKey:(MQUITextKey)key text:(NSString *)string {
    [customizedTextMap setObject:string forKey:[keyTextMap objectForKey:@(key)]];
}

+ (void)reset {
    [customizedTextMap removeAllObjects];
}

+ (NSString *)customiedTextForBundleKey:(NSString *)bundleKey {
    return [customizedTextMap objectForKey:bundleKey];
}

@end
