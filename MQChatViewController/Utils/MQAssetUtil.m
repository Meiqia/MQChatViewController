//
//  MQAssetUtil.m
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/16.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQAssetUtil.h"
#import "MQBundleUtil.h"
#import "MQChatViewController.h"

@implementation MQAssetUtil

+ (UIImage *)imageFromBundleWithName:(NSString *)name
{
    id image = [UIImage imageWithContentsOfFile:[MQAssetUtil resourceWithName:name]];
    if (image) {
        return image;
    } else {
        return [UIImage imageWithContentsOfFile:[[MQAssetUtil resourceWithName:name] stringByAppendingString:@".png"]];
    }
}

+ (UIImage *)templateImageFromBundleWithName:(NSString *)name {
    return [[self.class imageFromBundleWithName:name] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (NSString*)resourceWithName:(NSString*)fileName
{
//        return [NSString stringWithFormat:@"MQChatViewAsset.bundle/%@",fileName];
    //查看 bundle 是否存在
    NSBundle *meiQiaBundle = [NSBundle bundleForClass:[MQChatViewController class]];
    NSString * fileRootPath = [[meiQiaBundle bundlePath] stringByAppendingString:@"/MQChatViewAsset.bundle"];
    NSString * filePath = [fileRootPath stringByAppendingString:[NSString stringWithFormat:@"/%@", fileName]];
    return filePath;
}

+ (UIImage *)incomingDefaultAvatarImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQIcon"];
}

+ (UIImage *)outgoingDefaultAvatarImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQIcon"];
}

+ (UIImage *)messageCameraInputImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageCameraInputImageNormalStyleOne"];
}

+ (UIImage *)messageCameraInputHighlightedImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageCameraInputImageNormalStyleOne"];
}

+ (UIImage *)messageTextInputImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageTextInputImageNormalStyleOne"];
}

+ (UIImage *)messageTextInputHighlightedImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageTextInputImageNormalStyleOne"];
}

+ (UIImage *)messageVoiceInputImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageVoiceInputImageNormalStyleOne"];
}

+ (UIImage *)messageVoiceInputHighlightedImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageVoiceInputImageNormalStyleOne"];
}

+ (UIImage *)messageResignKeyboardImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageKeyboardDownImageNormalStyleOne"];
}

+ (UIImage *)messageResignKeyboardHighlightedImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageKeyboardDownImageNormalStyleOne"];
}

+ (UIImage *)bubbleIncomingImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubbleIncoming"];
}

+ (UIImage *)bubbleOutgoingImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubbleOutgoing"];
}

+ (UIImage *)returnCancelImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQNavReturnCancelImage"];
}

+(UIImage *)imageLoadErrorImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQImageLoadErrorImage"];
}

+(UIImage *)messageWarningImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageWarning"];
}

+ (UIImage *)voiceAnimationGray1
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_voice_animation_gray1"];
}

+ (UIImage *)voiceAnimationGray2
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_voice_animation_gray2"];
}

+ (UIImage *)voiceAnimationGray3
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_voice_animation_gray3"];
}

+ (UIImage *)voiceAnimationGrayError {
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_incoming_voice_error"];
}

+ (UIImage *)voiceAnimationGreen1
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_voice_animation_green1"];
}

+ (UIImage *)voiceAnimationGreen2
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_voice_animation_green2"];
}

+ (UIImage *)voiceAnimationGreen3
{
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_voice_animation_green3"];
}

+ (UIImage *)voiceAnimationGreenError {
    return [MQAssetUtil imageFromBundleWithName:@"MQBubble_outgoing_voice_error"];
}

+ (UIImage *)recordBackImage
{
    return [MQAssetUtil imageFromBundleWithName:@"MQRecord_back"];
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
    return [MQAssetUtil imageFromBundleWithName:imageName];
}

+ (UIImage *)getEvaluationImageWithLevel:(NSInteger)level {
    NSString *imageName = @"MQEvaluationPositiveImage";
    switch (level) {
        case 0:
            imageName = @"MQEvaluationNegativeImage";
            break;
        case 1:
            imageName = @"MQEvaluationModerateImage";
            break;
        case 2:
            imageName = @"MQEvaluationPositiveImage";
            break;
        default:
            break;
    }
    return [MQAssetUtil imageFromBundleWithName:imageName];
}

+ (UIImage *)getNavigationMoreImage {
    return [MQAssetUtil imageFromBundleWithName:@"MQMessageNavMoreImage"];
}

+ (UIImage *)agentOnDutyImage {
    return [MQAssetUtil imageFromBundleWithName:@"MQAgentStatusOnDuty"];
}

+ (UIImage *)agentOffDutyImage {
    return [MQAssetUtil imageFromBundleWithName:@"MQAgentStatusOffDuty"];
}

+ (UIImage *)agentOfflineImage {
    return [MQAssetUtil imageFromBundleWithName:@"MQAgentStatusOffline"];
}

+ (UIImage *)fileIcon {
    return [MQAssetUtil imageFromBundleWithName:@"fileIcon"];
}

+ (UIImage *)fileCancel {
    return [MQAssetUtil imageFromBundleWithName:@"MQFileCancel"];
}

+ (UIImage *)fileDonwload {
    return [MQAssetUtil imageFromBundleWithName:@"MQFileDownload"];
}

+ (UIImage *)backArrow {
    return [[MQAssetUtil imageFromBundleWithName:@"backArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}
@end
