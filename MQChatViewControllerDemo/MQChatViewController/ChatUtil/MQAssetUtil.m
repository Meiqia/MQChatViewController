//
//  MQAssetUtil.m
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/16.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQAssetUtil.h"
#import "MQBundleUtil.h"

@implementation MQAssetUtil

+ (UIImage *)bubbleImageFromBundleWithName:(NSString *)name
{
    NSBundle *bundle = [MQBundleUtil assetBundle];
    NSString *path = [bundle pathForResource:name ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];
}

+ (NSString*)resourceWithName:(NSString*)fileName
{
    return [NSString stringWithFormat:@"MQChatViewBundle.bundle/%@",fileName];
}

+ (UIImage *)agentDefaultAvatarImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQIcon"];
}

+ (UIImage *)clientDefaultAvatarImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQIcon"];
}

+ (UIImage *)messageCameraInputImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputImage"];
}

+ (UIImage *)messageTextInputImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputImage"];
}

+ (UIImage *)messageVoiceInputImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputImage"];
}

+ (UIImage *)bubbleIncomingImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubbleIncoming"];
}

+ (UIImage *)bubbleOutgoingImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubbleOutgoing"];
}

+ (UIImage *)returnCancelImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQNavReturnCancelImage"];
}

+(UIImage *)imageLoadErrorImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQImageLoadErrorImage"];
}

+(UIImage *)messageWarningImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageWarning"];
}

+ (UIImage *)voiceAnimationGray_1
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_gray1"];
}

+ (UIImage *)voiceAnimationGray_2
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_gray2"];
}

+ (UIImage *)voiceAnimationGray_3
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_gray3"];
}

+ (UIImage *)voiceAnimationGreen1
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_green1"];
}

+ (UIImage *)voiceAnimationGreen2
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_green2"];
}

+ (UIImage *)voiceAnimationGreen3
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_green3"];
}

+ (UIImage *)recordBackImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQRecord_back"];
}

+ (UIImage *)recordVolume:(NSInteger)volume
{
    NSString *imageName;
    switch (volume) {
        case 0:
            imageName = @"MQRecord0";
            break;
        case 1:
            imageName = @"MQRecord1";
            break;
        case 2:
            imageName = @"MQRecord2";
            break;
        case 3:
            imageName = @"MQRecord3";
            break;
        case 4:
            imageName = @"MQRecord4";
            break;
        case 5:
            imageName = @"MQRecord5";
            break;
        case 6:
            imageName = @"MQRecord6";
            break;
        case 7:
            imageName = @"MQRecord7";
            break;
        case 8:
            imageName = @"MQRecord8";
            break;
        default:
            imageName = @"MQRecord0";
            break;
    }
    return [MQAssetUtil bubbleImageFromBundleWithName:imageName];
}

+ (UIImage *)hideToolbarNormalImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQToolbarDown_click"];
}

+ (UIImage *)hideToolbarClickImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQToolbarDown_normal"];
}

@end
