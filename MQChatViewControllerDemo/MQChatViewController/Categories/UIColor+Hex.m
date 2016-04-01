//
//  UIColor+Hex.m
//  AutoGang
//
//  Created by luoxu on 14/12/20.
//  Copyright (c) 2014年 com.qcb008.QiCheApp. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor(Hex)

+ (UIColor *)colorWithHex:(long)hexColor
{
    return [self colorWithHex:hexColor alpha:1.0];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)a
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:a];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    unsigned result = 0;
    [scanner scanHexInt:&result];
    return [self.class colorWithHex:result];
}

+ (UIColor *)getDarkerColorFromColor1:(UIColor *)color1 color2:(UIColor *)color2 {
    if ([color1 colorNumber] > [color2 colorNumber]) {
        return color2;
    } else {
        return color1;
    }
}

- (float)colorNumber {
    double r,g,b,a;
    [self getRed:&r green:&g blue:&b alpha:&a];
    return r + g + b + a;
}

@end
