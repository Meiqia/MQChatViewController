//
//  MQChatDeviceUtil.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQChatDeviceUtil : NSObject
/**
 * 获取设备屏幕的frame（包括导航栏）；
 */
+(CGRect)getDeviceScreenRect;

/**
 * 获取设备的tabBar的frame；
 * @param viewController 拥有tabBarController的一个viewController
 */
+(CGRect)getDeviceTabBarRect:(UIViewController*)viewController;

/**
 * 获取设备status的frame；
 */
+(CGRect)getDeviceStatusBarRect;

/**
 * 获取设备导航栏的frame；
 * @param viewController 拥有navigationController的一个viewController
 */
+(CGRect)getDeviceNavRect:(UIViewController*)viewController;

/**
 * 获取设备的frame（不包括导航栏）；
 * @param viewController 拥有tabBarController的一个viewController
 */
+(CGRect)getDeviceFrameRect:(UIViewController*)viewController;

/**
 * 获取不包括tabBar的frame；
 * @param viewController 拥有tabBarController的一个viewController
 */
+(CGRect)getDeviceScreenRectWithoutTabBar:(UIViewController*)viewController;

/**
 *  判断该设备是否支持打开系统的media工具，如相册或相机
 *
 *  @param sourceType UIImagePickerControllerSourceType
 *
 *  @return 如果支持则返回@"ok" 如果不支持返回一个localizedString 如果返回nil则表示不支持该sourceType
 */
+ (NSString *)isDeviceSupportImageSourceType:(UIImagePickerControllerSourceType)sourceType;

/**
 *  设备是否支持麦克风
 *
 */
+ (void)isDeviceSupportMicrophoneWithPermission:(void (^)(BOOL permission))permission;

@end
