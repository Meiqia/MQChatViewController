//
//  MQMessageFormViewStyle.m
//  MQChatViewControllerDemo
//
//  Created by bingoogol on 16/5/11.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQMessageFormViewStyle.h"
#import "MQAssetUtil.h"

@implementation MQMessageFormViewStyle

+ (instancetype)createWithStyle:(MQMessageFormViewStyleType)type {
    switch (type) {
        default:
            return [MQMessageFormViewStyle new];
    }
}

+ (instancetype)defaultStyle {
    return [self createWithStyle:(MQMessageFormViewStyleTypeDefault)];
}

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:245 / 255.0 blue:247 / 255.0 alpha:1];
        self.introTextColor = [UIColor colorWithRed:118 / 255.0 green:125 / 255.0 blue:133 / 255.0 alpha:1];
        self.inputTipTextColor = [UIColor colorWithRed:173 / 255.0 green:178 / 255.0 blue:187 / 255.0 alpha:1];
        self.inputPlaceholderTextColor = [UIColor colorWithRed:198 / 255.0 green:203 / 255.0 blue:208 / 255.0 alpha:1];
        self.inputTextColor = [UIColor colorWithRed:90 / 255.0 green:105 / 255.0 blue:120 / 255.0 alpha:1];
        self.inputTopBottomBorderColor = [UIColor colorWithRed:0.81 green:0.82 blue:0.84 alpha:1.00];
        self.addPictureTextColor = [UIColor colorWithRed:118 / 255.0 green:125 / 255.0 blue:133 / 255.0 alpha:1];
        self.deleteImage = [UIImage imageNamed:[MQAssetUtil resourceWithName:@"MQMessageFormDeleteIcon"]];
        self.addImage = [UIImage imageNamed:[MQAssetUtil resourceWithName:@"MQMessageFormAddIcon"]];
    }
    return self;
}

@end
