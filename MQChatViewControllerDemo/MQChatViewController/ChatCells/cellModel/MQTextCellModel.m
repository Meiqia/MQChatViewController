//
//  MQTextCellModel.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTextCellModel.h"
#import "MQTextMessageCell.h"
#import "MQChatBaseCell.h"
#import "MQChatFileUtil.h"

@interface MQTextCellModel()
/**
 * @brief 消息的文字
 */
@property (nonatomic, readwrite, copy) NSString *cellText;

/**
 * @brief 消息的时间
 */
@property (nonatomic, readwrite, copy) NSDate *messageDate;

/**
 * @brief 发送者的头像Path
 */
@property (nonatomic, readwrite, copy) NSString *avatarPath;

/**
 * @brief 发送者的头像的图片名字 (如果在头像path不存在的情况下，才使用这个属性)
 */
@property (nonatomic, readwrite, copy) NSString *avatarLocalImageName;

/**
 * @brief 聊天气泡的image
 */
@property (nonatomic, readwrite, copy) UIImage *bubbleImage;

/**
 * @brief 消息气泡的frame
 */
@property (nonatomic, readwrite, assign) CGRect bubbleImageFrame;

/**
 * @brief 消息气泡中的文字的frame
 */
@property (nonatomic, readwrite, assign) CGRect textLabelFrame;

/**
 * @brief 发送者的头像frame
 */
@property (nonatomic, readwrite, assign) CGRect avatarFrame;

/**
 * @brief 发送状态指示器的frame
 */
@property (nonatomic, readwrite, assign) CGRect indicatorFrame;

/**
 * @brief 消息的来源类型
 */
@property (nonatomic, readwrite, assign) MQChatCellFromType cellFromType;

/**
 * @brief 消息文字中，数字选中识别的字典 [number : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *phoneNumberRangeDic;

/**
 * @brief 消息文字中，url选中识别的字典 [url : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *urlNumberRangeDic;

/**
 * @brief 消息文字中，email选中识别的字典 [email : range]
 */
@property (nonatomic, readwrite, strong) NSDictionary *emailNumberRangeDic;

@end

@implementation MQTextCellModel

- (MQTextCellModel *)initCellModelWithMessage:(MQMessage *)message {
    if (self = [super init]) {
        self.cellText = message.content;
        self.messageDate = message.createdOn;
        
        //根据消息的来源，进行处理
        NSString *bubbleImageName = @"";
        if (message.fromType == MQMessageFromTypeClient) {
            //发送出去的消息
            self.cellFromType = MQChatCellOutgoing;
#warning 这里要增加图片
            bubbleImageName = @"";
        } else {
            //收到的消息
            self.cellFromType = MQChatCellIncoming;
#warning 这里需要增加默认头像图片
            self.avatarLocalImageName = [MQChatFileUtil resourceWithName:@""];
            self.avatarPath = message.userAvatarPath;
#warning 这里要增加图片
            bubbleImageName = @"";
        }
        UIImage *bubbleImage = [UIImage imageNamed:[MQChatFileUtil resourceWithName:bubbleImageName]];
        CGPoint centerArea = CGPointMake(bubbleImage.size.width / 4.0f, bubbleImage.size.height*3.0f / 4.0f);
        self.bubbleImage = [bubbleImage resizableImageWithCapInsets:UIEdgeInsetsMake(centerArea.y, centerArea.x, bubbleImage.size.height-centerArea.y+1, centerArea.x)];
        
        
    }
    return self;
}

#pragma MQCellModelProtocol
- (CGFloat)getCellHeight {
    return 0;
}

/**
 *  @return cell重用的名字.
 */
- (NSString *)getCellReuseIdentifier {
    return @"MQTextMessageCell";
}

/**
 *  通过重用的名字初始化cell
 *  @return 初始化了一个cell
 */
- (MQChatBaseCell *)getCellWithReuseIdentifier:(NSString *)cellReuseIdentifer {
    return [[MQTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentifer];
}


@end
