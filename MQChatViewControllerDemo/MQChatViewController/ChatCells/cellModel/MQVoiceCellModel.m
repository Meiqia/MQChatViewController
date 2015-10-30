//
//  MQVoiceCellModel.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQVoiceCellModel.h"
#import "MQChatBaseCell.h"
#import "MQVoiceMessageCell.h"

@implementation MQVoiceCellModel


#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return 0;
}

/**
 *  @return cell重用的名字.
 */
- (NSString *)getCellReuseIdentifier {
    return @"MQVoiceMessageCell";
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQVoiceMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}

@end
