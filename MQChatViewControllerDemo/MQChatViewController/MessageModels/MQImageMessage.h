//
//  MQImageMessage.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQBaseMessage.h"
#import <UIKit/UIKit.h>

@interface MQImageMessage : MQBaseMessage

/** 消息image path */
@property (nonatomic, copy) NSString *imagePath;

/** 消息image */
@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImagePath:(NSString *)imagePath;

- (instancetype)initWithImage:(UIImage *)image;

@end
