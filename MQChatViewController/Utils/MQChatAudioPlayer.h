//
//  MQChatAudioPlayer.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/2.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

//此代码是基于UUAVAudioPlayer改写的，详见：https://github.com/ZhipingYang/UUChatTableView/blob/master/UUChat/UUAVAudioPlayer.h

#import <AVFoundation/AVFoundation.h>
#import "MQChatAudioTypes.h"

@protocol MQChatAudioPlayerDelegate <NSObject>

- (void)MQAudioPlayerBeiginLoadVoice;
- (void)MQAudioPlayerBeiginPlay;
- (void)MQAudioPlayerDidFinishPlay;

@end

@interface MQChatAudioPlayer : NSObject
@property (nonatomic ,strong)  AVAudioPlayer *player;
@property (nonatomic, weak)  id<MQChatAudioPlayerDelegate> delegate;

///如果应用中有其他地方正在播放声音，比如游戏，需要将此设置为 YES，防止其他声音在录音播放完之后无法继续播放
@property (nonatomic, assign) BOOL keepSessionActive;
@property (nonatomic, assign) MQPlayMode playMode;

+ (MQChatAudioPlayer *)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;
-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end
