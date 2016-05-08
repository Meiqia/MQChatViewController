//
//  MQMessageFormInputModel.m
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/6.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import "MQMessageFormInputModel.h"

@implementation MQMessageFormInputModel

-(instancetype)init {
    if(self = [super init]) {
        self.tip = @"";
        self.placeholder = @"";
        self.key = @"";
        self.isRequired = NO;
        self.isSingleLine = NO;
        self.keyboardType = UIKeyboardTypeDefault;
    }
    return self;
}

@end
