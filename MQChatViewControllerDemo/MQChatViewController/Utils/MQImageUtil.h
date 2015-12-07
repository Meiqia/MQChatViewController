//
//  MQImageUtil.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQImageUtil : NSObject

/**
 * 将UIImage的颜色全部进行转换；
 * @param originalImage 原image
 * @param toColor 转换后的颜色
 * @return 更改颜色后的image
 */
+ (UIImage *)convertImageColorWithImage:(UIImage *)originalImage toColor:(UIColor *)toColor;

//截图
+(UIImage *)viewScreenshot:(UIView*)view;

//高斯模糊
+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath;

/**
 * 将一个view根据image的alpha属性进行mask
 * @param view 要被mask的view
 * @param image 带有alpha的image
 */
+ (void)makeMaskView:(UIView *)view withImage:(UIImage *)image;


@end
