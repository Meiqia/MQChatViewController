//
//  MQRecordView.h
//  MeChatSDK
//
//  Created by Injoy on 14/11/13.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQMessage.h"

@protocol MQRecordViewDelegate <NSObject>
//录音结束
-(void)recordOver:(MQMessage*)message;
@end

@interface MQRecordView : UIView

@property(nonatomic,strong) id<MQRecordViewDelegate> recordOverDelegate;
@property(nonatomic,assign) float marginBottom;
/** 是否显示撤回语音 */
@property(nonatomic,assign) BOOL revoke;

-(void)setupUI;

-(void)startRecording;
-(void)stopRecord;
-(void)revokeRecord;

@end
