//
//  MQInputBar.h
//  MeChatSDK
//
//  Created by Injoy on 14-8-28.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "MQChatTableView.h"

@protocol MQInputBarDelegate <NSObject>
@optional
-(BOOL)sendTextMessage:(NSString*)text;
-(void)sendImageWithSourceType:(UIImagePickerControllerSourceType *)sourceType;
-(void)inputting:(NSString*)content;

-(void)beginRecord:(CGPoint)point;
-(void)endRecord:(CGPoint)point;
-(void)changedRecord:(CGPoint)point;
-(void)chatTableViewScrollToBottom;
@end

@interface MQInputBar : UIView
{
    UIButton *microphoneBtn;
    UIButton *cameraBtn;
    UIButton *recordBtn;
    UIButton *toolbarDownBtn;
    
}

@property(nonatomic,weak) id<MQInputBarDelegate> delegate;
@property(nonatomic,strong) HPGrowingTextView* textView;
@property(nonatomic, assign) BOOL recordButtonVisible;

- (id)initWithSuperView:(UIView *)inputBarSuperView tableView:(MQChatTableView *)tableView;
-(void)setupUI;
-(void)textViewResignFirstResponder;

-(void)moveToolbarUp:(float)height animate:(NSTimeInterval)duration;
-(void)moveToolbarDown:(float)animateDuration;

-(void)reRecordBtn;
@end
