//
//  MQMessageFormInputModel.h
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/6.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 留言表单界面自定义输入框模型
 */
@interface MQMessageFormInputModel : NSObject

/** 留言表单输入框上方的提示文案 */
@property (nonatomic, copy) NSString *tip;

/** 留言表单输入框placeholder */
@property (nonatomic, copy) NSString *placeholder;

/** 上传服务器是对应的key */
@property (nonatomic, copy) NSString *key;

/** 是否是必填 */
@property (nonatomic, assign) BOOL isRequired;

/** 是否是单行 */
@property (nonatomic, assign) BOOL isSingleLine;

/** 键盘类型 */
@property(nonatomic) UIKeyboardType keyboardType;

@end
