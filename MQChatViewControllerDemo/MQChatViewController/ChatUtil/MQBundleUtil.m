//
//  MQBundleUtil.m
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/16.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQBundleUtil.h"
#import "MQChatViewController.h"

@implementation MQBundleUtil

+ (NSBundle *)assetBundle
{
    NSString *bundleResourcePath = [NSBundle bundleForClass:[MQChatViewController class]].resourcePath;
    NSString *assetPath = [bundleResourcePath stringByAppendingPathComponent:@"MQChatViewAsset.bundle"];
    return [NSBundle bundleWithPath:assetPath];
}

+ (NSString *)localizedStringForKey:(NSString *)key
{
    return NSLocalizedStringFromTableInBundle(key, @"MQChatViewController", [MQBundleUtil assetBundle], nil);
}

@end
