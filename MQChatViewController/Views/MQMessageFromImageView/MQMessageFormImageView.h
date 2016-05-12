//
//  MQMessageFormImageView.h
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/4.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MQMessageFormImageViewDelegate <NSObject>

- (void)choosePictureWithSourceType:(UIImagePickerControllerSourceType *)sourceType;

@end

@interface MQMessageFormImageView : UIView

@property(nonatomic, weak) id<MQMessageFormImageViewDelegate> delegate;

- (instancetype)initWithScreenWidth:(CGFloat)screenWidth;

- (void)refreshFrameWithScreenWidth:(CGFloat)screenWidth andY:(CGFloat)y;

- (void)addImage:(UIImage *)image;

- (NSArray *)getImages;
@end
