//
//  MQChatDeviceUtil.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatDeviceUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation MQChatDeviceUtil

+(CGRect)getDeviceScreenRect{
    return [[UIScreen mainScreen] bounds];
}

+(CGRect)getDeviceTabBarRect:(UIViewController*)viewController{
    if (viewController.tabBarController) {
        return viewController.tabBarController.tabBar.frame;
    } else {
        return CGRectMake(0, 0, 0, 0);
    }
}

+(CGRect)getDeviceStatusBarRect{
    return [[UIApplication sharedApplication] statusBarFrame];
}

+(CGRect)getDeviceNavRect:(UIViewController*)viewController{
    return viewController.navigationController.navigationBar.frame;
}

+(CGRect)getDeviceFrameRect:(UIViewController*)viewController{
    CGRect statusBarRect = [[UIApplication sharedApplication] statusBarFrame];
    CGRect navRect = viewController.navigationController.navigationBar.frame;
    CGRect tabBarRect = (viewController.tabBarController) ? viewController.tabBarController.tabBar.frame : CGRectMake(0, 0, 0, 0);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect frameRect = CGRectMake(navRect.origin.x, statusBarRect.size.height+navRect.size.height, screenRect.size.width, screenRect.size.height-statusBarRect.size.height-navRect.size.height-tabBarRect.size.height);
    return frameRect;
}

+(CGRect)getDeviceScreenRectWithoutTabBar:(UIViewController*)viewController{
    CGRect tabBarRect = (viewController.tabBarController) ? viewController.tabBarController.tabBar.frame : CGRectMake(0, 0, 0, 0);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect frameRectWithoutTabBar = CGRectMake(0, 0, screenRect.size.width, screenRect.size.height-tabBarRect.size.height);
    return frameRectWithoutTabBar;
    
}

+ (NSString *)isDeviceSupportImageSourceType:(UIImagePickerControllerSourceType)sourceType {
    if (TARGET_IPHONE_SIMULATOR && (int)sourceType == UIImagePickerControllerSourceTypeCamera) {
        return @"simulator_not_support_camera";
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        //iOS7以上系统
        AVAuthorizationStatus status =[AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if ((int)sourceType == UIImagePickerControllerSourceTypeCamera && (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted)) {
            if ((int)sourceType == UIImagePickerControllerSourceTypeCamera){
                return @"not_access_camera";
            } else if ((int)sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                return @"not_access_photos";
            } else {
                return nil;
            }
        } else {
            return @"ok";
        }
    } else {
        AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:inputDevice error:nil];
        if (!captureInput) {
            if ((int)sourceType == UIImagePickerControllerSourceTypeCamera){
                return @"not_access_camera";
            } else if ((int)sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                return @"not_access_photos";
            } else {
                return nil;
            }
        } else {
            return @"ok";
        }
    }
}

+ (void)isDeviceSupportMicrophoneWithPermission:(void (^)(BOOL permission))permission {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session respondsToSelector:@selector(requestRecordPermission:)]) {
        [session performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                permission(granted);
            });
        }];
    } else {
        permission(true);
    }
}

@end
