//
//  MQEvaluationView.h
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 16/1/19.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MQEvaluationViewDelegate <NSObject>

/**
 *  发送了评价
 *
 *  @param level   评价等级 0-差评 1-中评 2-好评
 *  @param comment 评价内容
 */
- (void)didSelectLevel:(NSInteger)level comment:(NSString *)comment;

@end

@interface MQEvaluationView : NSObject

@property(nonatomic, weak) id<MQEvaluationViewDelegate> delegate;

/**
 *  显示评价的自定义 AlertView
 */
- (void)showEvaluationAlertView;

@end
