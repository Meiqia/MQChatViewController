//
//  MQRecrodView.h
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

@interface MQRecrodView : UIView

@property(nonatomic,strong) id<MQRecordViewDelegate> recordOverDelegate;
@property(nonatomic,assign) float marginBottom;
@property(nonatomic,assign) BOOL revoke;

-(void)setupUI;

//-(void)startRecording:(id<MCMessageDelegate>)delegate;
-(void)stopRecord;
-(void)revokeRecrod;

@end
