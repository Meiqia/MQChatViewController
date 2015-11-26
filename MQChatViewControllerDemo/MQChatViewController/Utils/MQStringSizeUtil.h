//
//  MQStringSizeUtil.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQStringSizeUtil : NSObject

/**
 * 根据文字的font和width来获取text的高度；
 * @param text  文字
 * @param font  文字font
 * @param width 该段文字的宽度
 */
+ (CGFloat) getHeightForText:(NSString *)text
                 withFont:(UIFont *)font
                 andWidth:(CGFloat)width;

/**
 * 根据文字的attributes和width来获取text的高度；
 * @param text  文字
 * @param attributes  文字attributes
 * @param width 该段文字的宽度
 */
+ (CGFloat) getHeightForText:(NSString *)text
             withAttributes:(NSDictionary *)attributes
                   andWidth:(CGFloat)width;

/**
 * 根据文字的font和height来获取text的宽度；
 * @param text  文字
 * @param font  文字font
 * @param height 该段文字的高度
 */
+ (CGFloat) getWidthForText:(NSString *)text
                withFont:(UIFont *)font
               andHeight:(CGFloat)height;

/**
 * 根据文字的attributes和height来获取text的宽度；
 * @param text  文字
 * @param attributes  文字attributes
 * @param height 该段文字的高度
 */
+ (CGFloat) getWidthForText:(NSString *)text
            withAttributes:(NSDictionary *)attributes
                 andHeight:(CGFloat)height;

/**
 * 将数字转换成以k为单位的string；
 * @param number  被转换的数字
 */
+ (NSString *)convertNaturalNumToShortAbNum:(NSUInteger)number;


/**
 *  获取NSAttributedString的宽度
 */
+ (CGFloat)getHeightForAttributedText:(NSAttributedString *)attributedText
                            textWidth:(CGFloat)textWidth;

/**
 *  获取NSAttributedString的高度
 */
+ (CGFloat)getWidthForAttributedText:(NSAttributedString *)attributedText
                          textHeight:(CGFloat)textHeight;

@end
