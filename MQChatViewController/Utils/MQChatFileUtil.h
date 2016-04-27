//
//  MQChatFileUtil.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DIR_RECEIVED_FILE [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/received_files/"]

@interface MQChatFileUtil : NSObject

//判断文件是否存在
+ (BOOL)fileExistsAtPath:(NSString*)path isDirectory:(BOOL)isDirectory;

//删除文件
+ (BOOL)deleteFileAtPath:(NSString *)_path;

+(float)audioDuration:(NSString *)filePath;

/** 获取音频长度 */
+ (NSTimeInterval)getAudioDurationWithData:(NSData *)audioData;

/**
 *  播放文件的声音
 *
 *  @param fileName 声音文件名字
 */
+ (void)playSoundWithSoundFile:(NSString *)fileName;

+ (BOOL)saveFileWithName:(NSString *)fileName data:(NSData *)data;

+ (id)getFileWithName:(NSString *)fileName;

@end
