//
//  MQDeviceFrameUtil.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQDeviceFrameUtil.h"

@implementation MQDeviceFrameUtil

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

@end
