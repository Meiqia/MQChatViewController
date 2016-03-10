//
//  AmrRecordWriter.h
//  MLAudioRecorder
//
//  Created by molon on 5/12/14.
//  Copyright (c) 2014 molon. All rights reserved.
//
/**
 *  采样率必须为8000，然后缓冲区秒数必须为0.02的倍数。
 *
 */
#import <Foundation/Foundation.h>

#import "MEIQIA_MLAudioRecorder.h"

@interface MEIQIA_AmrRecordWriter : NSObject<FileWriterForMLAudioRecorder>

@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, assign) unsigned long maxFileSize;
@property (nonatomic, assign) double maxSecondCount;

@end
