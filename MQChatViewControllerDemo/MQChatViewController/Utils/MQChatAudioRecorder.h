//
//  MQChatAudioRecorder.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/2.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MQChatAudioRecorderDelegate <NSObject>

/**
 * 完成录音的回调
 * @param filePath AMR数据格式的音频数据的文件
 */
- (void)didFinishRecordingWithAMRFilePath:(NSString *)filePath;

/** 
 * 音频音量有更新
 * @param volume 音量
 */
- (void)didUpdateAudioVolume:(Float32)volume;

/**
 * 录音开始的回调
 */
- (void)didBeginRecording;

/**
 * 录音结束的回调
 */
- (void)didEndRecording;

@end

@interface MQChatAudioRecorder : NSObject

@property (nonatomic ,weak) id<MQChatAudioRecorderDelegate> delegate;

- (void)beginRecording;

- (void)finishRecording;

- (void)cancelRecording;

- (instancetype)initWithMaxRecordDuration:(NSTimeInterval)duration;

@end
