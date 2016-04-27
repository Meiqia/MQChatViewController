//
//  MQDateFormatterFactory.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/24.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//
/**
 ** 由于dateFormatter的生成很影响iOS性能，故使用单例
**/

#import "MQDateFormatterFactory.h"

// Define the default cache limit only if not defined by the host application code
#ifndef MQDATEFORMATTERFACTORY_CACHE_LIMIT
#define MQDATEFORMATTERFACTORY_CACHE_LIMIT 15
#endif

@implementation MQDateFormatterFactory

- (id)init {
    self = [super init];
    if (self) {
        loadedDataFormatters = [[NSCache alloc] init];
        loadedDataFormatters.countLimit = MQDATEFORMATTERFACTORY_CACHE_LIMIT;
    }
    return self;
}

#pragma mark -
#pragma mark Static Methods

+ (MQDateFormatterFactory *)sharedFactory {
    static MQDateFormatterFactory *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[MQDateFormatterFactory alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark -
#pragma mark NSDateFormatter Initialization Methods

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"%@|%@", format, locale.localeIdentifier];
        
        NSDateFormatter *dateFormatter = [loadedDataFormatters objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = format;
            dateFormatter.locale = locale;
            [loadedDataFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocaleIdentifier:(NSString *)localeIdentifier {
    return [self dateFormatterWithFormat:format andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
{
    return [self dateFormatterWithFormat:format andLocale:[NSLocale currentLocale]];
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"d%lu|t%lu%@", (unsigned long)dateStyle, (unsigned long)timeStyle, locale.localeIdentifier];
        
        NSDateFormatter *dateFormatter = [loadedDataFormatters objectForKey:key];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = dateStyle;
            dateFormatter.timeStyle = timeStyle;
            dateFormatter.locale    = locale;
            [loadedDataFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
    
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocaleIdentifier:(NSString *)localeIdentifier {
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle {
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[NSLocale currentLocale]];
}

@end

