//
//  MLAudioMeterObserver.m
//  MLRecorder
//
//  Created by molon on 5/13/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MEIQIA_MLAudioMeterObserver.h"

#define kDefaultRefreshInterval 0.1 //默认0.1秒刷新一次
#define kMLAudioMeterObserverErrorDomain @"MLAudioMeterObserverErrorDomain"

#define IfAudioQueueErrorPostAndReturn(operation,error) \
if(operation!=noErr) { \
[self postAErrorWithErrorCode:MLAudioMeterObserverErrorCodeAboutQueue andDescription:error]; \
return; \
}   \

@implementation MEIQIA_LevelMeterState
@end

@interface MEIQIA_MLAudioMeterObserver()

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSUInteger channelCount;

@end


@implementation MEIQIA_MLAudioMeterObserver

- (instancetype)init
{
    self = [super init];
    if (self) {
        //这里默认用_设置下吧。免得直接初始化了timer
        _refreshInterval = kDefaultRefreshInterval;
        self.channelCount = 1;
        //象征性的初始化一下
        _levelMeterStates = (AudioQueueLevelMeterState*)malloc(sizeof(AudioQueueLevelMeterState) * self.channelCount);
    }
    return self;
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
    
    free(_levelMeterStates);
    
	DLOG(@"MLAudioMeterObserver dealloc");
}

#pragma mark - setter and getter
- (void)setRefreshInterval:(NSTimeInterval)refreshInterval
{
    _refreshInterval = refreshInterval;
    
    //重置timer
    [self.timer invalidate];
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:refreshInterval
                  target:self
                  selector:@selector(refresh)
                  userInfo:nil
                  repeats:YES
                  ];
}

- (AudioQueueRef)audioQueue
{
	return _audioQueue;
}

- (void)setAudioQueue:(AudioQueueRef)audioQueue
{
    if (_audioQueue!=NULL&&audioQueue == _audioQueue){
        //一样的就无需再处理
        return;
    }
    
    //处理关闭定时器
    [self.timer invalidate];
    self.timer = nil;

    
    //根据新的音频队列重新初始化_levelMeterStates的内存块
    if (audioQueue==NULL){
        return;
    }
    
    _audioQueue = audioQueue;
    
    
    //检测这玩意是否支持光谱图
    UInt32 val = 1;
    IfAudioQueueErrorPostAndReturn(AudioQueueSetProperty(audioQueue, kAudioQueueProperty_EnableLevelMetering, &val, sizeof(UInt32)), @"couldn't enable metering");
    
    if (!val){
        DLOG(@"不支持光谱图"); //需要发送错误
        return;
    }
    
    // now check the number of channels in the new queue, we will need to reallocate if this has changed
    AudioStreamBasicDescription queueFormat;
    UInt32 data_sz = sizeof(queueFormat);
    IfAudioQueueErrorPostAndReturn(AudioQueueGetProperty(audioQueue, kAudioQueueProperty_StreamDescription, &queueFormat, &data_sz), @"couldn't get stream description");
    
    self.channelCount = queueFormat.mChannelsPerFrame;
    
    //重新初始化大小
    _levelMeterStates = (AudioQueueLevelMeterState*)realloc(_levelMeterStates, self.channelCount * sizeof(AudioQueueLevelMeterState));
    
    //重新设置timer
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:self.refreshInterval
                  target:self
                  selector:@selector(refresh)
                  userInfo:nil
                  repeats:YES
                  ];
}

- (void)refresh
{
    UInt32 data_sz = sizeof(AudioQueueLevelMeterState) * (int)self.channelCount;

    IfAudioQueueErrorPostAndReturn(AudioQueueGetProperty(_audioQueue, kAudioQueueProperty_CurrentLevelMeterDB, _levelMeterStates, &data_sz),@"获取meter数据失败");
    
    //转化成LevelMeterState数组传递到block
    NSMutableArray *meters = [NSMutableArray arrayWithCapacity:self.channelCount];
    
    for (int i=0; i<self.channelCount; i++)
    {
        MEIQIA_LevelMeterState *state = [[MEIQIA_LevelMeterState alloc]init];
        state.mAveragePower = _levelMeterStates[i].mAveragePower;
        state.mPeakPower = _levelMeterStates[i].mPeakPower;
        [meters addObject:state];
    }
    if(self.actionBlock){
        self.actionBlock(meters,self);
    }
}


- (void)postAErrorWithErrorCode:(MLAudioMeterObserverErrorCode)code andDescription:(NSString*)description
{
    self.audioQueue = nil;
    
    DLOG(@"监控音频队列光谱发生错误");
    
    NSError *error = [NSError errorWithDomain:kMLAudioMeterObserverErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:description}];
    
    if( self.errorBlock){
        self.errorBlock(error,self);
    }
}


+ (Float32)volumeForLevelMeterStates:(NSArray*)levelMeterStates
{
    
    Float32 averagePowerOfChannels = 0;
    for (int i=0; i<levelMeterStates.count; i++)
    {
        averagePowerOfChannels+=((MEIQIA_LevelMeterState*)levelMeterStates[i]).mAveragePower;
    }
    
    //获取音量百分比，姑且这么叫吧
    Float32 volume = pow(10, (0.05 * averagePowerOfChannels/levelMeterStates.count));
    
    
    return volume;
}

@end
