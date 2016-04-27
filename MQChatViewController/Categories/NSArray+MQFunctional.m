//
//  NSArray+MQFunctional.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/20.
//  Copyright © 2016年 Meiqia. All rights reserved.
//

#import "NSArray+MQFunctional.h"

@implementation NSArray(MQFunctional)

- (NSArray *)filter:(BOOL(^)(id))action {
    NSMutableArray *resultArray = [NSMutableArray new];
    for (id element in self) {
        if (action(element)) {
            [resultArray addObject:element];
        }
    }
    return resultArray;
}

- (NSArray *)map:(id(^)(id ))action {
    NSMutableArray *resultArray = [NSMutableArray new];
    for (id element in self) {
        [resultArray addObject:action(element)];
    }
    return resultArray;
}

@end
