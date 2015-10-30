//
//  MQMessageDateCellModel.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"

/**
 * MQMessageDateCellModel定义了消息时间的基本类型数据，包括产生cell的内部所有view的显示数据，cell内部元素的frame等
 * @warning MQMessageDateCellModel必须满足MQCellModelProtocol协议
 */
@interface MQMessageDateCellModel : NSObject <MQCellModelProtocol>

/**
 * @brief 消息的时间
 */
@property (nonatomic, readonly, copy) NSString *messageDate;

/**
 * @brief 消息气泡button的frame
 */
@property (nonatomic, readonly, assign) CGRect dateLabelFrame;

/**
 *  根据时间来生成cell model
 */
- (MQMessageDateCellModel *)initCellModelWithDate:(NSDate *)date;


@end
