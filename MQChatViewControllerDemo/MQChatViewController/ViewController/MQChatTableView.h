//
//  MQChatTableView.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQChatViewModel.h"
#import "MQPullRefreshView.h"

@protocol MQChatTableViewDelegate <NSObject>

/** 点击 */
- (void)didTapChatTableView:(UITableView *)tableView;

/**
 *  开始下拉刷新（顶部刷新）
 */
- (void)startLoadingTopMessagesInTableView:(UITableView *)tableView;

/**
 *  开始上拉刷新（底部刷新）
 */
- (void)startLoadingBottomMessagesInTableView:(UITableView *)tableView;

@end

@interface MQChatTableView : UITableView


@property (nonatomic, strong) MQChatViewModel *chatViewModel;

@property (nonatomic, weak) id<MQChatTableViewDelegate> chatTableViewDelegate;

@property (nonatomic, strong) MQPullRefreshView *topRefreshView;
@property (nonatomic, strong) MQPullRefreshView *bottomRefreshView;


/** 更新indexPath的cell */
- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  结束上拉刷新
 */
- (void)finishLoadingTopRefreshView;

/**
 *  结束下拉刷新
 */
- (void)finishLoadingBottomRefreshView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
