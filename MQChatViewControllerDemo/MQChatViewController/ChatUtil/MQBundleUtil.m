//
//  MQBundleUtil.m
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/16.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQBundleUtil.h"
#import "MQChatViewController.h"
#import "MQFileUtil.h"

@implementation MQBundleUtil

+ (NSBundle *)assetBundle
{
    NSString *bundleResourcePath = [NSBundle mainBundle].resourcePath;
    NSString *assetPath = [bundleResourcePath stringByAppendingPathComponent:@"MQChatViewAsset.bundle"];
    return [NSBundle bundleWithPath:assetPath];
}

+ (NSString *)localizedStringForKey:(NSString *)key
{
    NSBundle *bundle = [MQBundleUtil assetBundle];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%@", [defaults objectForKey:@"AppleLanguages"][0]);
    NSLog(@"%@", bundle.preferredLocalizations);
    
    if ([MQFileUtil fileExistsAtPath:[NSString stringWithFormat:@"%@/zh-Hans.lproj/MQChatViewController.strings",bundle.bundleURL.path] isDirectory:NO]) {
        NSLog(@"存在");
    }
    
    NSLog(@"%@", [[NSString alloc] initWithData:[[NSData alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/zh-Hans.lproj/MQChatViewController.strings",bundle.bundleURL.path]] encoding:NSUTF8StringEncoding]);
    
    return [bundle localizedStringForKey:key value:nil table:@"MQChatViewController"];
//    return NSLocalizedStringFromTableInBundle(key, @"MQChatViewController", [MQBundleUtil assetBundle], nil);
}

@end
