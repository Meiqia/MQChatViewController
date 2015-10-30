//
//  MQTipsCellModel.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"

/**
 * MQTipsCellModel定义了消息提示的基本类型数据，包括产生cell的内部所有view的显示数据，cell内部元素的frame等
 * @warning MQTipsCellModel必须满足MQCellModelProtocol协议
 */
@interface MQTipsCellModel : NSObject

/**
 * @brief 提示文字
 */
@property (nonatomic, readonly, copy) NSString *tipText;

/**
 * @brief 提示的时间
 */
@property (nonatomic, readonly, copy) NSString *eventDate;

/**
 * @brief 提示label的frame
 */
@property (nonatomic, readonly, assign) CGRect tipLabelFrame;

/**
 *  根据tips内容来生成cell model
 */
- (MQTipsCellModel *)initCellModelWithTips:(NSString *)tips;

@end
