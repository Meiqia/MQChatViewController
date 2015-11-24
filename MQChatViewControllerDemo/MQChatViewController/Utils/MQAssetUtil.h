//
//  MQAssetUtil.h
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/16.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQAssetUtil : NSBundle

+ (UIImage *)bubbleImageFromBundleWithName:(NSString *)name;
+ (NSString*)resourceWithName:(NSString*)fileName;

+ (UIImage *)agentDefaultAvatarImage;
+ (UIImage *)clientDefaultAvatarImage;

+ (UIImage *)messageCameraInputImage;
+ (UIImage *)messageTextInputImage;
+ (UIImage *)messageVoiceInputImage;

+ (UIImage *)bubbleIncomingImage;
+ (UIImage *)bubbleOutgoingImage;

+ (UIImage *)returnCancelImage;

+ (UIImage *)imageLoadErrorImage;
+ (UIImage *)messageWarningImage;

+ (UIImage *)voiceAnimationGray1;
+ (UIImage *)voiceAnimationGray2;
+ (UIImage *)voiceAnimationGray3;
+ (UIImage *)voiceAnimationGrayError;

+ (UIImage *)voiceAnimationGreen1;
+ (UIImage *)voiceAnimationGreen2;
+ (UIImage *)voiceAnimationGreen3;
+ (UIImage *)voiceAnimationGreenError;

+ (UIImage *)recordBackImage;

+ (UIImage *)recordVolume:(NSInteger)volume;

+ (UIImage *)hideToolbarNormalImage;
+ (UIImage *)hideToolbarClickImage;

@end
