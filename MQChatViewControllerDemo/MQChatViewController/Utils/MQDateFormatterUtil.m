//
//  MQDateFormatterUtil.m
//  MQChatViewControllerDemo
//
//  Created by Injoy on 15/11/17.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQDateFormatterUtil.h"

#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit |  NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation MQDateFormatterUtil

#pragma mark - Initialization

+ (MQDateFormatterUtil *)sharedFormatter
{
    static MQDateFormatterUtil *_sharedFormatter = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        _sharedFormatter = [[MQDateFormatterUtil alloc] init];
    });
    
    return _sharedFormatter;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setLocale:[NSLocale currentLocale]];
        [_dateFormatter setDoesRelativeDateFormatting:YES];
    }
    return self;
}

- (void)dealloc
{
    _dateFormatter = nil;
}

#pragma mark - Formatter

- (NSString *)meiqiaStyleDateForDate:(NSDate *)date
{
    if ([MQDateFormatterUtil dateYearFromDate:date] == [MQDateFormatterUtil dateYearFromDate:[NSDate date]]) {
        NSInteger days = [MQDateFormatterUtil dateDayFromDate:[NSDate date]] - [MQDateFormatterUtil dateDayFromDate:date];
        if (days <= 1) {
            //昨天内
            return [self timestampForDate:date];
        }else if (days <= 6){
            //一星期内
            return [NSString stringWithFormat:@"%@ %@", [self weekForDate:date], [self timeForDate:date]];
        }else{
            //年内
            return [self timestampForDate:date];
        }
    }else{
        //去年以前
        return [self timestampForDate:date];
    }
}

- (NSString *)timestampForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)timeForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    [self.dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)relativeDateForDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [self.dateFormatter stringFromDate:date];
}

- (NSString *)weekForDate:(NSDate *)date
{
    self.dateFormatter.dateFormat = @"cccc";
    return [self.dateFormatter stringFromDate:date];
}

+ (NSInteger) dateYearFromDate:(NSDate *)date{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.year;
}

+ (NSInteger) dateDayFromDate:(NSDate *)date{
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:date];
    return components.day;
}

@end
