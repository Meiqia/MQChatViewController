//
//  MQChatViewTableDataSource.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQChatViewService.h"
#import <UIKit/UIKit.h>
#import "MQChatBaseCell.h"

/**
 * @brief 客服聊天界面中的UITableView的datasource
 */
@interface MQChatViewTableDataSource : NSObject <UITableViewDataSource>

//- (instancetype)initWithTableView:(UITableView *)tableView  chatViewService:(MQChatViewService *)chatService;
- (instancetype)initWithChatViewService:(MQChatViewService *)chatService;
/**
 *  ChatCell的代理
 */
@property (nonatomic, weak) id<MQChatCellDelegate> chatCellDelegate;

@end
