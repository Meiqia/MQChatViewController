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
@end

@interface MQInputBar : UIView
{
    UIButton *micBtn;
    UIButton *cameraBtn;
    UIButton *recordBtn;
    UIButton *toolbarDownBtn;
    
    MQChatTableView *chatTableView;
}

@property(nonatomic,weak) id<MQInputBarDelegate> delegate;
@property(nonatomic,strong) HPGrowingTextView* textView;
@property(nonatomic) BOOL recordButtonVisible;

-(void)setupUI;
-(void)setChatView:(UIView*)view;
-(void)textViewResignFirstResponder;

-(void)moveToolbarUp:(float)height animate:(NSTimeInterval)duration;
-(void)moveToolbarDown:(float)animateDuration;

-(void)reRecordBtn;
@end
