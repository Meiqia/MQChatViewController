//
//  MQPullRefreshView.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/5.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "MQPullRefreshView.h"

static CGFloat const kMQPullRefreshViewHeight = 44.0;
static CGFloat const kMQPullRefreshIndicatorDiameter = 20.0;
static CGFloat const kMQPullRefreshTitleFontSize = 12.0;

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
    UIBezierPath *bezierPath;
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
        loadingIndicatorView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2 - kMQPullRefreshIndicatorDiameter/2, self.frame.size.height/2 - kMQPullRefreshIndicatorDiameter/2, kMQPullRefreshIndicatorDiameter, kMQPullRefreshIndicatorDiameter)];
        //初始化indicator
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.hidden = true;
        [loadingIndicatorView addSubview:loadingIndicator];
        //初始化loadProgressLayer
        loadProgressLayer = [CAShapeLayer layer];
        loadProgressLayer.fillColor = [UIColor clearColor].CGColor;
        loadProgressLayer.lineWidth = 1.5;
        [loadingIndicatorView.layer addSublayer:loadProgressLayer];
        [self addSubview:loadingIndicatorView];
        //初始化贝塞尔path
        bezierPath = [UIBezierPath bezierPath];
        //初始化注释title
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height/2 - kMQPullRefreshIndicatorDiameter/2, self.frame.size.height, kMQPullRefreshIndicatorDiameter)];
        titleLabel.text = @"刷新不了啦~";
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = [UIFont systemFontOfSize:kMQPullRefreshTitleFontSize];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.hidden = true;
        [self addSubview:titleLabel];
    }
    return self;
}

- (void)setPullRefreshStrokeColor:(UIColor *)strokeColor {
    loadProgressLayer.strokeColor = strokeColor.CGColor;
}

- (void)setEnableRefresh:(BOOL)enable {
    enableRefresh = enable;
    if (enableRefresh) {
        titleLabel.hidden = true;
        loadingIndicatorView.hidden = false;
    } else {
        titleLabel.hidden = false;
        loadingIndicatorView.hidden = true;
    }
}

- (void)setRefreshTitle:(NSString *)title {
    titleLabel.text = title;
}

- (void)startLoading {
    if (!isLoading && enableRefresh) {
        isLoading = true;
        [loadProgressLayer removeFromSuperlayer];
        loadingIndicator.hidden = false;
        [loadingIndicator startAnimating];
        CGFloat contentInsetTop = isTopRefresh ? self.superScrollView.contentInset.top + self.frame.size.height : self.superScrollView.contentInset.top - self.frame.size.height;
        self.superScrollView.contentInset = UIEdgeInsetsMake(contentInsetTop, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
//        CGFloat contentInsetTop = isTopRefresh ? self.superScrollView.contentInset.top + self.frame.size.height : self.superScrollView.contentInset.top;
//        CGFloat contentInsetBottom = isTopRefresh ? self.superScrollView.contentInset.bottom : self.superScrollView.contentInset.bottom - self.frame.size.height;
//        self.superScrollView.contentInset = UIEdgeInsetsMake(contentInsetTop, self.superScrollView.contentInset.left, contentInsetBottom, self.superScrollView.contentInset.right);
    }
}

- (void)finishLoading {
    if (isLoading) {
        isLoading = false;
        [loadingIndicatorView.layer addSublayer:loadProgressLayer];
        loadingIndicator.hidden = true;
        [loadingIndicator stopAnimating];
        CGFloat contentInsetTop = isTopRefresh ? self.superScrollView.contentInset.top - self.frame.size.height : self.superScrollView.contentInset.top + self.frame.size.height;
        self.superScrollView.contentInset = UIEdgeInsetsMake(contentInsetTop, self.superScrollView.contentInset.left, self.superScrollView.contentInset.bottom, self.superScrollView.contentInset.right);
    }
}

#pragma UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat navHeight = [[UINavigationController alloc] init].navigationBar.frame.size.height;
//    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    //是否是底部上拉刷新
//    BOOL isBottomRefreshEn = !isTopRefresh && (scrollView.contentSize.height-scrollView.frame.size.height<scrollView.contentOffset.y || (scrollView.frame.size.height>scrollView.contentSize.height && scrollView.contentOffset.y > -(navHeight+statusBarHeight)));
    BOOL isBottomRefreshEn = !isTopRefresh && (scrollView.contentSize.height-scrollView.frame.size.height<scrollView.contentOffset.y || (scrollView.frame.size.height>scrollView.contentSize.height && scrollView.contentOffset.y > 0));
    //计算bottomRefreshView的位置
    if (!isTopRefresh) {
        CGFloat refreshViewOriginY = 0;
        if (scrollView.frame.size.height > scrollView.contentSize.height) {
//            refreshViewOriginY = scrollView.frame.size.height - navHeight*3/2;
            refreshViewOriginY = scrollView.frame.size.height;
        }else{
            refreshViewOriginY = scrollView.contentSize.height;
        }
        self.frame = CGRectMake(self.frame.origin.x, refreshViewOriginY, self.frame.size.width, self.frame.size.height);
    }
    if ((scrollView.contentOffset.y < 0 && isTopRefresh) || isBottomRefreshEn) {
//        if ((scrollView.contentOffset.y < -(navHeight+statusBarHeight) && isTopRefresh) || isBottomRefreshEn) {
        if (!isLoading && enableRefresh) {
            CGFloat position = 0;
            if (isTopRefresh) {
                position = -(scrollView.contentOffset.y + scrollView.contentInset.top ) / (self.frame.size.height);
            }else{
                if (scrollView.contentSize.height < scrollView.frame.size.height) {
//                    position = (scrollView.contentOffset.y + navHeight + statusBarHeight) / (self.frame.size.height);
                    position = (scrollView.contentOffset.y) / (self.frame.size.height);
                }else{
                    position = (scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height) / (self.frame.size.height);
                }
            }
            position = position >= 1 ? 0.9999999 : position < 0 ? 0 : position;
            [bezierPath removeAllPoints];
            [bezierPath addArcWithCenter:CGPointMake(loadingIndicatorView.frame.size.width/2,loadingIndicatorView.frame.size.height/2) radius:loadingIndicatorView.frame.size.height / 2 startAngle:M_PI * 2 endAngle:position * 2 * M_PI clockwise:true];
            loadProgressLayer.path = bezierPath.CGPath;
        }
    }
}

- (void)updateFrame {
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.superScrollView.frame.size.width, self.frame.size.height);
    loadingIndicatorView.frame = CGRectMake(self.frame.size.width/2 - kMQPullRefreshIndicatorDiameter/2, self.frame.size.height/2 - kMQPullRefreshIndicatorDiameter/2, kMQPullRefreshIndicatorDiameter, kMQPullRefreshIndicatorDiameter);
    titleLabel.frame = CGRectMake(0, self.frame.size.height/2 - kMQPullRefreshIndicatorDiameter/2, self.frame.size.height, kMQPullRefreshIndicatorDiameter);
}



@end
