//
//  MQChatAudioPlayer.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/2.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

//此代码是基于UUAVAudioPlayer改写的，详见：https://github.com/ZhipingYang/UUChatTableView/blob/master/UUChat/UUAVAudioPlayer.h

#import <AVFoundation/AVFoundation.h>

@protocol MQChatAudioPlayerDelegate <NSObject>

- (void)MQAudioPlayerBeiginLoadVoice;
- (void)MQAudioPlayerBeiginPlay;
- (void)MQAudioPlayerDidFinishPlay;

@end

@interface MQChatAudioPlayer : NSObject
@property (nonatomic ,strong)  AVAudioPlayer *player;
@property (nonatomic, weak)  id<MQChatAudioPlayerDelegate> delegate;

+ (MQChatAudioPlayer *)sharedInstance;

-(void)playSongWithUrl:(NSString *)songUrl;
-(void)playSongWithData:(NSData *)songData;

- (void)stopSound;

@end
