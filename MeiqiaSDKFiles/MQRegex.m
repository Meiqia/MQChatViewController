//
//  MQRegex.m
//  MeiQiaSDK
//
//  Created by Injoy on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQRegex.h"

@implementation MQRegex

+(BOOL)regexMatchWithRegular:(NSString*)regex withString:(NSString*)string
{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex] evaluateWithObject:string];
}

@end
