//
//  MQRecordView.m
//  MeChatSDK
//
//  Created by Injoy on 14/11/13.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import "MQRecordView.h"
#import "FBLCDFontView.h"
#import "MQImageUtil.h"
#import "MQChatFileUtil.h"
#import "MQToast.h"
#import "MQChatAudioRecorder.h"
#import "MQAssetUtil.h"

static CGFloat const kMQRecordViewDiameter = 150.0;

@interface MQRecordView()<MQChatAudioRecorderDelegate>

@end

@implementation MQRecordView
{
    UIView* blurView;
    UIView* recordView;
    UIImageView* volumeView;
    UILabel* tipLabel;
    FBLCDFontView *LCDView;
    
    UIImage* blurImage;
    BOOL isVisible;
    
    CGFloat recordTime; //录音时长
    NSTimer *recordTimer;
    MQChatAudioRecorder *audioRecorder;
    
}

-(instancetype)initWithFrame:(CGRect)frame maxRecordDuration:(NSTimeInterval)duration
{
    if (self = [super initWithFrame:frame]) {
        self.revoke = NO;
        self.layer.masksToBounds = YES;
        recordView = [[UIView alloc] init];
        recordView.layer.cornerRadius = 10;
        recordView.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
        
        blurView = [[UIView alloc] init];
        volumeView = [[UIImageView alloc] init];
        
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont boldSystemFontOfSize:14];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:blurView];
        [self addSubview:recordView];
        [recordView addSubview:volumeView];
        [recordView addSubview:tipLabel];
        
        audioRecorder = [[MQChatAudioRecorder alloc] initWithMaxRecordDuration:duration];
        audioRecorder.delegate = self;
    }
    return self;
}

-(void)setRevoke:(BOOL)revoke
{
    if (revoke != self.revoke) {
        if (revoke) {
            tipLabel.text = @"松开手指,取消发送";
            volumeView.image = [MQAssetUtil recordBackImage];
        }else{
            tipLabel.text = @"上滑手指,取消发送";
            volumeView.image = [MQAssetUtil recordVolume:0];
        }
    }
    _revoke = revoke;
}

-(void)setupUI
{
    recordView.frame = CGRectMake((self.frame.size.width - kMQRecordViewDiameter) / 2,
                                  (self.frame.size.height - kMQRecordViewDiameter) / 2,
                                  kMQRecordViewDiameter, kMQRecordViewDiameter);
    self.marginBottom = self.frame.size.height - recordView.frame.origin.y - recordView.frame.size.height;
    recordView.alpha = 0;
    
    tipLabel.text = @"上滑手指,取消发送";
    tipLabel.frame = CGRectMake(0, kMQRecordViewDiameter - 20 - 12, recordView.frame.size.width, 20);
    
    volumeView.frame = CGRectMake((recordView.frame.size.width - 58)/2, 16, 58, 90);
    volumeView.image = [MQAssetUtil recordVolume:0];
    
    [UIView animateWithDuration:.2 animations:^{
        recordView.alpha = 1;
    }];
}

- (void)reDisplayRecordView {
    self.hidden = NO;
    if ([recordView.superview isEqual:self]) [recordView removeFromSuperview];
    if ([blurView.superview isEqual:self]) [blurView removeFromSuperview];
    blurImage = [[MQImageUtil viewScreenshot:self.superview] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self addSubview:blurView];
    [self addSubview:recordView];
    blurView.frame = CGRectMake(0, 0, blurImage.size.width, blurImage.size.height);
    blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurView.layer.contents = (id)blurImage.CGImage;

    if (blurImage) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0L), ^{
            UIImage *blur = [MQImageUtil blurryImage:blurImage
                                       withBlurLevel:.2
                                       exclusionPath:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransition *transition = [CATransition animation];
                transition.duration = .2;
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                transition.type = kCATransitionFade;
                
                [blurView.layer addAnimation:transition forKey:nil];
                blurView.layer.contents = (id)blur.CGImage;
                
                [self setNeedsLayout];
                [self layoutIfNeeded];
            });
        });
    }
}

-(void)didMoveToSuperview
{
    if (!isVisible) {
        [self setupUI];
        isVisible = YES;
    }
}

-(void)startRecording
{
    recordTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recodTime) userInfo:nil repeats:YES];
    recordTime = 0;
    [audioRecorder beginRecording];
}

-(void)recodTime
{
    recordTime = recordTime + 0.1;
    if (recordTime >= 50) {
        volumeView.alpha = 0;
        if (LCDView) {
            [LCDView removeFromSuperview];
        }
        
        LCDView = [[FBLCDFontView alloc] initWithFrame:volumeView.frame];
        LCDView.lineWidth = 4.0;
        LCDView.drawOffLine = NO;
        LCDView.edgeLength = 30;
        LCDView.margin = 10.0;
        LCDView.backgroundColor = [UIColor clearColor];
        LCDView.horizontalPadding = 20;
        LCDView.verticalPadding = 14;
        LCDView.glowSize = 10.0;
        LCDView.glowColor = [UIColor whiteColor];
        LCDView.innerGlowColor = [UIColor grayColor];
        LCDView.innerGlowSize = 3.0;
        [recordView addSubview:LCDView];
        LCDView.text = [NSString stringWithFormat:@"%d",(int)(60 - recordTime)];
        [LCDView resetSize];
    }
    NSLog(@"recordView time = %f", recordTime);
}

-(void)setRecordingVolume:(float)volume
{
    if (!self.revoke) {
        if (volume > .66) {
            volumeView.image = [MQAssetUtil recordVolume:8];
        }else if (volume > .57){
            volumeView.image = [MQAssetUtil recordVolume:7];
        }else if (volume > .48){
            volumeView.image = [MQAssetUtil recordVolume:6];
        }else if (volume > .39){
            volumeView.image = [MQAssetUtil recordVolume:5];
        }else if (volume > .30){
            volumeView.image = [MQAssetUtil recordVolume:4];
        }else if (volume > .21){
            volumeView.image = [MQAssetUtil recordVolume:3];
        }else if (volume > .12){
            volumeView.image = [MQAssetUtil recordVolume:2];
        }else if (volume > .03){
            volumeView.image = [MQAssetUtil recordVolume:1];
        }else{
            volumeView.image = [MQAssetUtil recordVolume:0];
        }
    }
}

//组件终止录音
-(void)stopRecord
{
    [recordTimer invalidate];
    recordTimer = nil;
    if (recordTime < 1 && recordTime > 0) {
        [MQToast showToast:@"录音时间太短" duration:1 window:self.superview];
        [audioRecorder cancelRecording];
    } else {
        [audioRecorder finishRecording];
    }
    self.hidden = YES;
    recordTime = 0;
}

//取消录音
- (void)cancelRecording {
    [recordTimer invalidate];
    recordTimer = nil;
    self.hidden = YES;
    recordTime = 0;
    [audioRecorder cancelRecording];
}

-(void)revokerecord {
    self.hidden = YES;
}

-(void)recordError:(NSError*)error
{
    self.hidden = YES;
}

#pragma MQChatAudioRecorderDelegate
- (void)didFinishRecordingWithAMRFilePath:(NSString *)filePath {
    //通知viewController已完成录音
    if (self.recordViewDelegate) {
        if ([self.recordViewDelegate respondsToSelector:@selector(didFinishRecordingWithAMRFilePath:)]) {
            [self.recordViewDelegate didFinishRecordingWithAMRFilePath:filePath];
        }
    }
}

- (void)didUpdateAudioVolume:(Float32)volume {
    [self setRecordingVolume:volume];
}

- (void)didEndRecording {
    [self stopRecord];
}

- (void)didBeginRecording {
    
}

/** 更新frame */
- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    recordView.frame = CGRectMake((self.frame.size.width - kMQRecordViewDiameter) / 2,
                                  (self.frame.size.height - kMQRecordViewDiameter) / 2,
                                  kMQRecordViewDiameter, kMQRecordViewDiameter);

}

@end
