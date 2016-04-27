//
//  MQDateFormatterFactory.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/24.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQDateFormatterFactory : NSObject{
    NSCache *loadedDataFormatters;
}

+ (MQDateFormatterFactory *)sharedFactory;
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocale:(NSLocale *)locale;
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocaleIdentifier:(NSString *)localeIdentifier;
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocale:(NSLocale *)locale;
- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle andLocaleIdentifier:(NSString *)localeIdentifier;
- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle andTimeStyle:(NSDateFormatterStyle)timeStyle;


@end
