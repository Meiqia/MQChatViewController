//
//  MQMessageFormViewStyle.h
//  MQChatViewControllerDemo
//
//  Created by bingoogol on 16/5/11.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

typedef NS_ENUM(NSUInteger, MQMessageFormViewStyleType) {
    MQMessageFormViewStyleTypeDefault,
};

@interface MQMessageFormViewStyle : NSObject

/**
 *  留言表单界面背景色
 *
 * @param backgroundColor
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 *  顶部引导文案颜色
 *
 * @param introTextColor
 */
@property (nonatomic, strong) UIColor *introTextColor;

/**
 *  输入框上方提示文案的颜色
 *
 * @param inputTipTextColor
 */
@property (nonatomic, strong) UIColor *inputTipTextColor;

/**
 *  输入框placeholder文字颜色
 *
 * @param inputPlaceholderTextColor
 */
@property (nonatomic, strong) UIColor *inputPlaceholderTextColor;

/**
 *  输入框文字颜色
 *
 * @param inputTextColor
 */
@property (nonatomic, strong) UIColor *inputTextColor;

/**
 *  输入框上下边框颜色
 *
 * @param inputTopBottomBorderColor
 */
@property (nonatomic, strong) UIColor *inputTopBottomBorderColor;

/**
 *  添加图片的文字颜色
 *
 * @param addPictureTextColor
 */
@property (nonatomic, strong) UIColor *addPictureTextColor;

/**
 *  删除图片的图标
 *
 * @param deleteImage
 */
@property (nonatomic, strong) UIImage *deleteImage;

/**
 *  添加图片的图标
 *
 * @param addImage
 */
@property (nonatomic, strong) UIImage *addImage;

+ (instancetype)defaultStyle;

@end
