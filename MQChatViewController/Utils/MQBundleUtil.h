//
//  MQBundleUtil.h
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/16.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQBundleUtil : NSBundle

+ (NSBundle *)assetBundle;

+ (NSString *)localizedStringForKey:(NSString *)key;

@end
