//
//  CafRecordWriter.m
//  MLAudioRecorder
//
//  Created by molon on 5/12/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "MEIQIA_CafRecordWriter.h"

@interface MEIQIA_CafRecordWriter()
{
    AudioFileID mRecordFile;
    SInt64 recordPacketCount;
}

@end

@implementation MEIQIA_CafRecordWriter


- (BOOL)createFileWithRecorder:(MEIQIA_MLAudioRecorder*)recoder
{
    //建立文件
    recordPacketCount = 0;
    
    CFURLRef url = CFURLCreateWithString(kCFAllocatorDefault, (CFStringRef)self.filePath, NULL);
    OSStatus err = AudioFileCreateWithURL(url, kAudioFileCAFType, (const AudioStreamBasicDescription	*)(&(recoder->_recordFormat)), kAudioFileFlags_EraseFile, &mRecordFile);
    CFRelease(url);
    
    return err==noErr;
}

- (BOOL)writeIntoFileWithData:(NSData*)data withRecorder:(MEIQIA_MLAudioRecorder*)recoder inAQ:(AudioQueueRef)						inAQ inStartTime:(const AudioTimeStamp *)inStartTime inNumPackets:(UInt32)inNumPackets inPacketDesc:(const AudioStreamPacketDescription*)inPacketDesc
{
    OSStatus err = AudioFileWritePackets(mRecordFile, FALSE, (UInt32)data.length,
                                         inPacketDesc, recordPacketCount, &inNumPackets, data.bytes);
    if (err!=noErr) {
        return NO;
    }
    recordPacketCount += inNumPackets;
    
    return YES;
}

- (BOOL)completeWriteWithRecorder:(MEIQIA_MLAudioRecorder*)recoder withIsError:(BOOL)isError
{
    if (mRecordFile) {
        AudioFileClose(mRecordFile);
    }
    
    
    //    NSData *data = [[NSData alloc]initWithContentsOfFile:self.filePath];
    //    DLOG(@"文件长度%ld",data.length);
    
    return YES;
}

-(void)dealloc
{
    if (mRecordFile) {
        AudioFileClose(mRecordFile);
    }
}
@end
