//
//  MQChatTableView.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQChatViewModel.h"

@protocol MQChatTableViewDelegate <NSObject>

/** 点击 */
- (void)didTapChatTableView:(UITableView *)tableView;

@end

@interface MQChatTableView : UITableView


@property (nonatomic, strong) MQChatViewModel *chatViewModel;

@property (nonatomic, weak) id<MQChatTableViewDelegate> chatTableViewDelegate;

/** 更新indexPath的cell */
- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath;

@end
