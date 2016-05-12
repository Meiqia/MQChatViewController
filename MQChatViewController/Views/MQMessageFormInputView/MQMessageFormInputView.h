//
//  MQMessageFormInputView.h
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/6.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQMessageFormInputModel.h"

@interface MQMessageFormInputView : UIView

- (instancetype)initWithScreenWidth:(CGFloat)screenW andModel:(MQMessageFormInputModel *)model;

- (void)refreshFrameWithScreenWidth:(CGFloat)screenWidth andY:(CGFloat)y;

- (NSString *)getText;

@end
