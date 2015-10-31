//
//  MQChatBaseCell.h
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MQCellModelProtocol;

/**
 * 所有的集成的cell需要满足的协议
 */
@protocol MQChatCellProtocol <NSObject>

/**
 * 根据cellModel中的数据，来更新cell的界面
 * @param cellModel cell的数据
 */
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model;

@end


/**
 * MQChatBaseCell定义了客服聊天界面所有cell的父cell，开发者自定义的Cell请继承该Cell
 */
@interface MQChatBaseCell : UITableViewCell <MQChatCellProtocol>


/**
 *  发送过来的消息气泡图片
 */
@property (nonatomic, strong) UIImage *incomingBubbleImage;

/**
 *  发送出去的消息气泡图片
 */
@property (nonatomic, strong) UIImage *outgoingBubbleImage;

/**
 *  消息气泡的frame
 */
@property (nonatomic, assign) CGRect cellFrame;





@end
