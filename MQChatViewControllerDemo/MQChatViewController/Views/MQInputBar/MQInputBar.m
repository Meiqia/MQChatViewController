//
//  MQInputBar.m
//  MeChatSDK
//
//  Created by Injoy on 14-8-28.
//  Copyright (c) 2014年 MeChat. All rights reserved.
//

#import "MQInputBar.h"
#import "MQChatFileUtil.h"
#import "MQAssetUtil.h"
#import "MQBundleUtil.h"
#import "MQBundleUtil.h"

static CGFloat const kMQInputBarHorizontalSpacing = 8.0;

@interface MQInputBar()

@property (nonatomic, weak) MQChatTableView *chatTableView;

@end

@implementation MQInputBar
{
    CGRect originalFrame;   //默认
    CGRect originalSuperViewFrame;  //默认
    CGRect originalChatViewFrame;
    CGRect originalTextViewFrame;   //textView的初始frame
    
    //调整键盘需要涉及的变量
    UIEdgeInsets chatViewInsets;    //默认chatView.contentInsets
    float keyboardDifference;
    BOOL isInputBarUp;  //工具栏被抬高
    float bullleViewHeight; //真实可视区域
    CGFloat senderImageWidth;
    CGFloat textViewHeight;
    BOOL enableSendVoice;
    BOOL enableSendImage;
    
    //转换成录音的btn
    UIButton *microphoneBtn;
    //照相btn
    UIButton *cameraBtn;
    //录音的btn
    UIButton *recordBtn;
    //键盘收取的btn
    UIButton *toolbarDownBtn;
    
    UIImage *photoSenderImage;
    UIImage *photoSenderHighlightedImage;
    UIImage *voiceSenderImage;
    UIImage *voiceSenderHighlightedImage;
    UIImage *keyboardSenderImage;
    UIImage *keyboardSenderHighlightedImage;
    UIImage *resignKeyboardSenderImage;
    UIImage *resignKeyboardSenderHighlightedImage;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
          superView:(UIView *)inputBarSuperView
          tableView:(MQChatTableView *)tableView
    enableSendVoice:(BOOL)enableVoice
    enableSendImage:(BOOL)enableImage
   photoSenderImage:(UIImage *)photoImage
photoHighlightedImage:(UIImage *)photoHighlightedImage
   voiceSenderImage:(UIImage *)voiceImage
voiceHighlightedImage:(UIImage *)voiceHighlightedImage
keyboardSenderImage:(UIImage *)keyboardImage
keyboardHighlightedImage:(UIImage *)keyboardHighlightedImage
resignKeyboardImage:(UIImage *)resignKeyboardImage
resignKeyboardHighlightedImage:(UIImage *)resignKeyboardHighlightedImage
{
    if (self = [super init]) {
        self.frame              = frame;
        originalFrame           = frame;
        originalSuperViewFrame  = inputBarSuperView.frame;
        self.chatTableView      = tableView;
        originalChatViewFrame   = tableView.frame;
        enableSendImage         = enableImage;
        enableSendVoice         = enableVoice;
        photoSenderImage        = photoImage;
        photoSenderHighlightedImage = photoHighlightedImage;
        voiceSenderImage            = voiceImage;
        voiceSenderHighlightedImage = voiceHighlightedImage;
        keyboardSenderImage         = keyboardImage;
        keyboardSenderHighlightedImage = keyboardHighlightedImage;
        resignKeyboardSenderImage      = resignKeyboardImage;
        resignKeyboardSenderHighlightedImage = resignKeyboardHighlightedImage;
        
        senderImageWidth = photoImage.size.width;
        if (senderImageWidth + kMQInputBarHorizontalSpacing * 2 > self.frame.size.height) {
            //防止开发者设置的图片太大
            senderImageWidth = self.frame.size.height - kMQInputBarHorizontalSpacing * 2;
        }
        textViewHeight = ceil(frame.size.height * 5 / 7);
        self.backgroundColor = [UIColor whiteColor];
        
        cameraBtn              = [[UIButton alloc] init];
        [cameraBtn setImage:photoSenderImage forState:UIControlStateNormal];
        [cameraBtn setImage:photoSenderHighlightedImage forState:UIControlStateHighlighted];
        [cameraBtn addTarget:self action:@selector(cameraClick) forControlEvents:UIControlEventTouchUpInside];
        cameraBtn.frame      = enableSendImage ? CGRectMake(kMQInputBarHorizontalSpacing, (self.frame.size.height - senderImageWidth)/2, senderImageWidth, senderImageWidth) : CGRectMake(0, 0, 0, 0);
        
        self.textView               = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(0, 0, 0, textViewHeight)];
        self.textView.font          = [UIFont systemFontOfSize:16];
        self.textView.returnKeyType = UIReturnKeySend;
        self.textView.placeholder   = [MQBundleUtil localizedStringForKey:@"new_message"];
        self.textView.delegate      = (id)self;
        self.textView.layer.borderColor     = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        self.textView.layer.borderWidth     = 1;
        self.textView.layer.cornerRadius    = 4;
        
        if (enableSendVoice) {
            [self initRecordBtn];
            self.textView.frame     = recordBtn.frame;
            originalTextViewFrame   = recordBtn.frame;
        }else{
            if (toolbarDownBtn) {
                toolbarDownBtn.hidden = YES;
            }
            if (microphoneBtn) {
                microphoneBtn.hidden = YES;
            }
            if (recordBtn) {
                recordBtn.hidden = YES;
            }
            self.textView.frame = CGRectMake(cameraBtn.frame.origin.x + cameraBtn.frame.size.width + kMQInputBarHorizontalSpacing, (originalFrame.size.height - textViewHeight)/2, originalFrame.size.width - cameraBtn.frame.origin.x - cameraBtn.frame.size.width - kMQInputBarHorizontalSpacing * 2, textViewHeight);
            originalTextViewFrame = self.textView.frame;
        }
        
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

-(void)initRecordBtn
{
    //横屏状态，隐藏toolbar的按钮
    toolbarDownBtn = [[UIButton alloc] init];
    [toolbarDownBtn setImage:resignKeyboardSenderImage forState:UIControlStateNormal];
    [toolbarDownBtn setImage:resignKeyboardSenderHighlightedImage forState:UIControlStateHighlighted];
    [toolbarDownBtn addTarget:self action:@selector(toolbarDownClick) forControlEvents:UIControlEventTouchUpInside];
    toolbarDownBtn.hidden = YES;
    
    microphoneBtn = [[UIButton alloc] init];
    [microphoneBtn setImage:voiceSenderImage forState:UIControlStateNormal];
    [microphoneBtn setImage:voiceSenderHighlightedImage forState:UIControlStateHighlighted];
    [microphoneBtn addTarget:self action:@selector(microphoneClick) forControlEvents:UIControlEventTouchUpInside];
    
    recordBtn                    = [UIButton buttonWithType:UIButtonTypeCustom];
    [recordBtn setTitle:[MQBundleUtil localizedStringForKey:@"record_speak"] forState:UIControlStateNormal];
    [recordBtn setTitleColor:[UIColor colorWithWhite:.1 alpha:1] forState:UIControlStateNormal];
    recordBtn.backgroundColor    = [UIColor colorWithWhite:1 alpha:1];
    recordBtn.layer.cornerRadius = 4;
    recordBtn.alpha              = 0;
    recordBtn.hidden             = YES;
    
    recordBtn.layer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
    recordBtn.layer.borderWidth = 1;
    
    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(recordBtnLongPressed:)];
    gesture.delegate = (id)self;
    gesture.delaysTouchesBegan = NO;
    gesture.delaysTouchesEnded = NO;
    gesture.minimumPressDuration = -1;
    [recordBtn addGestureRecognizer:gesture];
    
    microphoneBtn.frame = CGRectMake(self.frame.size.width - senderImageWidth - kMQInputBarHorizontalSpacing, (self.frame.size.height - senderImageWidth)/2, senderImageWidth, senderImageWidth);
    toolbarDownBtn.frame = microphoneBtn.frame;
    recordBtn.frame = CGRectMake(cameraBtn.frame.origin.x + cameraBtn.frame.size.width + kMQInputBarHorizontalSpacing, (originalFrame.size.height - textViewHeight)/2, originalFrame.size.width - cameraBtn.frame.origin.x - cameraBtn.frame.size.width - kMQInputBarHorizontalSpacing * 3 - microphoneBtn.frame.size.width, textViewHeight);
    
    [self addSubview:toolbarDownBtn];
    [self addSubview:recordBtn];
    [self addSubview:microphoneBtn];
}

-(void)cameraClick
{
    [self textViewResignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:(id)self cancelButtonTitle:[MQBundleUtil localizedStringForKey:@"cancel"] destructiveButtonTitle:nil otherButtonTitles:[MQBundleUtil localizedStringForKey:@"select_gallery"], [MQBundleUtil localizedStringForKey:@"select_camera"], nil];
    [sheet showInView:self.superview];
}

-(void)toolbarDownClick
{
    microphoneBtn.hidden = NO;
    toolbarDownBtn.hidden = YES;
    [self textViewResignFirstResponder];
}

-(void)microphoneClick
{
    if (recordBtn.hidden) {
        recordBtn.hidden = NO;
        [microphoneBtn setImage:keyboardSenderImage forState:UIControlStateNormal];
        [microphoneBtn setImage:keyboardSenderHighlightedImage forState:UIControlStateHighlighted];
        [self textViewResignFirstResponder];
        [UIView animateWithDuration:.25 animations:^{
            //还原
            self.chatTableView.frame     = originalChatViewFrame;
            self.frame              = originalFrame;
            
            self.textView.frame     = originalTextViewFrame;
            self.textView.alpha     = 0;
            recordBtn.alpha         = 1;
            
            //居中
            [self functionBtnCenter];
        } completion:^(BOOL finished) {
            self.textView.hidden = YES;
        }];
    }else{
        [microphoneBtn setImage:voiceSenderImage forState:UIControlStateNormal];
        [microphoneBtn setImage:voiceSenderHighlightedImage forState:UIControlStateHighlighted];
        [self.textView becomeFirstResponder];
        self.textView.hidden = NO;
        [UIView animateWithDuration:.25 animations:^{
            self.textView.text      = self.textView.text;
            self.textView.alpha     = 1;
            recordBtn.alpha         = 0;
        } completion:^(BOOL finished) {
            recordBtn.hidden        = YES;
        }];
    }
}

-(void)reRecordBtn
{
    [recordBtn setTitle:[MQBundleUtil localizedStringForKey:@"record_speak"] forState:UIControlStateNormal];
    [UIView animateWithDuration:.2 animations:^{
        recordBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    }];
}

- (void)recordBtnLongPressed:(UILongPressGestureRecognizer*) longPressedRecognizer{
        
    if(longPressedRecognizer.state == UIGestureRecognizerStateBegan) {
        if(self.delegate){
            if ([self.delegate respondsToSelector:@selector(beginRecord:)]) {
                [self.delegate beginRecord:[longPressedRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]]];
            }
        }
        [recordBtn setTitle:[MQBundleUtil localizedStringForKey:@"record_end"] forState:UIControlStateNormal];
        [UIView animateWithDuration:.2 animations:^{
            recordBtn.backgroundColor = [UIColor colorWithWhite:.92 alpha:1];
        }];
    }else if(longPressedRecognizer.state == UIGestureRecognizerStateEnded || longPressedRecognizer.state == UIGestureRecognizerStateCancelled) {
        CGPoint point = [longPressedRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //为了防止用户松开太快，松开的以后，才进入系统麦克风权限的回调，所以增加0.2秒延迟
            [self endRecordWithPoint:point];
            [recordBtn setTitle:[MQBundleUtil localizedStringForKey:@"record_speak"] forState:UIControlStateNormal];
            [UIView animateWithDuration:.2 animations:^{
                recordBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
            }];
        });
    }else if(longPressedRecognizer.state == UIGestureRecognizerStateChanged) {
        [self changeRecordStatusWithPoint:[longPressedRecognizer locationInView:[[UIApplication sharedApplication] keyWindow]]];
    }
}

//改变录音的状态
- (void)changeRecordStatusWithPoint:(CGPoint)point {
    if ([self isFingerMoveUpToCancelRecordingWithPoint:point]) {
        //取消录音状态
        if(self.delegate){
            if ([self.delegate respondsToSelector:@selector(changedRecordViewToCancel:)]) {
                [self.delegate changedRecordViewToCancel:point];
            }
        }
    } else {
        //正常录音状态
        if(self.delegate){
            if ([self.delegate respondsToSelector:@selector(changedRecordViewToNormal:)]) {
                [self.delegate changedRecordViewToNormal:point];
            }
        }
    }
}

//结束录音，并判断是取消录音还是完成录音
- (void)endRecordWithPoint:(CGPoint)point {
    if ([self isFingerMoveUpToCancelRecordingWithPoint:point]) {
        //取消录音
        if(self.delegate){
            if ([self.delegate respondsToSelector:@selector(cancelRecord:)]) {
                [self.delegate cancelRecord:point];
            }
        }
    } else {
        //结束录音
        if(self.delegate){
            if ([self.delegate respondsToSelector:@selector(finishRecord:)]) {
                [self.delegate finishRecord:point];
            }
        }
    }
}

//判断手指是否上移取消发送
- (BOOL)isFingerMoveUpToCancelRecordingWithPoint:(CGPoint)point {
    float y = 0;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        y = [[UIApplication sharedApplication] keyWindow].frame.size.height - self.frame.size.height - point.y;
    }else{
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
            y = point.x;
        }else{
            y = [[UIApplication sharedApplication] keyWindow].frame.size.height - self.frame.size.height - point.y;
        }
    }
    if (y + 20 > 100) {
        return YES;
    }else{
        return NO;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: {
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(sendImageWithSourceType:)]) {
                    [self.delegate sendImageWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                }
            }
            break;
        }
        case 1: {
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(sendImageWithSourceType:)]) {
                    [self.delegate sendImageWithSourceType:(NSInteger*)UIImagePickerControllerSourceTypeCamera];
                }
            }
            break;
        }
    }
    actionSheet = nil;
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
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(chatTableViewScrollToBottom)]) {
                [self.delegate chatTableViewScrollToBottom];
            }
        }
        [self moveToolbarUp:keyboardHeight animate:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]];
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
        //        bullleViewHeight = self.chatTableView.frame.size.height - self.chatTableView.contentInset.top;
        bullleViewHeight = self.chatTableView.frame.size.height;
        chatViewInsets   = self.chatTableView.contentInset;
    }
    
    //内容与键盘的高度差。   可视区域 - 键盘高度 - 总内容高度
    keyboardDifference  = bullleViewHeight - height - self.chatTableView.contentSize.height;
    /*
     去要调整contentInset.top的情况：
     1、keyboardDifference大于0，说明内容不饱和，及contentInset.top加上键盘高度
     2、keyboardDifference小于0，contentInset.top加上bullleViewHeight再加keyboardDifference（相当于减，因为keyboardDifference为负数），但keyboardDifference的绝对值不能超过bullleViewHeight
     */
    [UIView animateWithDuration:duration animations:^{
        self.chatTableView.contentInset = UIEdgeInsetsMake(chatViewInsets.top + height,
                                                           chatViewInsets.left,
                                                           chatViewInsets.bottom,
                                                           chatViewInsets.right);
        
        if(keyboardDifference >= 0){
            //            self.chatTableView.contentInset = UIEdgeInsetsMake(chatViewInsets.top + height,
            //                                                               chatViewInsets.left,
            //                                                               chatViewInsets.bottom,
            //                                                               chatViewInsets.right);
        }else{
            //限制keyboardDifference大小
            if (-keyboardDifference > bullleViewHeight) {
                keyboardDifference = -bullleViewHeight;
            }
            if (!isInputBarUp) {
                //防止键盘抬起时，键盘变化去修改tableView
                self.chatTableView.contentInset = UIEdgeInsetsMake(self.chatTableView.contentInset.top + keyboardDifference + bullleViewHeight,
                                                                   self.chatTableView.contentInset.left,
                                                                   self.chatTableView.contentInset.bottom,
                                                                   self.chatTableView.contentInset.right);
            }
        }
        self.superview.frame = CGRectMake(self.superview.frame.origin.x,
                                          originalSuperViewFrame.origin.y - height,
                                          self.superview.frame.size.width,
                                          self.superview.frame.size.height);
    }];
    
    isInputBarUp = YES;
}

-(void)moveToolbarDown:(float)animateDuration
{
    if (!isInputBarUp) {
        return ;
    }
    [UIView animateWithDuration:animateDuration
                     animations:^{
                         self.superview.frame  = originalSuperViewFrame;
                         self.chatTableView.contentInset = chatViewInsets;
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
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(sendTextMessage:)]) {
                if([self.delegate sendTextMessage:self.textView.text]) {
                    [self.textView setText:@""];
                }
            }
        }
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(inputting:)]) {
            [self.delegate inputting:self.textView.text];
        }
    }
}

-(void)toolbarDownBtnVisible
{
    if (!enableSendVoice) {
        return;
    }
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft || statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        if ([self.textView isFirstResponder]) {
            microphoneBtn.hidden = YES;
            toolbarDownBtn.hidden = NO;
        }else{
            microphoneBtn.hidden = NO;
            toolbarDownBtn.hidden = YES;
        }
    }else{
        microphoneBtn.hidden = NO;
        toolbarDownBtn.hidden = YES;
    }
}

-(void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff     = (self.textView.frame.size.height - height);
    //确保tableView的y不大于原始的y
    CGFloat tableViewOriginY = self.chatTableView.frame.origin.y + diff;
    if (tableViewOriginY > originalChatViewFrame.origin.y) {
        tableViewOriginY = originalChatViewFrame.origin.y;
    }
    self.chatTableView.frame = CGRectMake(self.chatTableView.frame.origin.x, tableViewOriginY, self.chatTableView.frame.size.width, self.chatTableView.frame.size.height);
    self.frame     = CGRectMake(0, self.frame.origin.y + diff, self.frame.size.width, self.frame.size.height - diff);
    
    //居中
    [self functionBtnCenter];
}

-(void)functionBtnCenter
{
    cameraBtn.frame      = enableSendImage ? CGRectMake(kMQInputBarHorizontalSpacing, (self.frame.size.height - senderImageWidth)/2, senderImageWidth, senderImageWidth) : CGRectMake(0, 0, 0, 0);
    microphoneBtn.frame = enableSendVoice ? CGRectMake(self.frame.size.width - senderImageWidth - kMQInputBarHorizontalSpacing, (self.frame.size.height - senderImageWidth)/2, senderImageWidth, senderImageWidth) : CGRectMake(0, 0, 0, 0);
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

/** 更新frame */
- (void)updateFrame:(CGRect)frame {
    self.frame = frame;
    originalFrame = frame;
    originalChatViewFrame = self.chatTableView.frame;
    originalSuperViewFrame = self.superview.frame;
    cameraBtn.frame      = enableSendImage ? CGRectMake(kMQInputBarHorizontalSpacing, (self.frame.size.height - senderImageWidth)/2, senderImageWidth, senderImageWidth) : CGRectMake(0, 0, 0, 0);
    if (enableSendVoice) {
        microphoneBtn.frame = CGRectMake(self.frame.size.width - senderImageWidth - kMQInputBarHorizontalSpacing, (self.frame.size.height - senderImageWidth)/2, senderImageWidth, senderImageWidth);
        toolbarDownBtn.frame = microphoneBtn.frame;
        recordBtn.frame = CGRectMake(cameraBtn.frame.origin.x + cameraBtn.frame.size.width + kMQInputBarHorizontalSpacing, (originalFrame.size.height - textViewHeight)/2, microphoneBtn.frame.origin.x - cameraBtn.frame.origin.x - cameraBtn.frame.size.width - 2*kMQInputBarHorizontalSpacing, textViewHeight);
        self.textView.frame     = recordBtn.frame;
        originalTextViewFrame   = recordBtn.frame;
    } else {
        self.textView.frame = CGRectMake(cameraBtn.frame.origin.x + cameraBtn.frame.size.width + kMQInputBarHorizontalSpacing, (originalFrame.size.height - textViewHeight)/2, self.frame.size.width - cameraBtn.frame.origin.x - cameraBtn.frame.size.width - 2*kMQInputBarHorizontalSpacing, textViewHeight);
        originalTextViewFrame = self.textView.frame;
    }
}

@end
