//
//  MQMessageFormViewController.h
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/4.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MQMessageFormConfig.h"

/**
 * @brief 留言表单界面的ViewController
 *
 */
@interface MQMessageFormViewController : UIViewController

/**
 * 根据配置初始化留言表单界面
 * @param manager 初始化配置
 */
- (instancetype)initWithConfig:(MQMessageFormConfig *)config;

/**
 *  关闭留言表单界面
 */
- (void)dismissMessageFormViewController;

@end
