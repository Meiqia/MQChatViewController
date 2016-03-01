//
//  MLAudioMeterObserver.h
//  MLRecorder
//
//  Created by molon on 5/13/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MEIQIA_AMR_Debug.h"

@class MEIQIA_MLAudioMeterObserver;

typedef void (^MLAudioMeterObserverActionBlock)(NSArray *levelMeterStates,MEIQIA_MLAudioMeterObserver *meterObserver);
typedef void (^MLAudioMeterObserverErrorBlock)(NSError *error,MEIQIA_MLAudioMeterObserver *meterObserver);

/**
 *  错误标识
 */
typedef NS_OPTIONS(NSUInteger, MLAudioMeterObserverErrorCode) {
    MLAudioMeterObserverErrorCodeAboutQueue, //关于音频输入队列的错误
};



@interface MEIQIA_LevelMeterState : NSObject

@property (nonatomic, assign) Float32 mAveragePower;
@property (nonatomic, assign) Float32 mPeakPower;

@end

@interface MEIQIA_MLAudioMeterObserver : NSObject
{
    AudioQueueRef				_audioQueue;
	AudioQueueLevelMeterState	*_levelMeterStates;
}

@property AudioQueueRef audioQueue;

@property (nonatomic, copy) MLAudioMeterObserverActionBlock actionBlock;

@property (nonatomic, copy) MLAudioMeterObserverErrorBlock errorBlock;


@property (nonatomic, assign) NSTimeInterval refreshInterval; //刷新间隔,默认0.1

/**
 *  根据meterStates计算出音量，音量为 0-1
 *
 */
+ (Float32)volumeForLevelMeterStates:(NSArray*)levelMeterStates;

@end
