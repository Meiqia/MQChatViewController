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
    return [UIImage imageNamed:[MQAssetUtil resourceWithName:name]];
}

+ (NSString*)resourceWithName:(NSString*)fileName
{
    return [NSString stringWithFormat:@"MQChatViewAsset.bundle/%@",fileName];
}

+ (UIImage *)incomingDefaultAvatarImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQIcon"];
}

+ (UIImage *)outgoingDefaultAvatarImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQIcon"];
}

+ (UIImage *)messageCameraInputImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputImageNormalStyleOne"];
}

+ (UIImage *)messageCameraInputHighlightedImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputHighlightedImageStyleOne"];
}

+ (UIImage *)messageTextInputImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputImageNormalStyleOne"];
}

+ (UIImage *)messageTextInputHighlightedImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputHighlightedImageStyleOne"];
}

+ (UIImage *)messageVoiceInputImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputImageNormalStyleOne"];
}

+ (UIImage *)messageVoiceInputHighlightedImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputHighlightedImageStyleOne"];
}

+ (UIImage *)messageResignKeyboardImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageKeyboardDownImageNormalStyleOne"];
}

+ (UIImage *)messageResignKeyboardHighlightedImage
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageKeyboardDownHighlightedImageStyleOne"];
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

+ (UIImage *)voiceAnimationGray1
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_gray1"];
}

+ (UIImage *)voiceAnimationGray2
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_gray2"];
}

+ (UIImage *)voiceAnimationGray3
{
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_voice_animation_gray3"];
}

+ (UIImage *)voiceAnimationGrayError {
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_incoming_voice_error"];
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

+ (UIImage *)voiceAnimationGreenError {
    return [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubble_outgoing_voice_error"];
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

@end
