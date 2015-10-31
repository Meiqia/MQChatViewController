//
//  MQEventCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQEventCellModel.h"
#import "MQChatBaseCell.h"
#import "MQEventMessageCell.h"  

@implementation MQEventCellModel

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return self.cellHeight;
}

/**
 *  @return cell重用的名字.
 */
- (NSString *)getCellReuseIdentifier {
    return @"MQEventMessageCell";
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQEventMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

- (NSDate *)getCellDate {
    return self.date;
}

@end
