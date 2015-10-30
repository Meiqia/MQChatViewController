//
//  MQChatViewController.h
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQChatViewConfig.h"
#import "MQChatTableView.h"

/**
 * @brief 客服聊天界面的ViewController
 *
 * 虽然开发者可以根据MQChatViewController暴露的接口来自定义界面，但推荐做法是通过MQChatViewManager中提供的接口，来对客服聊天界面进行自定义配置；
 */
@interface MQChatViewController : UIViewController

/**
 * @brief 客服聊天界面的tableView
 */
@property (nonatomic, strong) MQChatTableView *chatTableView;



/**
 * 根据配置初始化客服聊天界面
 * @param manager 初始化配置
 */
- (instancetype)initWithChatViewManager:(MQChatViewConfig *)chatViewConfig;

@end
