//
//  MQStringSizeUtil.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQStringSizeUtil.h"

@implementation MQStringSizeUtil

+ (CGFloat) getHeightForText:(NSString *) text withFont:(UIFont *) font andWidth:(CGFloat) width{
    CGSize constraint = CGSizeMake(width , 20000.0f);
    CGSize title_size;
    CGFloat totalHeight;
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        totalHeight = ceil(title_size.height);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        title_size = [text sizeWithFont:font
                      constrainedToSize:constraint
                          lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        totalHeight = title_size.height ;
    }
    
    return totalHeight;
}

+ (CGFloat) getWidthForText:(NSString *) text withFont:(UIFont *) font andHeight:(CGFloat) height{
    CGSize constraint = CGSizeMake(20000.0f , height);
    CGSize title_size;
    CGFloat width;
    SEL selector = @selector(boundingRectWithSize:options:attributes:context:);
    if ([text respondsToSelector:selector]) {
        title_size = [text boundingRectWithSize:constraint
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{ NSFontAttributeName : font }
                                        context:nil].size;
        
        width = ceil(title_size.width);
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        title_size = [text sizeWithFont:font
                      constrainedToSize:constraint
                          lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        width = title_size.width ;
    }
    
    return width;
}

+(CGFloat) getWidthForText:(NSString *) text withAttributes:(NSDictionary *)attributes andHeight:(CGFloat) height{
    CGSize constraint = CGSizeMake(20000.0f , height);
    CGSize title_size;
    CGFloat width;
    title_size = [text boundingRectWithSize:constraint
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil].size;
    
    width = ceil(title_size.width);
    
    return width;
}

+(CGFloat) getHeightForText:(NSString *) text withAttributes:(NSDictionary *)attributes andWidth:(CGFloat) width{
    CGSize constraint = CGSizeMake(width , CGFLOAT_MAX);
    CGSize title_size;
    CGFloat totalHeight;
    title_size = [text boundingRectWithSize:constraint
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                 attributes:attributes
                                    context:nil].size;
    
    totalHeight = ceil(title_size.height);
    
    return totalHeight;
}

+ (CGFloat)getHeightForAttributedText:(NSAttributedString *)attributedText
                            textWidth:(CGFloat)textWidth
{
    CGSize constraint = CGSizeMake(textWidth , CGFLOAT_MAX);
    CGSize title_size;
    CGFloat totalHeight;
    title_size = [attributedText boundingRectWithSize:constraint
                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                    context:nil].size;
    
    totalHeight = ceil(title_size.height);
    
    return totalHeight;
}

+ (CGFloat)getWidthForAttributedText:(NSAttributedString *)attributedText
                          textHeight:(CGFloat)textHeight
{
    CGSize constraint = CGSizeMake(CGFLOAT_MAX , textHeight);
    CGSize title_size;
    CGFloat width;
    title_size = [attributedText boundingRectWithSize:constraint
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil].size;
    
    width = ceil(title_size.width);
    return width;
}

//将自然数转化为以k为单位的数值的字符串
+ (NSString *)convertNaturalNumToShortAbNum:(NSUInteger)number{
    NSString *abNum;
    if(number<1000){
        abNum = [NSString stringWithFormat:@"%d",(int)number];
        return abNum;
    }else if(number>=1000 && number<10000){
        CGFloat kNum = ((CGFloat)number)/1000.0f;
        abNum = [NSString stringWithFormat:@"%f",kNum];
        NSRange dotRange = [abNum rangeOfString:@"."];
        NSRange afterDotRange = NSMakeRange(dotRange.location+1, 1);
        if([[abNum substringWithRange:afterDotRange] isEqualToString:@"0"]){
            abNum = [abNum substringToIndex:1];
        }else{
            abNum = [abNum substringToIndex:afterDotRange.location+1];
        }
    }else if(number>=10000 && number<100000){
        abNum = [[NSString stringWithFormat:@"%d",(int)number] substringToIndex:2];
    }
    else if(number>=100000 && number<1000000){
        abNum = [[NSString stringWithFormat:@"%d",(int)number] substringToIndex:3];
    }else{
        abNum = [NSString stringWithFormat:@"%d",999];
    }
    abNum = [NSString stringWithFormat:@"%@%@",abNum,@"k"];
    return abNum;
}

@end
