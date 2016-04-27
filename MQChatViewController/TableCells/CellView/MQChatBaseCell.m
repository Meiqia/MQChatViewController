//
//  MQChatBaseCell.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/29.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatBaseCell.h"
#import "MQChatFileUtil.h"
#import "MQChatViewConfig.h"
#import "MQBundleUtil.h"

@implementation MQChatBaseCell {
    NSString *copiedText;
    UIImage *copiedImage;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.incomingBubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
        self.outgoingBubbleImage = [MQChatViewConfig sharedConfig].outgoingBubbleImage;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setCellFrame:(CGRect)cellFrame {
    self.contentView.frame = cellFrame;
}

#pragma MQChatCellProtocol
- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    NSAssert(NO, @"MQChatBaseCell的子类没有实现updateCellWithCellModel的协议方法");
}

#pragma 显示menu的方法
- (void)showMenuControllerInView:(UIView *)inView
                      targetRect:(CGRect)targetRect
                   menuItemsName:(NSDictionary *)menuItemsName
{
    [self becomeFirstResponder];
    //判断menuItem都有哪些
    NSMutableArray *menuItems = [[NSMutableArray alloc] init];
    if ([menuItemsName[@"textCopy"] isKindOfClass:[NSString class]]) {
        copiedText = menuItemsName[@"textCopy"];
        UIMenuItem *copyTextItem = [[UIMenuItem alloc] initWithTitle:[MQBundleUtil localizedStringForKey:@"save_text"] action:@selector(copyTextSender:)];
        [menuItems addObject:copyTextItem];
    }
    if ([menuItemsName[@"imageCopy"] isKindOfClass:[UIImage class]]) {
        copiedImage = menuItemsName[@"imageCopy"];
        UIMenuItem *copyImageItem = [[UIMenuItem alloc] initWithTitle:[MQBundleUtil localizedStringForKey:@"save_photo"] action:@selector(copyImageSender:)];
        [menuItems addObject:copyImageItem];
    }
    UIMenuController *menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:menuItems];
    [menu setTargetRect:targetRect inView:inView];
    [menu setMenuVisible:YES animated:YES];
    
}


#pragma mark 剪切板代理方法
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(copyTextSender:)) {
        return true;
    } else if (action == @selector(copyImageSender:)) {
        return true;
    } else {
        return false;
    }
}

-(void)copyTextSender:(id)sender {
    UIPasteboard *pasteboard=[UIPasteboard generalPasteboard];
    pasteboard.string = copiedText;
    [self.chatCellDelegate showToastViewInCell:self toastText:[MQBundleUtil localizedStringForKey:@"save_text_success"]];
}

-(void)copyImageSender:(id)sender {
    UIImageWriteToSavedPhotosAlbum(copiedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

//保存到相册的回调
- (void)image:(UIImage *)image
didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    if(error != NULL){
        [self.chatCellDelegate showToastViewInCell:self toastText:[MQBundleUtil localizedStringForKey:@"save_photo_error"]];
    }else{
        [self.chatCellDelegate showToastViewInCell:self toastText:[MQBundleUtil localizedStringForKey:@"save_photo_success"]];
    }
}



@end
