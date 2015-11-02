//
//  MQTextMessageCell.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTextMessageCell.h"
#import "MQTextCellModel.h"
#import "MQChatFileUtil.h"
#import "MQChatViewConfig.h"

static const NSInteger kMQTextCellSelectedUrlActionSheetTag = 2000;
static const NSInteger kMQTextCellSelectedNumberActionSheetTag = 2001;
static const NSInteger kMQTextCellSelectedEmailActionSheetTag = 2002;

@interface MQTextMessageCell() <TTTAttributedLabelDelegate, UIActionSheetDelegate>

@end

@implementation MQTextMessageCell  {
    UIImageView *avatarImageView;
    TTTAttributedLabel *textLabel;
    UIImageView *bubbleImageView;
    UIActivityIndicatorView *sendingIndicator;
    UIImageView *failureImageView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化头像
        avatarImageView = [[UIImageView alloc] init];
        avatarImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:avatarImageView];
        //初始化气泡
        bubbleImageView = [[UIImageView alloc] init];
        bubbleImageView.userInteractionEnabled = true;
        [self.contentView addSubview:bubbleImageView];
        //初始化文字
        textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        textLabel.font = [UIFont systemFontOfSize:kMQCellTextFontSize];
        textLabel.textColor = [UIColor darkTextColor];
        textLabel.numberOfLines = 0;
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.delegate = self;
        textLabel.userInteractionEnabled = true;
        [bubbleImageView addSubview:textLabel];
        //初始化indicator
        sendingIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sendingIndicator.hidden = YES;
        [self.contentView addSubview:sendingIndicator];
        //初始化出错image
        failureImageView = [[UIImageView alloc] initWithImage:[MQChatViewConfig sharedConfig].messageSendFailureImage];
        [self.contentView addSubview:failureImageView];
    }
    return self;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    if (![model isKindOfClass:[MQTextCellModel class]]) {
        NSAssert(NO, @"传给MQTextMessageCell的Model类型不正确");
        return ;
    }
    MQTextCellModel *cellModel = (MQTextCellModel *)model;
    
    //刷新头像
    if (cellModel.avatarPath.length == 0) {
        avatarImageView.image = cellModel.avatarLocalImage;
    } else {
#warning 使用SDWebImage或自己写获取远程图片的方法
    }
    avatarImageView.frame = cellModel.avatarFrame;
    
    //刷新气泡
    bubbleImageView.image = cellModel.bubbleImage;
    bubbleImageView.frame = cellModel.bubbleImageFrame;
    
    //刷新indicator
    sendingIndicator.hidden = true;
    [sendingIndicator stopAnimating];
    if (cellModel.sendType == MQChatCellSending && cellModel.cellFromType == MQChatCellOutgoing) {
        sendingIndicator.hidden = false;
        sendingIndicator.frame = cellModel.sendingIndicatorFrame;
        [sendingIndicator startAnimating];
    }
    
    //刷新聊天文字
    textLabel.frame = cellModel.textLabelFrame;
    textLabel.text = cellModel.cellText;
    if (cellModel.cellFromType == MQChatCellIncoming) {
        textLabel.textColor = [UIColor darkTextColor];
    }
    //获取文字中的可选中的元素
    if (cellModel.numberRangeDic.count > 0) {
        NSString *longestKey = @"";
        for (NSString *key in cellModel.numberRangeDic.allKeys) {
            //找到最长的key
            if (key.length > longestKey.length) {
                longestKey = key;
            }
        }
        [textLabel addLinkToPhoneNumber:longestKey withRange:[cellModel.numberRangeDic[longestKey] rangeValue]];
    }
    if (cellModel.linkNumberRangeDic.count > 0) {
        NSString *longestKey = @"";
        for (NSString *key in cellModel.linkNumberRangeDic.allKeys) {
            //找到最长的key
            if (key.length > longestKey.length) {
                longestKey = key;
            }
        }
        [textLabel addLinkToURL:[NSURL URLWithString:longestKey] withRange:[cellModel.linkNumberRangeDic[longestKey] rangeValue]];
    }
    if (cellModel.emailNumberRangeDic.count > 0) {
        NSString *longestKey = @"";
        for (NSString *key in cellModel.emailNumberRangeDic.allKeys) {
            //找到最长的key
            if (key.length > longestKey.length) {
                longestKey = key;
            }
        }
        [textLabel addLinkToTransitInformation:@{@"email" : longestKey} withRange:[cellModel.emailNumberRangeDic[longestKey] rangeValue]];
    }
    
    //刷新出错图片
    failureImageView.hidden = true;
    if (cellModel.sendType == MQChatCellSentFailure) {
        failureImageView.hidden = false;
        failureImageView.frame = cellModel.sendFailureFrame;
    }
}

#pragma TTTAttributedLabelDelegate 点击事件
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:phoneNumber delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSString stringWithFormat:@"拨打至 %@", phoneNumber], [NSString stringWithFormat:@"短信至 %@", phoneNumber], @"复制", nil];
    sheet.tag = kMQTextCellSelectedNumberActionSheetTag;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"用Safari打开该链接", @"复制", nil];
    sheet.tag = kMQTextCellSelectedUrlActionSheetTag;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithTransitInformation:(NSDictionary *)components {
    if (!components[@"email"]) {
        return ;
    }
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:components[@"email"] delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"向该email发送邮件", @"复制", nil];
    sheet.tag = kMQTextCellSelectedEmailActionSheetTag;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (actionSheet.tag) {
        case kMQTextCellSelectedNumberActionSheetTag: {
            NSLog(@"点击了一个数字");
            switch (buttonIndex) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", actionSheet.title]]];
                    break;
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", actionSheet.title]]];
                    break;
                case 2:
                    [UIPasteboard generalPasteboard].string = actionSheet.title;
                    break;
                default:
                    break;
            }
            break;
        }
        case kMQTextCellSelectedUrlActionSheetTag: {
            NSLog(@"点击了一个url");
            switch (buttonIndex) {
                case 0: {
                    if ([actionSheet.title rangeOfString:@"://"].location == NSNotFound) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", actionSheet.title]]];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
                    }
                    break;
                }
                case 1:
                    [UIPasteboard generalPasteboard].string = actionSheet.title;
                    break;
                default:
                    break;
            }
            break;
        }
        case kMQTextCellSelectedEmailActionSheetTag: {
            NSLog(@"点击了一个email");
            switch (buttonIndex) {
                case 0: {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", actionSheet.title]]];
                    break;
                }
                case 1:
                    [UIPasteboard generalPasteboard].string = actionSheet.title;
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
}

@end
