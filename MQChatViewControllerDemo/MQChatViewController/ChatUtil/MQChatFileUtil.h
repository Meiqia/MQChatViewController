//
//  MQChatFileUtil.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQChatFileUtil : NSObject

+ (NSString *)resourceWithName:(NSString*)fileName;

//判断文件是否存在
+ (BOOL)fileExistsAtPath:(NSString *)_path;

//删除文件
+ (BOOL)deleteFileAtPath:(NSString *)_path;

+(float)audioDuration:(NSString *)filePath;

/** 获取音频长度 */
+ (NSTimeInterval)getAudioDurationWithData:(NSData *)audioData;

@end
