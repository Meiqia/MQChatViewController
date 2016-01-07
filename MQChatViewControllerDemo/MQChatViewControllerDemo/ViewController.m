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
                     @"Below are chat view styles",
                     @"push chatView",
                     @"present chatView",
                     @"chatViewStyle1",
                     @"chatViewStyle2",
                     @"chatViewStyle3",
                     @"chatViewStyle4",
                     @"chatViewStyle5",
                     @"chatViewStyle6"
                     ];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blueColor];

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
        case 1:
            [self pushChatView];
            break;
        case 2:
            [self presentChatView];
            break;
        case 3:
            [self chatViewStyle1];
            break;
        case 4:
            [self chatViewStyle2];
            break;
        case 5:
            [self chatViewStyle3];
            break;
        case 6:
            [self chatViewStyle4];
            break;
        case 7:
            [self chatViewStyle5];
            break;
        case 8:
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
    }
    if (indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blueColor];
    } else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor darkTextColor];
    }
    cell.textLabel.text = [tableCellTextArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)pushChatView {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setStatusBarStyle:UIStatusBarStyleLightContent];
    [chatViewManager setNavigationBarColor:[UIColor blueColor]];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)presentChatView {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager enableMessageImageMask:false];
    [chatViewManager presentMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle1 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    UIImage *photoImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputImageNormalStyleTwo"];
    UIImage *photoHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageCameraInputHighlightedImageStyleTwo"];
    UIImage *voiceImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputImageNormalStyleTwo"];
    UIImage *voiceHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageVoiceInputHighlightedImageStyleTwo"];
    UIImage *keyboardImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputImageNormalStyleTwo"];
    UIImage *keyboardHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageTextInputHighlightedImageStyleTwo"];
    UIImage *resightKeyboardImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageKeyboardDownImageNormalStyleTwo"];
    UIImage *resightKeyboardHighlightedImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQMessageKeyboardDownHighlightedImageStyleTwo"];
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
    UIImage *incomingBubbleImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubbleIncomingStyleTwo"];
    UIImage *outgoingBubbleImage = [MQAssetUtil bubbleImageFromBundleWithName:@"MQBubbleOutgoingStyleTwo"];
    CGPoint stretchPoint = CGPointMake(incomingBubbleImage.size.width / 2.0f - 4.0, incomingBubbleImage.size.height / 2.0f);
    [chatViewManager enableSendVoiceMessage:false];
    [chatViewManager enableOutgoingAvatar:false];
    [chatViewManager setIncomingBubbleImage:incomingBubbleImage];
    [chatViewManager setOutgoingBubbleImage:outgoingBubbleImage];
    [chatViewManager setIncomingBubbleColor:[UIColor yellowColor]];
    [chatViewManager setBubbleImageStretchInsets:UIEdgeInsetsMake(stretchPoint.y, stretchPoint.x, incomingBubbleImage.size.height-stretchPoint.y+0.5, stretchPoint.x)];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

- (void)chatViewStyle3 {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager setMessageLinkRegex:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"];
    [chatViewManager enableChatWelcome:true];
    [chatViewManager setChatWelcomeText:@"你好，请问有什么可以帮助到您？"];
    [chatViewManager setIncomingMessageSoundFileName:@"MQNewMessageRingStyleTwo.wav"];
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
    [chatViewManager enableMessageImageMask:false];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

@end
