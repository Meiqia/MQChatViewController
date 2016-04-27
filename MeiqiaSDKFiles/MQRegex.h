//
//  MQRegex.h
//  MeiQiaSDK
//
//  Created by Injoy on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQRegex : NSObject

+(BOOL)regexMatchWithRegular:(NSString*)regex withString:(NSString*)string;

@end
