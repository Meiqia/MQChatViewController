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

+ (UIImage *)imageFromBundleWithName:(NSString *)name;

+ (UIImage *)templateImageFromBundleWithName:(NSString *)name;

+ (NSString*)resourceWithName:(NSString*)fileName;

+ (UIImage *)incomingDefaultAvatarImage;
+ (UIImage *)outgoingDefaultAvatarImage;

+ (UIImage *)messageCameraInputImage;
+ (UIImage *)messageCameraInputHighlightedImage;

+ (UIImage *)messageTextInputImage;
+ (UIImage *)messageTextInputHighlightedImage;

+ (UIImage *)messageVoiceInputImage;
+ (UIImage *)messageVoiceInputHighlightedImage;

+ (UIImage *)messageResignKeyboardImage;
+ (UIImage *)messageResignKeyboardHighlightedImage;

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

+ (UIImage *)getEvaluationImageWithLevel:(NSInteger)level;

+ (UIImage *)getNavigationMoreImage;

+ (UIImage *)agentOnDutyImage;
+ (UIImage *)agentOffDutyImage;
+ (UIImage *)agentOfflineImage;

+ (UIImage *)fileIcon;
+ (UIImage *)fileCancel;
+ (UIImage *)fileDonwload;
+ (UIImage *)backArrow;

@end
