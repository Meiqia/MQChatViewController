//
//  MQPullRefreshView.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/5.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQPullRefreshView.h"
#import "MQChatViewConfig.h"

static CGFloat const kMQPullRefreshViewHeight = 44.0;
static CGFloat const kMQIndicatorDiameter = 20.0;

@interface MQPullRefreshView()

/**
 *  拥有下拉刷新的scrollView
 */
@property (nonatomic, weak) UIScrollView *superScrollView;

@end

@implementation MQPullRefreshView {
    UIView *loadingIndicatorView;
    UIActivityIndicatorView *loadingIndicator;
    CAShapeLayer *loadProgressLayer;
    UIBezierPath *path;
    BOOL isTopRefresh;          //表明是上拉刷新还是下拉刷新 true-下拉刷新(获取之前的信息)  false-上拉刷新(获取之后的信息)
    UILabel *titleLabel;
    BOOL isLoading;
    BOOL enableRefresh;          //表明是否开启刷新；可用来表明已经没有更多数据可以刷新
    
}

- (instancetype)initWithSuperScrollView:(UIScrollView *)scrollView
                           isTopRefresh:(BOOL)topRefresh {
    self = [super init];
    if (self) {
        self.superScrollView = scrollView;
        isLoading = false;
        enableRefresh = true;
        isTopRefresh = topRefresh;
        if (isTopRefresh) {
            self.frame = CGRectMake(0, -kMQPullRefreshViewHeight, self.superScrollView.frame.size.width, kMQPullRefreshViewHeight);
        } else {
            self.frame = CGRectMake(0, self.superScrollView.frame.size.height, self.superScrollView.frame.size.width, kMQPullRefreshViewHeight);
        }
        //初始化indicatorView
        loadingIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - kMQIndicatorDiameter/2, self.frame.size.height/2 - kMQIndicatorDiameter/2, kMQIndicatorDiameter, kMQIndicatorDiameter)];
        //初始化indicator
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.hidden = true;
        [loadingIndicatorView addSubview:loadingIndicator];
        //初始化loadProgressLayer
        loadProgressLayer = [CAShapeLayer layer];
        loadProgressLayer.fillColor = [UIColor clearColor].CGColor;
        loadProgressLayer.strokeColor = [MQChatViewConfig sharedConfig].pullRefreshColor;
    }
    return self;
}

@end
