//
//  MQVoiceMessageCell.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQVoiceMessageCell.h"
#import "MQVoiceCellModel.h"
#import "MQChatFileUtil.h"
#import "MQChatViewConfig.h"
#import "MQChatAudioPlayer.h"
#import "VoiceConverter.h"

@interface MQVoiceMessageCell()<MQChatAudioPlayerDelegate>

@end

@implementation MQVoiceMessageCell {
    UIImageView *avatarImageView;
    UIImageView *bubbleImageView;
    UIActivityIndicatorView *sendingIndicator;
    UILabel *durationLabel;
    UIImageView *voiceImageView;
    UIImageView *failureImageView;
    UIActivityIndicatorView *loadingIndicator;
    MQChatAudioPlayer *audioPlayer;
    NSData *voiceData;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MQAudioPlayerDidInterruptNotification object:nil];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化头像
        avatarImageView = [[UIImageView alloc] init];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:avatarImageView];
        //初始化气泡
        bubbleImageView = [[UIImageView alloc] init];
        bubbleImageView.userInteractionEnabled = true;
        UITapGestureRecognizer *tapBubbleGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapVoiceBubbleGesture:)];
        [bubbleImageView addGestureRecognizer:tapBubbleGesture];
        [self.contentView addSubview:bubbleImageView];
        //初始化indicator
        sendingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sendingIndicator.hidden = YES;
        [self.contentView addSubview:sendingIndicator];
        //初始化语音时长的label
        durationLabel = [[UILabel alloc] init];
        durationLabel.textColor = [UIColor lightGrayColor];
        durationLabel.font = [UIFont systemFontOfSize:kMQCellVoiceDurationLabelFontSize];
        durationLabel.textAlignment = NSTextAlignmentCenter;
        durationLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:durationLabel];
        //初始化语音图片
        voiceImageView = [[UIImageView alloc] init];
        [bubbleImageView addSubview:voiceImageView];
        //初始化出错image
        failureImageView = [[UIImageView alloc] initWithImage:[MQChatViewConfig sharedConfig].messageSendFailureImage];
        UITapGestureRecognizer *tapFailureImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFailImage:)];
        failureImageView.userInteractionEnabled = true;
        [failureImageView addGestureRecognizer:tapFailureImageGesture];
        [self.contentView addSubview:failureImageView];
        //初始化加载数据的indicator
        loadingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.hidden = YES;
        [bubbleImageView addSubview:loadingIndicator];
        //注册声音中断的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopVoiceAnimation) name:MQAudioPlayerDidInterruptNotification object:nil];
    }
    return self;
}

#pragma 点击语音的事件
- (void)didTapVoiceBubbleGesture:(id)sender {
    if (!voiceData) {
        return ;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MQAudioPlayerDidInterruptNotification object:nil];
    audioPlayer = [MQChatAudioPlayer sharedInstance];
    audioPlayer.delegate = self;
    [audioPlayer stopSound];
    [audioPlayer playSongWithData:voiceData];
    [voiceImageView startAnimating];
}

- (void)stopVoiceAnimation {
    [voiceImageView stopAnimating];
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQVoiceCellModel class]]) {
        NSAssert(NO, @"传给MQVoiceMessageCell的Model类型不正确");
        return ;
    }
    MQVoiceCellModel *cellModel = (MQVoiceCellModel *)model;
    
    //刷新头像
    if (cellModel.avatarImage) {
        avatarImageView.image = cellModel.avatarImage;
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
#warning 这里开发者可以使用自己的图片缓存策略，如SDWebImage
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:cellModel.avatarPath]];
            avatarImageView.image = [UIImage imageWithData:imageData];
        });
    }
    avatarImageView.frame = cellModel.avatarFrame;
    if ([MQChatViewConfig sharedConfig].enableRoundAvatar) {
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = cellModel.avatarFrame.size.width/2;
    }
    
    //刷新气泡
    bubbleImageView.image = cellModel.bubbleImage;
    bubbleImageView.frame = cellModel.bubbleImageFrame;
    
    //消息图片
    voiceImageView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQBubble_voice_animation_green3"]];
    NSString *animationImage1 = @"MQBubble_voice_animation_green1";
    NSString *animationImage2 = @"MQBubble_voice_animation_green2";
    NSString *animationImage3 = @"MQBubble_voice_animation_green3";
    if (cellModel.cellFromType == MQChatCellIncoming) {
        animationImage1 = @"MQBubble_voice_animation_gray1";
        animationImage2 = @"MQBubble_voice_animation_gray2";
        animationImage3 = @"MQBubble_voice_animation_gray3";
        voiceImageView.image = [UIImage imageNamed:[MQChatFileUtil resourceWithName:@"MQBubble_voice_animation_gray3"]];
    }
    voiceImageView.animationImages = [NSArray arrayWithObjects:
                                  [UIImage imageNamed:[MQChatFileUtil resourceWithName:animationImage1]],
                                  [UIImage imageNamed:[MQChatFileUtil resourceWithName:animationImage2]],
                                  [UIImage imageNamed:[MQChatFileUtil resourceWithName:animationImage3]],nil];
    voiceImageView.animationDuration = 1;
    voiceImageView.animationRepeatCount = 0;

    //刷新语音时长label
    NSString *durationText = [NSString stringWithFormat:@"%d\"", (int)cellModel.voiceDuration];
    durationLabel.text = durationText;
    durationLabel.frame = cellModel.durationLabelFrame;
    durationLabel.hidden = true;
    
    //判断是否正在加载声音，是否显示加载数据的indicator
    loadingIndicator.frame = cellModel.loadingIndicatorFrame;
    voiceImageView.frame = cellModel.voiceImageFrame;
    if (cellModel.voiceData) {
        voiceData = cellModel.voiceData;
        voiceImageView.hidden = false;
        loadingIndicator.hidden = true;
        [loadingIndicator stopAnimating];
    } else {
        voiceImageView.hidden = true;
        loadingIndicator.hidden = false;
        [loadingIndicator startAnimating];
    }

    //刷新indicator
    sendingIndicator.hidden = true;
    [sendingIndicator stopAnimating];
    if (cellModel.sendStatus == MQChatMessageSendStatusSending && cellModel.cellFromType == MQChatCellOutgoing) {
        sendingIndicator.frame = cellModel.sendingIndicatorFrame;
        [sendingIndicator startAnimating];
    } else {
        durationLabel.hidden = false;
    }
    
    //刷新出错图片
    failureImageView.hidden = true;
    if (cellModel.sendStatus == MQChatMessageSendStatusFailure) {
        failureImageView.hidden = false;
        failureImageView.frame = cellModel.sendFailureFrame;
    }
}

/**
 *  开始播放声音
 */
- (void)playVoice {
    [voiceImageView startAnimating];
    //关闭键盘通知
    [[NSNotificationCenter defaultCenter] postNotificationName:MQChatViewKeyboardResignFirstResponderNotification object:nil];
}

/**
 *  停止播放声音
 */
- (void)stopVoice {
    if (voiceImageView.isAnimating) {
        [voiceImageView stopAnimating];
    }
}

#pragma MQChatAudioPlayerDelegate
- (void)MQAudioPlayerBeiginLoadVoice {
    
}

- (void)MQAudioPlayerBeiginPlay {
    
}

- (void)MQAudioPlayerDidFinishPlay {
    [self stopVoiceAnimation];
}

#pragma 点击发送失败消息，重新发送事件
- (void)tapFailImage:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"重新发送吗？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"重新发送");
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            //将voiceData写进文件
            NSString *wavPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            wavPath = [wavPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.wav", (int)[NSDate date].timeIntervalSince1970]];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:wavPath contents:voiceData attributes:nil];
            if (![fileManager fileExistsAtPath:wavPath]) {
                NSAssert(NO, @"将voiceData写进文件失败");
            }
            //将wav文件转换成amr文件
            NSString *amrPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            amrPath = [amrPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.amr", (int)[NSDate date].timeIntervalSince1970]];
            [VoiceConverter wavToAmr:wavPath amrSavePath:amrPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.chatCellDelegate resendMessageInCell:self resendData:@{@"voice" : amrPath}];
            });
        });
    }
}




@end
