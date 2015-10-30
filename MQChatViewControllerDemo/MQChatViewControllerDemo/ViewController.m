//
//  ViewController.m
//  MQChatViewControllerDemo
//
//  Created by ijinmao on 15/10/30.
//  Copyright © 2015年 ijinmao. All rights reserved.
//

#import "ViewController.h"
#import "MQChatViewManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *pushChatViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pushChatViewBtn.backgroundColor = [UIColor blueColor];
    pushChatViewBtn.titleLabel.text = @"pushChatView";
    pushChatViewBtn.frame = CGRectMake(100, 200, 100, 30);
    [pushChatViewBtn addTarget:self action:@selector(pushChatViewAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pushChatViewBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushChatViewAction:(id)sender {
    MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager pushMQChatViewControllerInViewController:self];
}

@end
