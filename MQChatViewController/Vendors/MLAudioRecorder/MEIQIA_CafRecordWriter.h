//
//  CafRecordWriter.h
//  MLAudioRecorder
//
//  Created by molon on 5/12/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MEIQIA_MLAudioRecorder.h"

@interface MEIQIA_CafRecordWriter : NSObject<FileWriterForMLAudioRecorder>

@property (nonatomic, copy) NSString *filePath;

@end
