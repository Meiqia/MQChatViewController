//
//  MQChatFileUtil.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatFileUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation MQChatFileUtil

+ (BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL)isDirectory
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
}

+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}

+(float)audioDuration:(NSString*)filePath
{
    return [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil].duration;
}

/** 获取音频长度 */
+ (NSTimeInterval)getAudioDurationWithData:(NSData *)audioData {
    NSError *error;
    AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
    if (audioPlayer.duration) {
        return audioPlayer.duration;
    } else {
        return 0;
    }
}

+ (void)playSoundWithSoundFile:(NSString *)fileName {
//    NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileName];
//    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:false];

    
    NSURL *filePath = [NSURL fileURLWithPath:fileName isDirectory:false];
    SystemSoundID soundID;
    
    OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    if (error) {
        NSLog(@"无法创建SystemSoundID");
    }
    else {
        AudioServicesPlaySystemSound(soundID);
    }
}

+ (BOOL)saveFileWithName:(NSString *)fileName data:(NSData *)data {
    if (![self fileExistsAtPath:DIR_RECEIVED_FILE isDirectory:YES]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:DIR_RECEIVED_FILE withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *path = [DIR_RECEIVED_FILE stringByAppendingString:fileName];
    return [data writeToFile:path atomically:YES];
}

+ (id)getFileWithName:(NSString *)fileName {
    NSString *path = [DIR_RECEIVED_FILE stringByAppendingString:fileName];
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (error) {
        NSLog(@"FAIL TO READ FILE: %@ \n error:%@",path, error);
    }
    return data;
}

@end
