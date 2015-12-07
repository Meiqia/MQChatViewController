//
//  MQImageUtil.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQImageUtil.h"
#import <Accelerate/Accelerate.h>
#import "MQBundleUtil.h"

@implementation MQImageUtil

+ (UIImage *)convertImageColorWithImage:(UIImage *)originalImage toColor:(UIColor *)toColor {
    if (originalImage != nil) {
        CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, originalImage.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextClipToMask(context, rect, originalImage.CGImage);
        CGContextSetFillColorWithColor(context, [toColor CGColor]);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    } else {
        return nil;
    }
}

+(UIImage *)viewScreenshot:(UIView*)view{
    UIGraphicsBeginImageContext(view.frame.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //调整画质
    NSData *imageData = UIImageJPEGRepresentation(image, 0.75);
    image = [UIImage imageWithData:imageData];
    
    return image;
}

+(UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur exclusionPath:(UIBezierPath *)exclusionPath
{
    if (blur > 1.f) {
        blur = 1;
    }else if (blur < 0){
        return image;
    }
    
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //创建大小不变的UIBezierPath
    UIImage *unblurredImage = nil;
    if (exclusionPath != nil) {
        CAShapeLayer *maskLayer = [CAShapeLayer new];
        maskLayer.frame = (CGRect){CGPointZero, image.size};
        maskLayer.backgroundColor = [UIColor blackColor].CGColor;
        maskLayer.fillColor = [UIColor whiteColor].CGColor;
        maskLayer.path = exclusionPath.CGPath;
        
        //创建灰度图像以掩盖背景
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
        CGContextRef context = CGBitmapContextCreate(nil, maskLayer.bounds.size.width, maskLayer.bounds.size.height, 8, 0, colorSpace, kCGBitmapAlphaInfoMask);
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        [maskLayer renderInContext:context];
        CGImageRef imageRef = CGBitmapContextCreateImage(context);
        UIImage *maskImage = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
        
        UIGraphicsBeginImageContext(image.size);
        context = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(context, 0, maskLayer.bounds.size.height);
        CGContextScaleCTM(context, 1.f, -1.f);
        CGContextClipToMask(context, maskLayer.bounds, maskImage.CGImage);
        CGContextDrawImage(context, maskLayer.bounds, image.CGImage);
        unblurredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    //使用CGImageRef创建vImage_Buffer
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //创建vImage_Buffer输出
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"MeChatSDK Error: No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    // 创建中间处理第三缓冲器
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    //convolution
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"MeChatSDK Error: error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             5);
    CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //是否是叠加图像
    if (unblurredImage != nil) {
        UIGraphicsBeginImageContext(returnImage.size);
        [returnImage drawAtPoint:CGPointZero];
        [unblurredImage drawAtPoint:CGPointZero];
        
        returnImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    
    //清理
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

/**
 * 将一个view根据image的alpha属性进行mask
 * @param view 要被mask的view
 * @param image 带有alpha的image
 */
+ (void)makeMaskView:(UIView *)view withImage:(UIImage *)image {
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(CGRectMake(0, 0, view.frame.size.width, view.frame.size.height), 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}




@end
