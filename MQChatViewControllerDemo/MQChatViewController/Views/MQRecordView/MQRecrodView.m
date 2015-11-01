//
//  MQRecrodView.m
//  MeChatSDK
//
//  Created by Injoy on 14/11/13.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import "MQRecrodView.h"
#import "FBLCDFontView.h"
#import "MQImageUtil.h"
#import "MQChatFileUtil.h"
#import "MQToast.h"

@implementation MQRecrodView
{
    UIView* blurView;
    UIView* recrodView;
    UIImageView* volumeView;
    UILabel* tipLabel;
    FBLCDFontView *LCDView;
    
    UIImage* blurImage;
    BOOL isVisible;
    
//    MQMessage* message;
    
    int recrodTime; //录音时长
    NSTimer *recrodTimer;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        recrodView = [[UIView alloc] init];
        recrodView.layer.cornerRadius = 10;
        recrodView.backgroundColor = [UIColor colorWithWhite:0 alpha:.8];
        
        blurView = [[UIView alloc] init];
        volumeView = [[UIImageView alloc] init];
        
        tipLabel = [[UILabel alloc] init];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        tipLabel.font = [UIFont boldSystemFontOfSize:14];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:blurView];
        [self addSubview:recrodView];
        [recrodView addSubview:volumeView];
        [recrodView addSubview:tipLabel];
    }
    return self;
}

-(void)setRevoke:(BOOL)revoke
{
    if (revoke != self.revoke) {
        if (revoke) {
            tipLabel.text = @"松开手指,取消发送";
//            volumeView.image = [UIImage imageNamed:[MCUitl jointResource:@"record_back"]];
        }else{
            tipLabel.text = @"上滑手指,取消发送";
        }
    }
    _revoke = revoke;
}

-(void)setupUI
{
    if ([recrodView.superview isEqual:self]) [recrodView removeFromSuperview];
    if ([blurView.superview isEqual:self]) [blurView removeFromSuperview];
    
    blurImage = [[MQImageUtil viewScreenshot:self.superview] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self addSubview:blurView];
    [self addSubview:recrodView];
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

    float recrodViewWH = 150;
    recrodView.frame = CGRectMake((self.frame.size.width - recrodViewWH) / 2,
                                  (self.frame.size.height - recrodViewWH) / 2,
                                  recrodViewWH, recrodViewWH);
    self.marginBottom = self.frame.size.height - recrodView.frame.origin.y - recrodView.frame.size.height;
    recrodView.alpha = 0;
    
    tipLabel.text = @"上滑手指,取消发送";
    tipLabel.frame = CGRectMake(0, recrodViewWH - 20 - 12, recrodView.frame.size.width, 20);
    
    volumeView.frame = CGRectMake((recrodView.frame.size.width - 58)/2, 16, 58, 90);
    volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record0"]];
    
    [UIView animateWithDuration:.2 animations:^{
        recrodView.alpha = 1;
    }];
}

-(void)didMoveToSuperview
{
    if (!isVisible) {
        [self setupUI];
        isVisible = YES;
    }
}

//-(void)startRecording:(id<MCMessageDelegate>)delegate
//{
//    message = [MCCore startRecordingAndSendAudioMessage:(id)self delegate:delegate];
//    recrodTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(recodTime) userInfo:nil repeats:YES];
//    recrodTime = 0;
//}

-(void)recodTime
{
    recrodTime++;
    if (recrodTime >= 50) {
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
        [recrodView addSubview:LCDView];
        LCDView.text = [NSString stringWithFormat:@"%i",60 - recrodTime - 1];
        [LCDView resetSize];
    }
}

-(void)recordingInVolume:(float)volume
{
    if (!self.revoke) {
        if (volume > .66) {
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record8"]];
        }else if (volume > .57){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record7"]];
        }else if (volume > .48){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record6"]];
        }else if (volume > .39){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record5"]];
        }else if (volume > .30){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record4"]];
        }else if (volume > .21){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record3"]];
        }else if (volume > .12){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record2"]];
        }else if (volume > .03){
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record1"]];
        }else{
            volumeView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"record0"]];
        }
    }
}

//用户取消录音
-(void)stopRecord
{
//    [MCCore stopRecordingAudioMessage];
    [recrodTimer invalidate];
    recrodTimer = nil;
}

//组件终止录音
-(void)recordStop
{
    [recrodTimer invalidate];
    recrodTimer = nil;
//    if (![MQFileUtil fileExistsAtPath:message.content] || [MQFileUtil audioDuration:message.content] < .5) {
//        [MQToast showToast:@"录音时间太短" duration:1 window:self.superview];
//        [self removeFromSuperview];
//        return;
//    }
    
//    if (self.recordOverDelegate && [self.recordOverDelegate respondsToSelector:@selector(recordOver:)]) {
//        [self.recordOverDelegate recordOver:message];
//    }
    [self removeFromSuperview];
}

-(void)revokeRecrod
{
//    [MCCore cancelSendAudioMessage];
    [self removeFromSuperview];
}

-(void)recordError:(NSError*)error
{
//    [self.recordOverDelegate recordOver:message];
    [self removeFromSuperview];
}

-(void)removeFromSuperview
{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @1.;
    opacityAnimation.toValue = @0.;
    opacityAnimation.duration = .1;
    [blurView.layer addAnimation:opacityAnimation forKey:nil];
    blurView.layer.opacity = 0;
    
    [UIView animateWithDuration:.2 animations:^{
        recrodView.alpha = 0;
    }];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(opacityAnimation.duration * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [super removeFromSuperview];
    });
    
    isVisible = NO;
}

@end
