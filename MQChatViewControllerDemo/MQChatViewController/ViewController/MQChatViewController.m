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
#import "MQInputBar.h"
#import "MQToast.h"

static CGFloat const kMQChatViewInputBarHeight = 50.0;

@interface MQChatViewController () <UITableViewDelegate, MQChatViewModelDelegate, MQInputBarDelegate, UIImagePickerControllerDelegate>

@end

@implementation MQChatViewController {
    MQChatViewConfig *chatViewConfig;
    MQChatViewTableDataSource *tableDataSource;
    MQChatViewModel *chatViewModel;
    MQInputBar *chatInputBar;
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
    chatInputBar = [[MQInputBar alloc] init];
    chatInputBar.recordButtonVisible = chatViewConfig.enableVoiceMessage;
    chatInputBar.frame = CGRectMake(self.chatTableView.frame.origin.x, self.chatTableView.frame.origin.y+self.chatTableView.frame.size.height, self.chatTableView.frame.size.width, kMQChatViewInputBarHeight);
    chatInputBar.delegate = self;
    [chatInputBar setChatView:self.chatTableView];
    [chatInputBar setupUI];
    self.inputBarView = chatInputBar;
    self.inputBarTextView = chatInputBar.textView.internalTextView;
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

#pragma MQInputBarDelegate
-(BOOL)sendTextMessage:(NSString*)text {
    if (self.isInitializing) {
        [MQToast showToast:@"正在分配客服，请稍后发送消息" duration:3 window:self.view];
        return NO;
    }
    [chatViewModel sendTextMessageWithContent:text];
    return YES;
}
-(void)sendImageWithSourceType:(UIImagePickerControllerSourceType *)sourceType {
    if (TARGET_IPHONE_SIMULATOR && (int)sourceType == UIImagePickerControllerSourceTypeCamera){
        [MQToast showToast:@"当前设备没有相机" duration:2 window:self.view];
        NSLog(@"当前设备没有相机");
        return;
    }
    //兼容ipad打不开相册问题，使用队列延迟，规避ios8的警惕性
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType               = (int)sourceType;
        picker.delegate                 = (id)self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}
-(void)inputting:(NSString*)content {
    //用户正在输入
    [chatViewModel sendUserInputtingWithContent:content];
}
#warning 还没有完成语音输入
-(void)beginRecord:(CGPoint)point {
    
}
-(void)endRecord:(CGPoint)point {
    
}
-(void)changedRecord:(CGPoint)point {
    
}

#pragma UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type          = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if (![type isEqualToString:@"public.image"]) {
        return;
    }
    UIImage *image          = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [chatViewModel sendImageMessageWithImage:image];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}





@end
