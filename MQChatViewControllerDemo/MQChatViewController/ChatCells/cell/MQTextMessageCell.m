//
//  MQTextMessageCell.m
//  MeiQiaSDK
//
//  Created by dingnan on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQTextMessageCell.h"
#import "MQTextCellModel.h"
#import "MQSelectableLabel.h"
#import "MQFileUtil.h"

static const NSInteger kMQTextCellSelectedUrlActionSheetTag = 2000;
static const NSInteger kMQTextCellSelectedNumberActionSheetTag = 2001;
static const NSInteger kMQTextCellSelectedEmailActionSheetTag = 2002;

@interface MQTextMessageCell() <TTTAttributedLabelDelegate, UIActionSheetDelegate>

@end

@implementation MQTextMessageCell  {
    UIImageView *avatarImageView;
    TTTAttributedLabel *textLabel;
    UIImageView *bubbleImageView;
    UIActivityIndicatorView *sendMsgIndicator;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //初始化头像
        avatarImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:avatarImageView];
        //初始化文字
        textLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        textLabel.font = [UIFont systemFontOfSize:kMQCellTextFontSize];
        textLabel.textColor = [UIColor darkTextColor];
        textLabel.numberOfLines = 0;
        textLabel.delegate = self;
        [self.contentView addSubview:textLabel];
        //初始化气泡
        bubbleImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:bubbleImageView];
        //初始化indicator
        sendMsgIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        sendMsgIndicator.hidden = YES;
        [self.contentView addSubview:sendMsgIndicator];
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
        avatarImageView.image = [UIImage imageNamed:[MQFileUtil jointResource:cellModel.avatarLocolImageName]];
    } else {
#warning 使用SDWebImage或自己写获取远程图片的方法
    }
    avatarImageView.frame = cellModel.avatarFrame;
    
    //刷新气泡
    bubbleImageView.image = cellModel.bubbleImage;
    bubbleImageView.frame = cellModel.bubbleImageFrame;
    
    //刷新indicator
    sendMsgIndicator.hidden = true;
    [sendMsgIndicator stopAnimating];
    if (cellModel.sendType == MQChatCellSending) {
        sendMsgIndicator.frame = cellModel.indicatorFrame;
        [sendMsgIndicator startAnimating];
    }
    
    //刷新聊天文字
    textLabel.frame = cellModel.textLabelFrame;
    textLabel.text = cellModel.cellText;
    textLabel.textColor = [UIColor whiteColor];
    if (cellModel.cellFromType == MQChatCellIncoming) {
        textLabel.textColor = [UIColor darkTextColor];
    }
    //获取文字中的可选中的元素
    if (cellModel.phoneNumberRangeDic.count > 0) {
        for (NSString *key in cellModel.phoneNumberRangeDic.allKeys) {
            [textLabel addLinkToPhoneNumber:key withRange:[cellModel.phoneNumberRangeDic[key] rangeValue]];
        }
    }
    if (cellModel.urlNumberRangeDic.count > 0) {
        for (NSString *key in cellModel.urlNumberRangeDic.allKeys) {
            [textLabel addLinkToURL:[NSURL URLWithString:key] withRange:[cellModel.urlNumberRangeDic[key] rangeValue]];
        }
    }
    if (cellModel.emailNumberRangeDic.count > 0) {
        for (NSString *key in cellModel.emailNumberRangeDic.allKeys) {
            [textLabel addLinkToTransitInformation:@{@"email" : key} withRange:[cellModel.emailNumberRangeDic[key] rangeValue]];
        }
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
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", actionSheet.title]]];
                    break;
                case 2:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"sms://%@", actionSheet.title]]];
                    break;
                case 3:
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
                case 1: {
                    if ([actionSheet.title rangeOfString:@"://"].location == NSNotFound) {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", actionSheet.title]]];
                    } else {
                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:actionSheet.title]];
                    }
                    break;
                }
                case 2:
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
                case 1: {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@", actionSheet.title]]];
                    break;
                }
                case 2:
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
