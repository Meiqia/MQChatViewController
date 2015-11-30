//
//  ViewController.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "ViewController.h"
#import "MQChatViewManager.h"
#import "MQAssetUtil.h"

static CGFloat   const kMQChatViewDemoTableCellHeight = 56.0;

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController {
    UITableView *configTableView;
    NSArray *tableCellTextArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    tableCellTextArray = @[
                     @"push chatView",
                     @"present chatView",
                     @"chatViewStyle1",
                     @"chatViewStyle2",
                     @"chatViewStyle3",
                     @"chatViewStyle4",
                     @"chatViewStyle5",
                     @"chatViewStyle6"
                     ];

    [self initTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTableView {
    configTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    configTableView.delegate = self;
    configTableView.dataSource = self;
    [self.view addSubview:configTableView];
}

#pragma UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return kMQChatViewDemoTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
            [self pushChatView];
            break;
        case 1:
            [self presentChatView];
            break;
        case 2:
            [self chatViewStyle1];
            break;
        case 3:
            [self chatViewStyle2];
            break;
        case 4:
            [self chatViewStyle3];
            break;
        case 5:
            [self chatViewStyle4];
            break;
        case 6:
            [self chatViewStyle5];
            break;
        case 7:
            [self chatViewStyle6];
            break;
        default:
            break;
    }
}

#pragma UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [tableCellTextArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[tableCellTextArray objectAtIndex:indexPath.row]];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[tableCellTextArray objectAtIndex:indexPath.row]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [tableCellTextArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)pushChatView {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)presentChatView {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager presentMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle1 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    UIImage *photoImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputImageNormalStyle2"];
    UIImage *photoHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputHighlightedImageStyle2"];
    UIImage *voiceImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputImageNormalStyle2"];
    UIImage *voiceHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputHighlightedImageStyle2"];
    UIImage *keyboardImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputImageNormalStyle2"];
    UIImage *keyboardHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputHighlightedImageStyle2"];
    UIImage *resightKeyboardImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageKeyboardDownImageNormalStyle2"];
    UIImage *resightKeyboardHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageKeyboardDownHighlightedImageStyle2"];
    [chatViewManager setPhotoSenderImage:photoImage highlightedImage:photoHighlightedImage];
    [chatViewManager setVoiceSenderImage:voiceImage highlightedImage:voiceHighlightedImage];
    [chatViewManager setTextSenderImage:keyboardImage highlightedImage:keyboardHighlightedImage];
    [chatViewManager setResignKeyboardImage:resightKeyboardImage highlightedImage:resightKeyboardHighlightedImage];
    [chatViewManager setIncomingBubbleColor:[UIColor redColor]];
    [chatViewManager setIncomingMessageTextColor:[UIColor whiteColor]];
    [chatViewManager setOutgoingBubbleColor:[UIColor yellowColor]];
    [chatViewManager setOutgoingMessageTextColor:[UIColor darkTextColor]];
    [chatViewManager enableRoundAvatar:true];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle2 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    UIImage *incomingBubbleImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubbleIncomingStyle2"];
    UIImage *outgoingBubbleImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubbleOutgoingStyle2"];
    [chatViewManager enableSendVoiceMessage:false];
    [chatViewManager enableClientAvatar:false];
    [chatViewManager setIncomingBubbleImage:incomingBubbleImage];
    [chatViewManager setOutgoingBubbleImage:outgoingBubbleImage];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle3 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setMessageLinkRegex:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"];
    [chatViewManager enableChatWelcome:true];
    [chatViewManager setChatWelcomeText:@"你好，请问有什么可以帮助到您？"];
    [chatViewManager setIncomingMessageSoundFileName:@"MQNewMessageRingStyle2.wav"];
    [chatViewManager enableMessageSound:true];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle4 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager enableShowNewMessageAlert:true];
    [chatViewManager pushMQChatViewControllerInViewController:self];

}

- (void)chatViewStyle5 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager enableTopPullRefresh:true];
    [chatViewManager setPullRefreshColor:[UIColor redColor]];
    [chatViewManager setNavTitleText:@"美洽SDK"];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle6 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.backgroundColor = [UIColor redColor];
    rightButton.frame = CGRectMake(10, 10, 20, 20);
    [chatViewManager setNavTitleText:@"美洽SDK"];
    [chatViewManager setNavigationBarTintColor:[UIColor redColor]];
    [chatViewManager setNavRightButton:rightButton];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

@end
