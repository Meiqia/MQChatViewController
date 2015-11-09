//
//  MQChatTableView.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatTableView.h"
#import "MQChatViewConfig.h"

/**
 *  下拉多少距离开启刷新
 */
static CGFloat const kMQChatPullRefreshDistance = 44.0;



@interface MQChatTableView()<UIScrollViewDelegate>

@end

@implementation MQChatTableView {
    BOOL enableTopRefresh;
    BOOL enableBottomRefresh;
    //表明是否正在获取顶部的消息
    BOOL isLoadingTopMessages;
    //表明是否正在获取底部的消息
    BOOL isLoadingBottomMessages;
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChatTableView:)];
        tapViewGesture.cancelsTouchesInView = false;
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tapViewGesture];
        //初始化上拉、下拉刷新
        isLoadingTopMessages = false;
        isLoadingBottomMessages = false;
        enableTopRefresh = [MQChatViewConfig sharedConfig].enableTopPullRefresh;
        enableBottomRefresh = [MQChatViewConfig sharedConfig].enableBottomPullRefresh;
        if (enableTopRefresh) {
            self.topRefreshView = [[MQPullRefreshView alloc] initWithSuperScrollView:self isTopRefresh:true];
            [self.topRefreshView setRefreshTitle:@"没有更多消息啦~"];
            [self.topRefreshView setPullRefreshStrokeColor:[MQChatViewConfig sharedConfig].pullRefreshColor];
            [self addSubview:self.topRefreshView];
        }
        if (enableBottomRefresh) {
            self.bottomRefreshView = [[MQPullRefreshView alloc] initWithSuperScrollView:self isTopRefresh:false];
            [self.bottomRefreshView setRefreshTitle:@"没有更多消息啦~"];
            [self.topRefreshView setPullRefreshStrokeColor:[MQChatViewConfig sharedConfig].pullRefreshColor];
            [self addSubview:self.bottomRefreshView];
        }
        
    }
    return self;
}

- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath {
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

/** 点击tableView的事件 */
- (void)tapChatTableView:(id)sender {
    if (self.chatTableViewDelegate) {
        if ([self.chatTableViewDelegate respondsToSelector:@selector(didTapChatTableView:)]) {
            [self.chatTableViewDelegate didTapChatTableView:self];
        }
    }
}

#pragma 有关pull refresh的方法
- (void)startLoadingTopRefreshView {
    if (enableTopRefresh && !isLoadingTopMessages) {
        isLoadingTopMessages = true;
        [self.topRefreshView startLoading];
        if (self.chatTableViewDelegate) {
            if ([self.chatTableViewDelegate respondsToSelector:@selector(startLoadingTopMessagesInTableView:)]) {
                [self.chatTableViewDelegate startLoadingTopMessagesInTableView:self];
            }
        }
    }
}

- (void)finishLoadingTopRefreshView {
    if (enableTopRefresh && isLoadingTopMessages) {
        isLoadingTopMessages = false;
        [self.topRefreshView finishLoading];
    }
}

- (void)startLoadingBottomRefreshView {
    if (enableBottomRefresh && !isLoadingBottomMessages) {
        isLoadingBottomMessages = true;
        [self.bottomRefreshView startLoading];
        if (self.chatTableViewDelegate) {
            if ([self.chatTableViewDelegate respondsToSelector:@selector(startLoadingBottomMessagesInTableView:)]) {
                [self.chatTableViewDelegate startLoadingBottomMessagesInTableView:self];
            }
        }
    }
}

- (void)finishLoadingBottomRefreshView {
    if (enableBottomRefresh && isLoadingBottomMessages) {
        isLoadingBottomMessages = false;
        [self.bottomRefreshView finishLoading];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (enableTopRefresh) {
        [self.topRefreshView scrollViewDidScroll:scrollView];
    }
    if (enableBottomRefresh) {
        [self.bottomRefreshView scrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ((scrollView.contentOffset.y + scrollView.contentInset.top <= -kMQChatPullRefreshDistance)) {
        //开启下拉刷新(顶部刷新)的条件
        [self startLoadingTopRefreshView];
    }else if (((scrollView.contentSize.height>scrollView.frame.size.height && scrollView.contentSize.height - scrollView.frame.size.height < scrollView.contentOffset.y + self.topRefreshView.kMQTableViewContentTopOffset - kMQChatPullRefreshDistance)
               || (scrollView.contentSize.height<scrollView.frame.size.height && scrollView.contentOffset.y + self.topRefreshView.kMQTableViewContentTopOffset > kMQChatPullRefreshDistance))
              && enableBottomRefresh) {
        //开启上拉刷新（底部杀心）的条件
        [self startLoadingBottomRefreshView];
    }
}

- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    if (enableTopRefresh) {
        [self.topRefreshView updateFrame];
    }
    if (enableBottomRefresh) {
        [self.bottomRefreshView updateFrame];
    }
}



@end
