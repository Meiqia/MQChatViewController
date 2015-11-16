//
//  MQChatViewController.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQChatViewConfig.h"
#import "MQChatTableView.h"
#ifdef INCLUDE_MEIQIA_SDK
#import "MQServiceToViewInterface.h"
#endif

/**
 * @brief 聊天界面的ViewController
 *
 * 虽然开发者可以根据MQChatViewController暴露的接口来自定义界面，但推荐做法是通过MQChatViewManager中提供的接口，来对客服聊天界面进行自定义配置；
 */
@interface MQChatViewController : UIViewController

/**
 * @brief 聊天界面的tableView
 */
@property (nonatomic, strong) MQChatTableView *chatTableView;

/**
 * @brief 聊天界面底部的输入框view
 */
@property (nonatomic, strong) UIView *inputBarView;

/**
 * @brief 聊天界面底部的输入框view
 */
@property (nonatomic, strong) UITextView *inputBarTextView;

//聊天界面是否还在初始化，初始化完成后才允许用户发送消息（默认NO）
@property (nonatomic, assign) BOOL       isInitializing;

/**
 * 根据配置初始化客服聊天界面
 * @param manager 初始化配置
 */
- (instancetype)initWithChatViewManager:(MQChatViewConfig *)chatViewConfig;

/**
 *  关闭聊天界面
 */
- (void)dismissChatViewController;

#ifdef INCLUDE_MEIQIA_SDK
/**
 *  聊天界面的委托方法
 */
@property (nonatomic, weak) id<MQServiceToViewInterfaceDelegate> serviceToViewDelegate;
#endif

@end
