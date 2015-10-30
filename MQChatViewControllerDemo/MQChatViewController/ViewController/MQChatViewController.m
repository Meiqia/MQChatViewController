//
//  MQChatViewController.m
//  MeiQiaSDK
//
//  Created by ijinmao on 15/10/28.
//  Copyright © 2015年 MeiQia Inc. All rights reserved.
//

#import "MQChatViewController.h"
#import "MQChatViewTableDataSource.h"
#import "MQChatViewModel.h"
#import "MQCellModelProtocol.h"
#import "MQDeviceFrameUtil.h"

static CGFloat const kMQChatViewInputBarHeight = 50.0;

@interface MQChatViewController () <UITableViewDelegate, MQChatViewModelDelegate>

@end

@implementation MQChatViewController {
    MQChatViewConfig *chatViewConfig;
    MQChatViewTableDataSource *tableDataSource;
    MQChatViewModel *chatViewModel;
}

- (instancetype)initWithChatViewManager:(MQChatViewConfig *)config {
    if (self = [super init]) {
        chatViewConfig = config;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initChatViewModel];
    [self initChatTableView];
    [self initInputBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma 初始化viewModel
- (void)initChatViewModel {
    chatViewModel = [[MQChatViewModel alloc] init];
    chatViewModel.delegate = self;
}

#pragma 初始化所有Views
/**
 * 初始化聊天的tableView
 */
- (void)initChatTableView {
    if (CGRectEqualToRect(chatViewConfig.chatViewFrame, [MQDeviceFrameUtil getDeviceScreenRect])) {
        CGRect navBarRect = [MQDeviceFrameUtil getDeviceNavRect:self];
        chatViewConfig.chatViewFrame = CGRectMake(0, navBarRect.origin.y+navBarRect.size.height, navBarRect.size.width, [MQDeviceFrameUtil getDeviceScreenRect].size.height - navBarRect.origin.y - navBarRect.size.height - kMQChatViewInputBarHeight);
    }
    self.chatTableView = [[MQChatTableView alloc] initWithFrame:chatViewConfig.chatViewFrame style:UITableViewStylePlain];
    self.chatTableView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.delegate = self;
    tableDataSource = [[MQChatViewTableDataSource alloc] initWithTableView:self.chatTableView chatViewModel:chatViewModel];
    self.chatTableView.dataSource = tableDataSource;
    [self.view addSubview:self.chatTableView];
}

/**
 * 初始化聊天的inpur bar
 */
- (void)initInputBar {
    
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MQCellModelProtocol> cellModel = [chatViewModel.cellModels objectAtIndex:indexPath.row];
    return [cellModel getCellHeight];
}

#pragma MQChatViewModelDelegate
- (void)didGetHistoryMessages {
    [self.chatTableView reloadData];
}

- (void)didSendMessageWithIndexPath:(NSIndexPath *)indexPath {
    [self.chatTableView beginUpdates];
    [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.chatTableView endUpdates];
}



@end
