//
//  MQChatViewStyle.h
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/3/29.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Hex.h"

//https://github.com/brynbellomy/FlatUIColors
static NSString *const turquoise = @"1abc9c"; //青绿色
static NSString *const greenSea  = @"16a085"; //海绿色
static NSString *const mediumTurquoise = @"4ECDC4"; //中青绿色
static NSString *const lightSeaGreen = @"1BA39C"; // 浅海绿色
static NSString *const emerald  = @"2ecc71"; //绿宝石
static NSString *const nephritis = @"27ae60";
static NSString *const gossip = @"87D37C";
static NSString *const salem = @"1E824C";
static NSString *const peterRiver = @"3498D8";
static NSString *const belizeHole = @"2980b9";
static NSString *const riptide = @"86E2D5";
static NSString *const dodgerBlue = @"19B5FE";
static NSString *const amethyst = @"9b59b6";
static NSString *const wisteria = @"8e44ad";
static NSString *const lightWisteria = @"BE90D4";
static NSString *const plum = @"913D88";
static NSString *const wetAsphalt = @"34495e";
static NSString *const midnightBlue = @"2C3E50";
static NSString *const hoki = @"67809F";
static NSString *const ebonyClay = @"22313F";
static NSString *const sunflower = @"F1C40F";
static NSString *const tangerine = @"F39C12";
static NSString *const confetti = @"E9D460";
static NSString *const capeHoney = @"FDE3A7";
static NSString *const carrot = @"E67E22";
static NSString *const pumpkin = @"D35400";
static NSString *const ecstasy = @"F9690E";
static NSString *const jaffa = @"F27935";
static NSString *const alizarin = @"E74C3C";
static NSString *const pomegranate = @"C0392B";
static NSString *const monza = @"CF000F";
static NSString *const thunderbird = @"D91E18";
static NSString *const clouds = @"ECF0F1";
static NSString *const silver = @"BDC3C7";
static NSString *const gallery = @"EEEEEE";
static NSString *const iron = @"DADFE1";
static NSString *const concrete = @"95A5A6";
static NSString *const asbestos = @"7F8C8D";
static NSString *const pumice = @"D2D7D3";
static NSString *const lynch = @"6C7A89";


static NSString *const MQBlueColor = @"17c7d1";
static NSString *const MQSilverColor = @"c6cbd0";

typedef NS_ENUM(NSUInteger, MQChatViewStyleType) {
    MQChatViewStyleTypeDefault,
    MQChatViewStyleTypeBlue,
    MQChatViewStyleTypeGreen,
    MQChatViewStyleTypeDark,
};

@protocol MQChatViewStyleCustomized <NSObject>

- (void)setupCustomizedStyle;

@end

@interface MQChatViewStyle : NSObject

/**
 * 设置发送过来的message的文字颜色；
 * @param textColor 文字颜色
 */
@property (nonatomic, copy) UIColor *incomingMsgTextColor;

/**
 *  设置发送过来的message气泡颜色
 *
 *  @param bubbleColor 气泡颜色
 */
@property (nonatomic, copy) UIColor *incomingBubbleColor;

/**
 * 设置发送出去的message的文字颜色；
 * @param textColor 文字颜色
 */
@property (nonatomic, copy) UIColor *outgoingMsgTextColor;

/**
 *  设置发送的message气泡颜色
 *
 *  @param bubbleColor 气泡颜色
 */
@property (nonatomic, copy) UIColor *outgoingBubbleColor;

/**
 * 设置事件流的显示文字的颜色；
 * @param textColor 文字颜色
 */
@property (nonatomic, copy) UIColor *eventTextColor;


@property (nonatomic, copy) UIColor *redirectAgentNameColor;


@property (nonatomic, copy) UIColor *navTitleColor;

/**
 * 设置导航栏上的元素颜色；
 * @param tintColor 导航栏上的元素颜色
 */
@property (nonatomic, copy) UIColor *navBarTintColor;

/**
 * 设置导航栏的背景色；
 * @param barColor 导航栏背景颜色
 */
@property (nonatomic, copy) UIColor *navBarColor;

/**
 *  设置下拉/上拉刷新的颜色；默认绿色
 *
 *  @param pullRefreshColor 颜色
 */
@property (nonatomic, copy) UIColor *pullRefreshColor;

@property (nonatomic, strong) UIImage *messageSendFailureImage;

/**
 *  设置底部自定义发送图片的按钮图片；
 *  @param image 图片发送按钮image
 *  @param highlightedImage 图片发送按钮选中image
 */
@property (nonatomic, strong) UIImage *photoSenderImage;
@property (nonatomic, strong) UIImage *photoSenderHighlightedImage;

/**
 *  设置底部自定义发送语音的按钮图片；
 *  @param image 语音发送按钮image
 *  @param highlightedImage 语音发送按钮选中image
 */
@property (nonatomic, strong) UIImage *voiceSenderImage;
@property (nonatomic, strong) UIImage *voiceSenderHighlightedImage;


@property (nonatomic, strong) UIImage *keyboardSenderImage;
@property (nonatomic, strong) UIImage *keyboardSenderHighlightedImage;

/**
 *  设置底部自定义取消键盘的按钮图片
 *
 *  @param image            取消键盘按钮image
 *  @param highlightedImage 取消键盘按钮选中image
 */
@property (nonatomic, strong) UIImage *resignKeyboardImage;
@property (nonatomic, strong) UIImage *resignKeyboardHighlightedImage;

/**
 * 设置自定义客服的消息气泡（发送过来的消息气泡）的背景图片；
 * @param bubbleImage 气泡图片
 */
@property (nonatomic, strong) UIImage *incomingBubbleImage;

/**
 * 设置自定义顾客的消息气泡（发送出去的消息气泡）的背景图片；
 * @param bubbleImage 气泡图片
 */
@property (nonatomic, strong) UIImage *outgoingBubbleImage;
@property (nonatomic, strong) UIImage *imageLoadErrorImage;

/**
 *  设置消息气泡的拉伸insets
 *
 *  @param stretchInsets 拉伸insets
 */
@property (nonatomic, assign) UIEdgeInsets bubbleImageStretchInsets;

/**
 *  设置导航栏时间条的颜色
 */
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;


@property (nonatomic, assign, readonly) BOOL didSetStatusBarStyle;

/**
 *  设置导航栏左键的图片
 *
 *  @param leftButton 左键图片
 */
@property (nonatomic, strong) UIButton *navBarLeftButton;

/**
 *  设置导航栏右键的图片
 *
 *  @param rightButtonImage 右键图片
 */
@property (nonatomic, strong) UIButton *navBarRightButton;

/**
 *  是否开启圆形头像；默认不支持
 *
 * @param enable YES:支持 NO:不支持
 */
@property (nonatomic, assign) BOOL enableRoundAvatar;

/**
 * 是否支持对方头像的显示；默认支持
 * @param enable YES:支持 NO:不支持
 */
@property (nonatomic, assign) BOOL enableIncomingAvatar;

/**
 *  是否支持当前用户头像的显示；默认不支持
 *
 * @param enable YES:支持 NO:不支持
 */
@property (nonatomic, assign) BOOL enableOutgoingAvatar;

/**
 *  聊天窗口背景色
 *
 * @param backgroundColor
 */
@property (nonatomic, strong) UIColor *backgroundColor;

+ (instancetype)defaultStyle;

+ (instancetype)blueStyle;

+ (instancetype)darkStyle;

+ (instancetype)greenStyle;

@end