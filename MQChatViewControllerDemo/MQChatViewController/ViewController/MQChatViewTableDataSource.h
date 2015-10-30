//
//  MQChatViewTableDataSource.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQChatViewModel.h"

/**
 * @brief 客服聊天界面中的UITableView的datasource
 */
@interface MQChatViewTableDataSource : NSObject <UITableViewDataSource>

- (instancetype)initWithTableView:(UITableView *)tableView  chatViewModel:(MQChatViewModel *)viewModel;

@end
