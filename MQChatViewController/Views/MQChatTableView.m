//
//  MQChatTableView.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatTableView.h"
#import "MQChatViewConfig.h"
#import "MQStringSizeUtil.h"
#import "MQBundleUtil.h"

/**
 *  下拉多少距离开启刷新
 */
static CGFloat const kMQChatPullRefreshDistance = 44.0;
static CGFloat const kMQChatNoMoreMessageLabelFontSize = 12.0;
static CGFloat const kMQChatScrollBottomDistanceThreshold = 128.0;

@interface MQChatTableView()

@end

@implementation MQChatTableView {
    //是否开启顶部的自动刷新indicator
    BOOL enableTopAutoRefresh;
    //是否开启顶部下拉刷新
    BOOL enableTopPullRefresh;
    //是否开启底部的上拉刷新
    BOOL enableBottomPullRefresh;
    //表明是否正在获取顶部的消息
    BOOL isLoadingTopMessages;
    //表明是否正在获取底部的消息
    BOOL isLoadingBottomMessages;
    //自动刷新的indicator
    UIActivityIndicatorView *topAutoRefreshIndicator;
    //在开启自动刷新顶部消息时，该属性才有用
    BOOL didPullRefreshView;
    //在加载历史消息时的offset
    CGFloat scrollOffsetAfterLoading;
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
        scrollOffsetAfterLoading = 0.0;
        //初始化上拉、下拉刷新
        didPullRefreshView = false;
        isLoadingTopMessages = false;
        isLoadingBottomMessages = false;
        enableTopAutoRefresh = [MQChatViewConfig sharedConfig].enableTopAutoRefresh;
        enableTopPullRefresh = [MQChatViewConfig sharedConfig].enableTopPullRefresh || enableTopAutoRefresh;
        enableBottomPullRefresh = [MQChatViewConfig sharedConfig].enableBottomPullRefresh;
        
        if (enableTopPullRefresh) {
            [self initTopPullRefreshView];
        }
        if (enableBottomPullRefresh) {
            [self initBottomPullRefreshView];
        }
    }
    return self;
}

#pragma 初始化三种刷新控件
- (void)initTopAutoRefreshView {
    if (topAutoRefreshIndicator) {
        return;
    }
    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kMQChatPullRefreshDistance)];
    CGRect indicatorFrame = self.frame;
    topAutoRefreshIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatorFrame = topAutoRefreshIndicator.frame;
    indicatorFrame.origin.x = self.frame.size.width/2-indicatorFrame.size.width/2;
    indicatorFrame.origin.y = self.tableHeaderView.frame.size.height/2-indicatorFrame.size.height/2;
    topAutoRefreshIndicator.frame = indicatorFrame;
    [topAutoRefreshIndicator startAnimating];
    [self.tableHeaderView addSubview:topAutoRefreshIndicator];
}

- (void)cancelTopAutoRefreshView {
    [topAutoRefreshIndicator removeFromSuperview];
    UILabel *noMoreMessageLabel = [[UILabel alloc] init];
    noMoreMessageLabel.textAlignment = NSTextAlignmentCenter;
    noMoreMessageLabel.text = [MQBundleUtil localizedStringForKey:@"no_more_messages"];
    noMoreMessageLabel.font = [UIFont systemFontOfSize:kMQChatNoMoreMessageLabelFontSize];
    noMoreMessageLabel.textColor = [UIColor grayColor];
    noMoreMessageLabel.backgroundColor = [UIColor clearColor];
    CGFloat textHeight = [MQStringSizeUtil getHeightForText:noMoreMessageLabel.text withFont:noMoreMessageLabel.font andWidth:self.frame.size.width];
    if (!self.tableHeaderView) {
        self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kMQChatPullRefreshDistance)];
    }
    noMoreMessageLabel.frame = CGRectMake(0, self.tableHeaderView.frame.size.height/2 - textHeight/2, self.tableHeaderView.frame.size.width, textHeight);
    noMoreMessageLabel.alpha = 0.0;
    [self.tableHeaderView addSubview:noMoreMessageLabel];
    [UIView animateWithDuration:0.5 animations:^{
        noMoreMessageLabel.alpha = 1.0;
    }];
}

- (void)initTopPullRefreshView {
    self.topRefreshView = [[MQPullRefreshView alloc] initWithSuperScrollView:self isTopRefresh:true];
    [self.topRefreshView setRefreshTitle:[MQBundleUtil localizedStringForKey:@"no_more_messages"]];
    [self.topRefreshView setPullRefreshStrokeColor:[MQChatViewConfig sharedConfig].pullRefreshColor];
    [self addSubview:self.topRefreshView];
}

- (void)initBottomPullRefreshView {
    self.bottomRefreshView = [[MQPullRefreshView alloc] initWithSuperScrollView:self isTopRefresh:false];
    [self.bottomRefreshView setRefreshTitle:[MQBundleUtil localizedStringForKey:@"no_more_messages"]];
    [self.topRefreshView setPullRefreshStrokeColor:[MQChatViewConfig sharedConfig].pullRefreshColor];
    [self addSubview:self.bottomRefreshView];
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
- (void)startLoadingAutoTopRefreshView {
    if (enableTopPullRefresh && !isLoadingTopMessages) {
        isLoadingTopMessages = true;
        if (self.chatTableViewDelegate) {
            if ([self.chatTableViewDelegate respondsToSelector:@selector(startLoadingTopMessagesInTableView:)]) {
                [self.chatTableViewDelegate startLoadingTopMessagesInTableView:self];
            }
        }
    }
}

- (void)startLoadingTopRefreshView {
    if (enableTopPullRefresh && !isLoadingTopMessages) {
        isLoadingTopMessages = true;
        [self.topRefreshView startLoading];
        if (self.chatTableViewDelegate) {
            if ([self.chatTableViewDelegate respondsToSelector:@selector(startLoadingTopMessagesInTableView:)]) {
                [self.chatTableViewDelegate startLoadingTopMessagesInTableView:self];
            }
        }
    }
}

- (void)finishLoadingTopRefreshViewWithCellNumber:(NSInteger)cellNumber isLoadOver:(BOOL)isLoadOver {
    if (isLoadOver) {
        [self cancelTopAutoRefreshView];
    } else {
        [self initTopAutoRefreshView];
    }
    if (enableTopPullRefresh && isLoadingTopMessages) {
        isLoadingTopMessages = false;
        [self.topRefreshView finishLoading];
        //在开启自动顶部刷新，则隐藏topRefreshView
        didPullRefreshView = true;
        if (enableTopAutoRefresh && cellNumber > 0) {
            self.topRefreshView.hidden = true;
        }
        if (isLoadOver) {
            self.topRefreshView.hidden = true;
            enableTopPullRefresh = false;
            enableTopAutoRefresh = false;
        }
    }
    if (cellNumber > 1) {
        [self scrollToCellIndex:cellNumber-1];
    }
}

- (void)scrollToCellIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    CGPoint tableViewOffset = self.contentOffset;
    tableViewOffset.y -= scrollOffsetAfterLoading;
    self.contentOffset = tableViewOffset;
}

- (void)startLoadingBottomRefreshView {
    if (enableBottomPullRefresh && !isLoadingBottomMessages) {
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
    if (enableBottomPullRefresh && isLoadingBottomMessages) {
        isLoadingBottomMessages = false;
        [self.bottomRefreshView finishLoading];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (enableTopPullRefresh) {
        [self.topRefreshView scrollViewDidScroll:scrollView];
    }
    if (enableBottomPullRefresh) {
        [self.bottomRefreshView scrollViewDidScroll:scrollView];
    }
    BOOL didPullAutoTopRefresh = (scrollView.contentOffset.y < 0) && enableTopAutoRefresh;
    if (didPullAutoTopRefresh && didPullRefreshView && enableTopAutoRefresh) {
        [self startLoadingAutoTopRefreshView];
    }
    if (self.contentOffset.y < 0) {
        CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        scrollOffsetAfterLoading = fabs(self.contentOffset.y)-statusHeight;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    BOOL didPullTopRefreshView = (scrollView.contentOffset.y + scrollView.contentInset.top <= -kMQChatPullRefreshDistance) && enableTopPullRefresh;
    if (didPullTopRefreshView) {
        //开启下拉刷新(顶部刷新)的条件
        [self startLoadingTopRefreshView];
    }else if (((scrollView.contentSize.height>scrollView.frame.size.height && scrollView.contentSize.height - scrollView.frame.size.height < scrollView.contentOffset.y + self.topRefreshView.kMQTableViewContentTopOffset - kMQChatPullRefreshDistance)
               || (scrollView.contentSize.height<scrollView.frame.size.height && scrollView.contentOffset.y + self.topRefreshView.kMQTableViewContentTopOffset > kMQChatPullRefreshDistance))
              && enableBottomPullRefresh) {
        //开启上拉刷新（底部刷新）的条件
        [self startLoadingBottomRefreshView];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    //    BOOL didPullAutoTopRefresh = (scrollView.contentOffset.y < 0) && enableTopAutoRefresh;
    //    if (didPullAutoTopRefresh && didPullRefreshView && enableTopAutoRefresh) {
    //        [self startLoadingAutoTopRefreshView];
    //    }
    //    if(self.contentOffset.y < 0){
    //        CGFloat statusHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    //        scrollOffsetAfterLoading = fabs(self.contentOffset.y)-statusHeight;
    //    }
}

- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    if (enableTopAutoRefresh) {
        [self updateTopAutoRefreshViewFrame];
    }
    if (enableTopPullRefresh) {
        [self.topRefreshView updateFrame];
    }
    if (enableBottomPullRefresh) {
        [self.bottomRefreshView updateFrame];
    }
}

- (void)updateTopAutoRefreshViewFrame {
    topAutoRefreshIndicator.frame = CGRectMake(self.frame.size.width/2 - topAutoRefreshIndicator.frame.size.width/2, topAutoRefreshIndicator.frame.origin.y, topAutoRefreshIndicator.frame.size.width, topAutoRefreshIndicator.frame.size.height);
}

- (BOOL)isTableViewScrolledToBottom {
    if(self.contentOffset.y + self.frame.size.height + kMQChatScrollBottomDistanceThreshold > self.contentSize.height){
        return true;
    } else {
        return false;
    }
}

@end
