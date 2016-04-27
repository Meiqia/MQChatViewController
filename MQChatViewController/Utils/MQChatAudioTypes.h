//
//  AudioTypes.h
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/19.
//  Copyright © 2016年 Meiqia. All rights reserved.
//

#ifndef AudioTypes_h
#define AudioTypes_h


#endif /* AudioTypes_h */

#import <AVFoundation/AVFoundation.h>

///控制声音播放的模式
typedef NS_ENUM(NSUInteger, MQPlayMode) {
    MQPlayModePauseOther = 0, //暂停其他音频
    MQPlayModeMixWithOther = AVAudioSessionCategoryOptionMixWithOthers, //和其他音频同时播放
    MQPlayModeDuckOther = AVAudioSessionCategoryOptionDuckOthers //降低其他音频的声音
};


///控制声音录制的模式
typedef NS_ENUM(NSUInteger, MQRecordMode) {
    MQRecordModePauseOther = 0, //暂停其他音频
    MQRecordModeMixWithOther = AVAudioSessionCategoryOptionMixWithOthers, //和其他音频同时播放
    MQRecordModeDuckOther = AVAudioSessionCategoryOptionDuckOthers //降低其他音频的声音
};