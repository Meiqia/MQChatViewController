//
//  MQRecordView.h
//  MeChatSDK
//
//  Created by Injoy on 14/11/13.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MQMessage.h"

@protocol MQRecordViewDelegate <NSObject>

/** 通知viewController完成录音 */
- (void)didFinishRecordingWithAMRFilePath:(NSString *)filePath;

@end

@interface MQRecordView : UIView

@property(nonatomic,weak) id<MQRecordViewDelegate> recordViewDelegate;
@property(nonatomic,assign) float marginBottom;
/** 是否显示撤回语音 */
@property(nonatomic,assign) BOOL revoke;

-(void)setupUI;

-(void)startRecording;
-(void)stopRecord;
-(void)revokeRecord;
- (void)reDisplayRecordView;
/** 语音音量的大小设置 */
-(void)setRecordingVolume:(float)volume;
//取消录音
- (void)cancelRecording;
@end
