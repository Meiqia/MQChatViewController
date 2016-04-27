//
//  NSArray+MQFunctional.h
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/20.
//  Copyright © 2016年 Meiqia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(MQFunctional)

- (NSArray *)filter:(BOOL(^)(id element))action;

- (NSArray *)map:(id(^)(id element))action;

@end
