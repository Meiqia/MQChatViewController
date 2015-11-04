//
//  MQChatTableView.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatTableView.h"

@implementation MQChatTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        UITapGestureRecognizer *tapViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapChatTableView:)];
        tapViewGesture.cancelsTouchesInView = false;
        self.userInteractionEnabled = true;
        [self addGestureRecognizer:tapViewGesture];
    }
    return self;
}

- (void)updateTableViewAtIndexPath:(NSIndexPath *)indexPath {
    [self beginUpdates];
    [self reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self endUpdates];
}

/** 点击tableView的事件 */
- (void)tapChatTableView:(id)sender {
    if (self.chatTableViewDelegate) {
        if ([self.chatTableViewDelegate respondsToSelector:@selector(didTapChatTableView:)]) {
            [self.chatTableViewDelegate didTapChatTableView:self];
        }
    }
}

@end
