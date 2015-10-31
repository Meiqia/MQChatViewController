//
//  MQInputBar.m
//  MeChatSDK
//
//  Created by Injoy on 14-8-28.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import "MQInputBar.h"
#import "MQChatFileUtil.h"

#define ButtonWidth 33
#define ButtonX 6.5

@implementation MQInputBar
{
    CGRect thisFrame;   //默认
    CGRect superViewFrame;  //默认
    CGRect chatViewFrame;
    
    //调整键盘需要涉及的变量
    UIEdgeInsets chatViewInsets;    //默认chatView.contentInsets
    float keyboardDifference;
    BOOL isInputBarUp;  //工具栏被抬高
    float bullleViewHeigth; //真实可视区域
}

- (id)init
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        cameraBtn              = [[UIButton alloc] init];
        [cameraBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"camera_normal.png"]] forState:UIControlStateNormal];
        [cameraBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"camera_click.png"]] forState:UIControlStateHighlighted];
        [cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
        
        self.textView               = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 0, ButtonWidth)];
//        [self.textView setTextViewRadius:5];
        self.textView.font          = [UIFont systemFontOfSize:15];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.placeholder   = @"请输入...";
        self.textView.delegate      = (id)self;
        self.textView.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        self.textView.layer.borderWidth = 1;
        
        [self addSubview:self.textView];
        [self addSubview:cameraBtn];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(toolbarDownBtnVisible)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(toolbarDownBtnVisible)
                                                     name:@"MCToolbarDownBtnVisible"
                                                   object:nil];
    }
    return self;
}

-(void)setRecordButtonVisible:(BOOL)recordButtonVisible
{
    _recordButtonVisible = recordButtonVisible;
    if (_recordButtonVisible) {
        toolbarDownBtn = [[UIButton alloc] init];
        [toolbarDownBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"toolbarDown_normal"]] forState:UIControlStateNormal];
        [toolbarDownBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"toolbarDown_click"]] forState:UIControlStateHighlighted];
        [toolbarDownBtn addTarget:self action:@selector(toolbarDownClick) forControlEvents:UIControlEventTouchUpInside];
        toolbarDownBtn.hidden = YES;
        
        micBtn = [[UIButton alloc] init];
        [micBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"mic_normal"]] forState:UIControlStateNormal];
        [micBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"mic_click"]] forState:UIControlStateHighlighted];
        [micBtn addTarget:self action:@selector(micClick) forControlEvents:UIControlEventTouchUpInside];
        
        recordBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
        [recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [recordBtn setTitleColor:[UIColor colorWithWhite:.1 alpha:1] forState:UIControlStateNormal];
        recordBtn.backgroundColor    = [UIColor colorWithWhite:1 alpha:1];
        recordBtn.layer.cornerRadius = 5;
        recordBtn.alpha              = 0;
        recordBtn.hidden             = YES;
        
        recordBtn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        recordBtn.layer.borderWidth = 1;
        
//        recordBtn.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
//        recordBtn.layer.shadowOffset = CGSizeMake(0, .7);
//        recordBtn.layer.shadowRadius = .6;
//        recordBtn.layer.shadowOpacity = .4;
        
        UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnLongPressed:)];
        gesture.delegate = (id)self;
        gesture.delaysTouchesBegan = NO;
        gesture.delaysTouchesEnded = NO;
        gesture.minimumPressDuration = -1;
        [recordBtn addGestureRecognizer:gesture];
        
        [self addSubview:toolbarDownBtn];
        [self addSubview:recordBtn];
        [self addSubview:micBtn];
    }
    [self setupUI];
}


-(void)setupUI
{
    thisFrame            = self.frame;
    superViewFrame       = self.superview.frame;
    chatViewFrame        = chatTableView.frame;

    cameraBtn.frame      = CGRectMake(ButtonX, (self.frame.size.height - ButtonWidth)/2, ButtonWidth, ButtonWidth);
    
    if (self.recordButtonVisible) {
        micBtn.frame = CGRectMake(self.frame.size.width - ButtonWidth - ButtonX, (self.frame.size.height - ButtonWidth)/2, ButtonWidth, ButtonWidth);
        toolbarDownBtn.frame = micBtn.frame;
        
        recordBtn.frame = CGRectMake(ButtonWidth + 2 * ButtonX, (thisFrame.size.height - ButtonWidth)/2, thisFrame.size.width - ButtonX * 4 - 2 * ButtonWidth, ButtonWidth);
        
        self.textView.frame = CGRectMake(ButtonWidth + 2 * ButtonX, (thisFrame.size.height - ButtonWidth)/2, thisFrame.size.width - ButtonX * 4 - 2 * ButtonWidth, ButtonWidth);
    }else{
        if (toolbarDownBtn) toolbarDownBtn.hidden = YES;
        if (micBtn) micBtn.hidden = YES;
        if (recordBtn) recordBtn.hidden = YES;
        
        self.textView.frame = CGRectMake(ButtonWidth + 2 * ButtonX, (thisFrame.size.height - ButtonWidth)/2, thisFrame.size.width - ButtonX * 3 - ButtonWidth, ButtonWidth);
    }
}

-(void)cameraClick
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];
    [sheet showInView:self.superview.superview];
}

-(void)toolbarDownClick
{
    micBtn.hidden = NO;
    toolbarDownBtn.hidden = YES;
    [self.textView resignFirstResponder];
}

-(void)micClick
{
    if (recordBtn.hidden) {
        recordBtn.hidden = NO;
        [micBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"keyboard_normal"]] forState:UIControlStateNormal];
        [micBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"keyboard_click"]] forState:UIControlStateHighlighted];
        [self textViewResignFirstResponder];
        [UIView animateWithDuration:.25 animations:^{
            //还原
            chatTableView.frame  = chatViewFrame;
            self.frame      = thisFrame;

            self.textView.frame  = recordBtn.frame;
            self.textView.alpha  = 0;
            recordBtn.alpha = 1;
            
            //居中
            [self functionBtnCenter];
        } completion:^(BOOL finished) {
            self.textView.hidden = YES;
        }];
    }else{
        [micBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"mic_normal"]] forState:UIControlStateNormal];
        [micBtn setImage:[UIImage imageNamed:[MQChatFileUtil resourceWithName:@"mic_click"]] forState:UIControlStateHighlighted];
        [self.textView becomeFirstResponder];
        self.textView.hidden = NO;
        [UIView animateWithDuration:.25 animations:^{
            self.textView.text    = self.textView.text;
            self.textView.alpha   = 1;
            recordBtn.alpha  = 0;
        } completion:^(BOOL finished) {
            recordBtn.hidden = YES;
        }];
    }
}

-(void)reRecordBtn
{
    [recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    [UIView animateWithDuration:.2 animations:^{
        recordBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
//        recordBtn.layer.shadowOpacity = .4;
    }];
}

- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer{
    
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(beginRecord:)]){
            [self.delegate beginRecord:[longPressedRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]]];
        }
        [recordBtn setTitle:@"松开结束" forState:UIControlStateNormal];
        [UIView animateWithDuration:.2 animations:^{
            recordBtn.backgroundColor = [UIColor colorWithWhite:.92 alpha:1];
//            recordBtn.layer.shadowOpacity = .1;
        }];
    }else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(endRecord:)]){
            [self.delegate endRecord:[longPressedRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]]];
        }
        
        [recordBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        [UIView animateWithDuration:.2 animations:^{
            recordBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
//            recordBtn.layer.shadowOpacity = .4;
        }];
    }else if(longPressedRecognizer.state == UIGestureRecognizerStateChanged) {
        if(self.delegate && [self.delegate respondsToSelector:@selector(changedRecord:)]){
            [self.delegate changedRecord:[longPressedRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]]];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.delegate sendImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            break;
        case 1:
            [self.delegate sendImageWithSourceType:(NSInteger*)UIImagePickerControllerSourceTypeCamera];
            break;
    }
    actionSheet = nil;
}

-(void)setChatView:(UIView*)view{
    chatTableView = (UITableView*)view;
}

-(void)inputKeyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    if (self.textView.isFirstResponder) {
        float keyboardHeight;
        
        //兼用ios8及以上
        if ([[UIDevice currentDevice].systemVersion intValue] <= 7) {
            UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
            if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
                keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.width;
            }else{
                keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
            }
        }else{
            keyboardHeight = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
        }
        
        [chatTableView scrollToBottom:NO];
        //[self moveToolbarUp:keyboardHeight animate:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
        [self moveToolbarUp:keyboardHeight animate:.25];
        [self toolbarDownBtnVisible];
    }
}

-(void)inputKeyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    [self moveToolbarDown:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
}

-(void)textViewResignFirstResponder
{
    if ([self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}

-(void)moveToolbarUp:(float)height animate:(NSTimeInterval)duration
{
    if (!isInputBarUp){
        bullleViewHeigth = chatTableView.frame.size.height - chatTableView.contentInset.top;
        chatViewInsets   = chatTableView.contentInset;
    }
    
    //内容与键盘的高度差。   可视区域 - 键盘高度 - 总内容高度
    keyboardDifference  = bullleViewHeigth - height - chatTableView.contentSize.height;
    /*
     去要调整contentInset.top的情况：
     1、keyboardDifference大于0，说明内容不饱和，及contentInset.top加上键盘高度
     2、keyboardDifference小于0，contentInset.top加上bullleViewHeigth再加keyboardDifference（相当于减，因为keyboardDifference为负数），但keyboardDifference的绝对值不能超过bullleViewHeigth
     */
    [UIView animateWithDuration:duration animations:^{
        if(keyboardDifference >= 0){
            chatTableView.contentInset = UIEdgeInsetsMake(chatViewInsets.top + height,
                                                     chatViewInsets.left,
                                                     chatViewInsets.bottom,
                                                     chatViewInsets.right);
        }else{
            //限制keyboardDifference大小
            if (-keyboardDifference > bullleViewHeigth) keyboardDifference = -bullleViewHeigth;
            chatTableView.contentInset = UIEdgeInsetsMake(chatTableView.contentInset.top + keyboardDifference + bullleViewHeigth,
                                                     chatTableView.contentInset.left,
                                                     chatTableView.contentInset.bottom,
                                                     chatTableView.contentInset.right);
        }
        self.superview.frame = CGRectMake(self.superview.frame.origin.x,
                                          superViewFrame.origin.y - height,
                                          self.superview.frame.size.width,
                                          self.superview.frame.size.height);
    }];

    isInputBarUp = YES;
}

-(void)moveToolbarDown:(float)animateDuration
{
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.superview.frame  = superViewFrame;
                         chatTableView.contentInset = chatViewInsets;
                     } completion:^(BOOL finished) {
                         isInputBarUp = NO;
                     }];
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendText:nil];
    return YES;
}

-(void)sendText:(id)sender
{
    if ([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0) {
        if([self.delegate sendTextMessage:self.textView.text]) {
            [self.textView setText:@""];
            thisFrame = self.frame;
        }
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if ([self.delegate respondsToSelector:@selector(inputting:)]) {
        [self.delegate inputting:self.textView.text];
    }
}

-(void)toolbarDownBtnVisible
{
    if (!self.recordButtonVisible) return;
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        if ([self.textView isFirstResponder]) {
            micBtn.hidden = YES;
            toolbarDownBtn.hidden = NO;
        }else{
            micBtn.hidden = NO;
            toolbarDownBtn.hidden = YES;
        }
    }else{
        micBtn.hidden = NO;
        toolbarDownBtn.hidden = YES;
    }
}

-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff     = (self.textView.frame.size.height - height);
    chatTableView.frame = CGRectMake(chatTableView.frame.origin.x, chatTableView.frame.origin.y + diff, chatTableView.frame.size.width, chatTableView.frame.size.height);
    self.frame     = CGRectMake(0, self.frame.origin.y + diff, self.frame.size.width, self.frame.size.height - diff);
    
    //居中
    [self functionBtnCenter];
}

-(void)functionBtnCenter
{
    cameraBtn.frame      = CGRectMake(ButtonX, (self.frame.size.height - ButtonWidth)/2, ButtonWidth, ButtonWidth);
    micBtn.frame = CGRectMake(self.frame.size.width - ButtonWidth - ButtonX, (self.frame.size.height - ButtonWidth)/2, ButtonWidth, ButtonWidth);
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, 1.0);
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0.8 alpha:1].CGColor);
    CGContextMoveToPoint(ctx, 0, 0);
    CGContextAddLineToPoint(ctx, rect.size.width, 0);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);
}

@end
