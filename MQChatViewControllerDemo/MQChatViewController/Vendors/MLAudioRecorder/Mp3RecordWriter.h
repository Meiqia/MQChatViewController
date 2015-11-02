//
//  Mp3RecordWriter.h
//  MLRecorder
//
//  Created by molon on 5/13/14.
//  Copyright (c) 2014 molon. All rights reserved.
//
/**
 *  一般使用采样率 8000 缓冲区秒数为0.5
 *  暂时现在的lame库不支持arm64，所以工程里的设置arch为$(ARCHS_STANDARD_32_BIT)
 */
#import <Foundation/Foundation.h>

#import "MLAudioRecorder.h"
@interface Mp3RecordWriter : NSObject<FileWriterForMLAudioRecorder>

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, assign) unsigned long maxFileSize;
@property (nonatomic, assign) double maxSecondCount;

@end
