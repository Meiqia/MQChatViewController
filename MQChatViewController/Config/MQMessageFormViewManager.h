//
//  MQMessageFormViewManager.h
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/8.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQMessageFormInputModel.h"
#import "MQMessageFormConfig.h"
#import "MQMessageFormViewController.h"

@interface MQMessageFormViewManager : NSObject

/// 预设的聊天界面样式
@property (nonatomic, strong) MQMessageFormViewStyle *messageFormViewStyle;

/**
 * 在一个ViewController中Push出一个留言表单界面
 * @param viewController 在这个viewController中push出留言表单界面
 */
- (MQMessageFormViewController *)pushMQMessageFormViewControllerInViewController:(UIViewController *)viewController;

/**
 * 在一个ViewController中Present出一个留言表单界面的Modal视图
 * @param viewController 在这个viewController中push出留言表单界面
 */
- (MQMessageFormViewController *)presentMQMessageFormViewControllerInViewController:(UIViewController *)viewController;

/**
 * 将留言表单界面移除
 */
- (void)disappearMQMessageFromViewController;

/**
 *  设置自定义留言表单引导文案，配置了该引导文案后将不会读取工作台配置的引导文案
 *
 *  @param customMfimArr 留言表单的引导文案
 */
- (void)setLeaveMessageIntro:(NSString *)leaveMessageIntro;

/**
 *  设置留言表单的自定义输入信息
 *
 *  @param customMessageFormInputModelArray 留言表单的自定义输入信息
 */
- (void)setCustomMessageFormInputModelArray:(NSArray *)customMessageFormInputModelArray;

@end
