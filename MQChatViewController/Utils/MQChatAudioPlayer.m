//
//  MQChatAudioPlayer.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/2.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQChatAudioPlayer.h"
#import <UIKit/UIKit.h>
#import "MQChatViewConfig.h"

@interface MQChatAudioPlayer()<AVAudioPlayerDelegate>

@end

@implementation MQChatAudioPlayer

+ (MQChatAudioPlayer *)sharedInstance
{
    static MQChatAudioPlayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)playSongWithUrl:(NSString *)songUrl
{
    //开启红外线
    dispatch_async(dispatch_queue_create("playSoundFromUrl", NULL), ^{
        [self.delegate MQAudioPlayerBeiginLoadVoice];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:songUrl]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self playSoundWithData:data];
        });
    });
}

-(void)playSongWithData:(NSData *)songData
{
    [self setupPlaySound];
    [self playSoundWithData:songData];
}

-(void)playSoundWithData:(NSData *)soundData{
    if (_player) {
        [_player stop];
        _player.delegate = nil;
        _player = nil;
    }
    NSError *playerError;
    _player = [[AVAudioPlayer alloc]initWithData:soundData error:&playerError];
    _player.volume = 1.0f;
    if (_player == nil){
        NSLog(@"ERror creating player: %@", [playerError description]);
    }
    _player.delegate = self;
    [_player play];
    [self.delegate MQAudioPlayerBeiginPlay];
}

-(void)setupPlaySound{
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopSound) name:UIApplicationDidEnterBackgroundNotification object:app];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback withOptions:(AVAudioSessionCategoryOptions)self.playMode error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    
    //接收关闭声音的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioPlayerDidInterrupt:) name:MQAudioPlayerDidInterruptNotification object:nil];
    //红外线感应监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sensorStateChange:)
                                                 name:UIDeviceProximityStateDidChangeNotification
                                               object:nil];
    
    //开启红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self didFinishAudioPlay];
    NSLog(@"audioPlayerDidFinishPlaying");
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    NSLog(@"audioPlayerBeginInterruption");
    [self.player pause];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
    NSLog(@"audioPlayerEndInterruption");
    [self.player play];
}

- (void)stopSound
{
    [self didFinishAudioPlay];
}

- (void)removeAudioObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application{
    [self didFinishAudioPlay];
    NSLog(@"recording interrupted");
}

//音频播放结束
- (void)didFinishAudioPlay {
    if (_player && _player.isPlaying) {
        [_player stop];
    }
    [self removeAudioObserver];
    [self.delegate MQAudioPlayerDidFinishPlay];
    
    if (!self.keepSessionActive) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

//声音播放被打断的通知
- (void)audioPlayerDidInterrupt:(NSNotification *)notification {
    [self didFinishAudioPlay];
    NSLog(@"recording interrupted by other voice playment");
}

@end
