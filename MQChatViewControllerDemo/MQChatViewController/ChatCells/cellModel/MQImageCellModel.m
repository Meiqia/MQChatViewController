//
//  MQImageCellModel.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQImageCellModel.h"
#import "MQChatBaseCell.h"
#import "MQImageMessageCell.h"

@implementation MQImageCellModel

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return 0;
}

/**
 *  @return cell重用的名字.
 */
- (NSString *)getCellReuseIdentifier {
    return @"MQImageMessageCell";
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQImageMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
