//
//  MQChatTableView.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQChatViewService.h"
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


@property (nonatomic, strong) MQChatViewService *chatViewModel;

@property (nonatomic, weak) id<MQChatTableViewDelegate> chatTableViewDelegate;

@property (nonatomic, strong) MQPullRefreshView *topRefreshView;
@property (nonatomic, strong) MQPullRefreshView *bottomRefreshView;


/** 更新indexPath的cell */
- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  结束上拉刷新
 */
- (void)finishLoadingTopRefreshViewWithCellNumber:(NSInteger)cellNumber isLoadOver:(BOOL)isLoadOver;

/**
 *  结束下拉刷新
 */
- (void)finishLoadingBottomRefreshView;

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

- (void)updateFrame:(CGRect)frame;

/**
 *  判断tableView当前是否已经滑动到最低端
 */
- (BOOL)isTableViewScrolledToBottom;

@end
