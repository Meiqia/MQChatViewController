//
//  MQFileDownloadMessage.h
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/6.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQBaseMessage.h"

@interface MQFileDownloadMessage : MQBaseMessage

@property (nonatomic, copy) NSString *refMessageId;
@property (nonatomic, copy) NSString *conversationId;
@property (nonatomic, strong) NSDate * lastDownloadedOn;
@property (nonatomic, strong) NSDate *firstDownloadedOn;
@property (nonatomic, assign) NSUInteger fileSize;
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) NSDate *expireDate;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
