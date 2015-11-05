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

/**
 *  设置是否刷新完毕
 *
 *  @param enable YES 还可以刷新  NO 刷新完毕
 */
- (void)setEnableRefresh:(BOOL)enable;

@end
