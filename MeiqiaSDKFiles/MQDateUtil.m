//
//  MQDate.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/24.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQDateUtil.h"
#import "MQDateFormatterFactory.h"
#import "MQRegex.h"

@implementation MQDateUtil

+ (NSString *)iso8601StringFromUTCDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[MQDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS"];
    [dateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)convertToUtcDateFromUTCDateString:(NSString *)dateString
{
    if (!dateString) {
        dateString = @"";
    }
    
    NSString *iso8601Reg = @"([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-9])))T([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9].{6}[0-9]";
    NSString *iso8601NoHaveTReg = @"([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-9]))) ([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9].{6}[0-9]";
    
    if ([MQRegex regexMatchWithRegular:iso8601Reg withString:dateString]) {
        NSDateFormatter *dateFormatter = [[MQDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS"];
        [dateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
        return [dateFormatter dateFromString:dateString];
    }else if ([MQRegex regexMatchWithRegular:iso8601NoHaveTReg withString:dateString]) {
        NSDateFormatter *dateFormatter = [[MQDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss'.'SSSSSS"];
        [dateFormatter setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
        return [dateFormatter dateFromString:dateString];
    }else{
        return [NSDate new];
    }
}

+ (NSDate *)convertToUtcDateFromLocalDateString:(NSString *)dateString
{
    if (!dateString) {
        dateString = @"";
    }
    
    NSString *iso8601Reg = @"([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8])))T([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9].{6}[0-9]";
    NSString *iso8601NoHaveTReg = @"([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))) ([0-1][0-9]|2[0-3]):[0-5][0-9]:[0-5][0-9].{6}[0-9]";
    
    if ([MQRegex regexMatchWithRegular:iso8601Reg withString:dateString]) {
        NSDateFormatter *dateFormatter = [[MQDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyy-MM-dd'T'HH:mm:ss'.'SSSSSS"];
        return [self convertToUTCDateFromLocalDate:[dateFormatter dateFromString:dateString]];
    }else if ([MQRegex regexMatchWithRegular:iso8601NoHaveTReg withString:dateString]) {
        NSDateFormatter *dateFormatter = [[MQDateFormatterFactory sharedFactory] dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss'.'SSSSSS"];
        return [self convertToUTCDateFromLocalDate:[dateFormatter dateFromString:dateString]];
    }else{
        return [NSDate new];
    }
}

+ (NSDate *)convertToLoaclDateFromUTCDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSInteger interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    return [[NSDate alloc] initWithTimeInterval:(NSTimeInterval)interval sinceDate:anyDate];
}

+ (NSDate *)convertToUTCDateFromLocalDate:(NSDate *)fromDate {
    //设置源日期时区
    NSTimeZone *sourceTimeZone = [NSTimeZone localTimeZone];
    //设置转换后的目标日期时区
    NSTimeZone *destinationTimeZone = [[NSTimeZone alloc] initWithName:@"GMT"];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:fromDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:fromDate];
    //得到时间偏移量的差值
    NSInteger interval = destinationGMTOffset - sourceGMTOffset;
    //转为GMT时间
    return [[NSDate alloc] initWithTimeInterval:(NSTimeInterval)interval sinceDate:fromDate];
}

@end
