//
//  MQMessageDateCellModel.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQCellModelProtocol.h"

/**
 * MQMessageDateCellModel定义了时间cell的基本类型数据，包括产生cell的内部所有view的显示数据，cell内部元素的frame等
 * @warning MQMessageDateCellModel必须满足MQCellModelProtocol协议
 */
@interface MQMessageDateCellModel : NSObject <MQCellModelProtocol>

/**
 * @brief cell的高度
 */
@property (nonatomic, readonly, assign) CGFloat cellHeight;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readonly, copy) NSDate *date;

/**
 * @brief 消息的中文时间
 */
@property (nonatomic, readonly, copy) NSString *dateString;

/**
 * @brief 消息气泡button的frame
 */
@property (nonatomic, readonly, assign) CGRect dateLabelFrame;

/**
 *  根据时间来生成cell model
 */
- (MQMessageDateCellModel *)initCellModelWithDate:(NSDate *)date cellWidth:(CGFloat)cellWidth;


@end
