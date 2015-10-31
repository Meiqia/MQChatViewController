//
//  MQChatDateUtil.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/31.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQChatDateUtil.h"
#import <UIKit/UIKit.h>

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]


@implementation MQChatDateUtil

+ (NSString *)convertToChineseDateWithDate:(NSDate *)date{
    NSString *dateString;  //年月日
    NSString *hour;     //时
    
    if ([MQChatDateUtil dateYearFromDate:date] == [MQChatDateUtil dateYearFromDate:[NSDate date]]) {
        NSInteger days = [MQChatDateUtil comparesWithTodayWithDate:date];
        if (days <= 1) {
            dateString = [MQChatDateUtil stringYearMonthDayCompareTodayWithDate:date];
        }else if(days <= 6){
            dateString = [MQChatDateUtil weekdayStringFromDate:date];
        }
        else{
            dateString = [MQChatDateUtil dateMonthDayWithDate:date];
        }
    }else{
        dateString = [MQChatDateUtil stringYearMonthDayWithDate:date];
    }
    
    hour = [NSString stringWithFormat:@"%02d",(int)[MQChatDateUtil dateHourFromDate:date]];
    return [NSString stringWithFormat:@"%@ %@:%02d",dateString,hour,(int)[MQChatDateUtil dateMinuteFromDate:date]];
}

+ (NSInteger) dateYearFromDate:(NSDate *)date{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.year;
}

+ (NSInteger) dateHourFromDate:(NSDate *)date{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.hour;
}

+ (NSInteger) dateMinuteFromDate:(NSDate *)date{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.minute;
}

+ (NSInteger)comparesWithTodayWithDate:(NSDate *)date{
    //只取年月日比较
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSTimeInterval timeIntervalNow = [[NSDate date] timeIntervalSince1970];
    
    NSTimeInterval cha = timeInterval - timeIntervalNow;
    CGFloat chaDay = cha / 86400.0;
    NSInteger day = chaDay * 1;
    return labs(day);
}

+ (NSString *)stringYearMonthDayCompareTodayWithDate:(NSDate *)date{
    NSString *str;
    NSInteger chaDay = [MQChatDateUtil comparesWithTodayWithDate:date];
    if (chaDay == 0) {
        str = @"";    //今天
    }else if (chaDay == 1){
        str = @"明天";
    }else if (chaDay == -1){
        str = @"昨天";
    }else{
        str = [MQChatDateUtil stringYearMonthDayWithDate:date];
    }
    return str;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

+ (NSString *)stringYearMonthDayWithDate:(NSDate *)date{
    if (date == nil) {
        date = [NSDate date];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}

+ (NSString *)dateMonthDayWithDate:(NSDate *)date{
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM.dd"];
    NSString *str = [formatter stringFromDate:date];
    return str;
}


@end
