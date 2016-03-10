//
//  MQPullRefreshView.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/11/5.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQPullRefreshView : UIView

@property (nonatomic, assign) CGFloat kMQTableViewContentTopOffset;

/**
 *  初始化上拉/下拉刷新
 *
 *  @param scrollView 在哪个scrollView上显示
 *  @param topRefresh 是否是上拉刷新  YES：上拉刷新  NO：下拉刷新
 *
 *  @return MQPullRefreshView
 */
- (instancetype)initWithSuperScrollView:(UIScrollView *)scrollView
                           isTopRefresh:(BOOL)topRefresh;

/**
 *  设置是否刷新完毕
 *
 *  @param enable YES 还可以刷新  NO 刷新完毕
 */
- (void)setEnableRefresh:(BOOL)enable;

/**
 *  设置不再刷新的title
 *
 *  @param title 不再刷新的title
 */
- (void)setRefreshTitle:(NSString *)title;

/**
 *  开始刷新
 */
- (void)startLoading;

/**
 *  结束刷新
 */
- (void)finishLoading;

/**
 *  scrollView开始滑动
 *
 *  @param scrollView 加载上拉/下拉刷新的scrollView
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

/**
 *  更新frame
 */
- (void)updateFrame;

/**
 *  设置下拉刷新的color
 *
 *  @param strokeColor 下拉刷新的圆环color
 */
- (void)setPullRefreshStrokeColor:(UIColor *)strokeColor;

@end
