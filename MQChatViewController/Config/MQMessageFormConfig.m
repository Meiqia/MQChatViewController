//
//  MQMessageFormConfig.m
//  MQChatViewControllerDemo
//
//  Created by bingoogolapple on 16/5/8.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQMessageFormConfig.h"
#import "MQMessageFormInputModel.h"
#import "MQBundleUtil.h"

@implementation MQMessageFormConfig

+ (instancetype)sharedConfig {
    static MQMessageFormConfig *_sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedConfig = [[MQMessageFormConfig alloc] init];
    });
    return _sharedConfig;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setConfigToDefault];
    }
    return self;
}

- (void)setConfigToDefault {
    self.leaveMessageIntro = @"";
    
    // 初始化默认最佳实践
    MQMessageFormInputModel *telMessageFormInputModel = [[MQMessageFormInputModel alloc] init];
    telMessageFormInputModel.tip = [MQBundleUtil localizedStringForKey:@"tel"];
    telMessageFormInputModel.key = @"tel";
    telMessageFormInputModel.isSingleLine = YES;
    telMessageFormInputModel.placeholder = [MQBundleUtil localizedStringForKey:@"tel_placeholder"];
    telMessageFormInputModel.isRequired = YES;
    telMessageFormInputModel.keyboardType = UIKeyboardTypePhonePad;
    MQMessageFormInputModel *emailMessageFormInputModel = [[MQMessageFormInputModel alloc] init];
    emailMessageFormInputModel.tip = [MQBundleUtil localizedStringForKey:@"email"];
    emailMessageFormInputModel.key = @"email";
    emailMessageFormInputModel.isSingleLine = YES;
    emailMessageFormInputModel.placeholder = [MQBundleUtil localizedStringForKey:@"email_placeholder"];
    emailMessageFormInputModel.isRequired = NO;
    emailMessageFormInputModel.keyboardType = UIKeyboardTypeEmailAddress;
    self.customMessageFormInputModelArray = @[telMessageFormInputModel, emailMessageFormInputModel];
    
    self.messageFormViewStyle = [MQMessageFormViewStyle defaultStyle];
}

@end
