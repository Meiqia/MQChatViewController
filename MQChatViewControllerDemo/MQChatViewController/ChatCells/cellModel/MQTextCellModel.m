//
//  MQTextCellModel.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTextCellModel.h"
#import "MQTextMessageCell.h"
#import "MQChatBaseCell.h"

@implementation MQTextCellModel


#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return 0;
}

/**
 *  @return cell重用的名字.
 */
- (NSString *)getCellReuseIdentifier {
    return @"MQTextMessageCell";
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}


@end
