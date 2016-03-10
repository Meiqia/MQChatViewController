//
//  MQDateFormatterUtil.h
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/17.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQDateFormatterUtil : NSObject

@property (strong, nonatomic, readonly) NSDateFormatter *dateFormatter;

+ (MQDateFormatterUtil *)sharedFormatter;

- (NSString *)meiqiaStyleDateForDate:(NSDate *)date;

- (NSString *)timestampForDate:(NSDate *)date;

- (NSString *)timeForDate:(NSDate *)date;

- (NSString *)relativeDateForDate:(NSDate *)date;

- (NSString *)weekForDate:(NSDate *)date;

@end
