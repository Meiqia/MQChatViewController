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
+ (NSString*)resourceWithName:(NSString*)fileName
{
    return [NSString stringWithFormat:@"MQChatViewBundle.bundle/%@",fileName];
}

+ (BOOL)fileExistsAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:_path];
}

+ (BOOL)deleteFileAtPath:(NSString*)_path
{
    return [[NSFileManager defaultManager] removeItemAtPath:_path error:nil];
}

+(float)audioDuration:(NSString*)filePath
{
    return [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:filePath] error:nil].duration;
}

@end
