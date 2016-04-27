//
//  MQDate.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/24.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQDateUtil : NSObject

+ (NSString *)iso8601StringFromUTCDate:(NSDate *)date;
+ (NSDate *)convertToUtcDateFromUTCDateString:(NSString *)dateString;

+ (NSDate *)convertToLoaclDateFromUTCDate:(NSDate *)anyDate;
+ (NSDate *)convertToUTCDateFromLocalDate:(NSDate *)fromDate;

@end
