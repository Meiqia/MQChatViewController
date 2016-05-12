//
//  MQMessageFormController.m
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/4.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import "MQMessageFormViewController.h"
#import "MQBundleUtil.h"
#import "MQToast.h"
#import "MQChatDeviceUtil.h"
#import "MQAssetUtil.h"
#import "MQStringSizeUtil.h"
#import "MQMessageFormImageView.h"
#import "MQMessageFormInputView.h"
#import "MQMessageFormViewService.h"
#import "MQChatViewConfig.h"

static CGFloat const kMQMessageFormSpacing   = 16.0;
static NSString * const kMessageFormMessageKey = @"message";

@interface MQMessageFormViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, MQMessageFormImageViewDelegate>

@end

@implementation MQMessageFormViewController {
    MQMessageFormConfig *messageFormConfig;
    
    UIScrollView *scrollView;
    UILabel *tipLabel;
    UIView *formContainer;
    MQMessageFormImageView *messageFormImageView;
    
    CGSize viewSize;
    
    UIStatusBarStyle currentStatusBarStyle;//当前statusBar样式
    
    NSMutableArray *messageFormInputViewArray;
    NSMutableArray *messageFormInputModelArray;
    
    UIView *translucentView;
    UIActivityIndicatorView *activityIndicatorView;
}

- (instancetype)initWithConfig:(MQMessageFormConfig *)config {
    if (self = [super init]) {
        messageFormConfig = config;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = true;
    self.view.backgroundColor = messageFormConfig.messageFormViewStyle.backgroundColor;
    
    currentStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    viewSize = [UIScreen mainScreen].bounds.size;
    
    [self setNavBar];
    [self initScrollView];
    [self initTipLabel];
    [self initFormContainer];
    [self initMQMessageFormImageView];
    
    [self handleLeaveMessageIntro];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)setNavBar {
    self.navigationItem.title = [MQBundleUtil localizedStringForKey:@"leave_a_message"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:[MQBundleUtil localizedStringForKey:@"submit"] style:(UIBarButtonItemStylePlain) target:self action:@selector(tapSubmitBtn:)];
}

- (void)initScrollView {
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    [self.view addSubview:scrollView];
}

- (void)handleLeaveMessageIntro {
    if (messageFormConfig.leaveMessageIntro && messageFormConfig.leaveMessageIntro.length > 0) {
        tipLabel.text = messageFormConfig.leaveMessageIntro;
        tipLabel.hidden = NO;
        [self refreshFrame];
    } else {
#ifdef INCLUDE_MEIQIA_SDK
        [MQMessageFormViewService getMessageFormIntroComplete:^(NSString *intro, NSError *error) {
            if (intro && intro.length > 0) {
                tipLabel.text = intro;
                tipLabel.hidden = NO;
            } else {
                tipLabel.hidden = YES;
            }
            [self refreshFrame];
        }];
#endif
    }
}

#pragma ios7以下系统的横屏的事件
//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    NSLog(@"willAnimateRotationToInterfaceOrientation");
//    viewSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self refreshFrame];
    [self.view endEditing:YES];
}

#pragma ios8以上系统的横屏的事件
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self refreshFrame];
    }];
    [self.view endEditing:YES];
}

- (void)refreshFrame {
    viewSize = [UIScreen mainScreen].bounds.size;
    
    tipLabel.frame = CGRectMake(kMQMessageFormSpacing, kMQMessageFormSpacing, viewSize.width - kMQMessageFormSpacing * 2, 0);
    [tipLabel sizeToFit];
    
    UIView *lastMessageFormInputView = formContainer.subviews[formContainer.subviews.count - 1];
    CGFloat formContainerY = tipLabel.hidden ? kMQMessageFormSpacing : CGRectGetMaxY(tipLabel.frame) + kMQMessageFormSpacing;
    formContainer.frame = CGRectMake(0, formContainerY, viewSize.width, CGRectGetMaxY(lastMessageFormInputView.frame));
    [self refreshFormContainerFrame];
    [self refreshMessageFormImageViewFrame];
    
    scrollView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
    [scrollView setContentSize:CGSizeMake(viewSize.width, CGRectGetMaxY(messageFormImageView.frame))];
    
    if (translucentView) {
        translucentView.frame = CGRectMake(0, 0, viewSize.width, viewSize.height);
        [activityIndicatorView setCenter:CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0)];
    }
}

- (void)initTipLabel {
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(kMQMessageFormSpacing, kMQMessageFormSpacing, viewSize.width - kMQMessageFormSpacing * 2, 0)];
    tipLabel.textColor = [UIColor colorWithRed:118 / 255.0 green:125 / 255.0 blue:133 / 255.0 alpha:1];
    tipLabel.font = [UIFont systemFontOfSize:12.0];
    tipLabel.numberOfLines = 0;
    tipLabel.hidden = YES;
    [scrollView addSubview:tipLabel];
}

- (void)initFormContainer {
    MQMessageFormInputModel *defaultMQMessageFormInputModel = [[MQMessageFormInputModel alloc] init];
    defaultMQMessageFormInputModel.tip = [MQBundleUtil localizedStringForKey:@"leave_a_message"];
    defaultMQMessageFormInputModel.key = kMessageFormMessageKey;
    defaultMQMessageFormInputModel.isSingleLine = NO;
    defaultMQMessageFormInputModel.placeholder = [MQBundleUtil localizedStringForKey:@"leave_a_message_placeholder"];
    defaultMQMessageFormInputModel.isRequired = YES;
    
    messageFormInputModelArray = [NSMutableArray array];
    [messageFormInputModelArray addObject:defaultMQMessageFormInputModel];
    if (messageFormConfig.customMessageFormInputModelArray && messageFormConfig.customMessageFormInputModelArray.count > 0) {
        [messageFormInputModelArray addObjectsFromArray:messageFormConfig.customMessageFormInputModelArray];
    }
    
    formContainer = [[UIView alloc] init];
    messageFormInputViewArray = [NSMutableArray array];
    MQMessageFormInputView *messageFormInputView;
    for (MQMessageFormInputModel * model in messageFormInputModelArray) {
        messageFormInputView = [[MQMessageFormInputView alloc] initWithScreenWidth:viewSize.width andModel:model];
        
        [messageFormInputViewArray addObject:messageFormInputView];
        [formContainer addSubview:messageFormInputView];
    }
    
    [self refreshFormContainerFrame];
    [scrollView addSubview:formContainer];
}

- (void)refreshFormContainerFrame {
    MQMessageFormInputView *lastMessageFormInputView;
    MQMessageFormInputView *currentMessageFormInputView;
    for (MQMessageFormInputView *messageFormInputView in messageFormInputViewArray) {
        currentMessageFormInputView = messageFormInputView;
        if (lastMessageFormInputView) {
            [currentMessageFormInputView refreshFrameWithScreenWidth:viewSize.width andY:CGRectGetMaxY(lastMessageFormInputView.frame)];
        } else {
            [currentMessageFormInputView refreshFrameWithScreenWidth:viewSize.width andY:0];
        }
        lastMessageFormInputView = currentMessageFormInputView;
    }
    CGFloat formContainerY = tipLabel.hidden ? kMQMessageFormSpacing : CGRectGetMaxY(tipLabel.frame) + kMQMessageFormSpacing;
    formContainer.frame = CGRectMake(0, formContainerY, viewSize.width, CGRectGetMaxY(lastMessageFormInputView.frame));
}

- (void)initMQMessageFormImageView {
    messageFormImageView = [[MQMessageFormImageView alloc] initWithScreenWidth:viewSize.width];
    messageFormImageView.delegate = self;
    [self refreshMessageFormImageViewFrame];
    [scrollView addSubview:messageFormImageView];
}

- (void)refreshMessageFormImageViewFrame {
    [messageFormImageView refreshFrameWithScreenWidth:viewSize.width andY:CGRectGetMaxY(formContainer.frame)];
}

- (void)tapSubmitBtn:(id)sender {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:messageFormInputModelArray.count];
    for (int i = 0; i < messageFormInputModelArray.count; i++) {
        MQMessageFormInputModel *model = [messageFormInputModelArray objectAtIndex:i];
        NSString *text = [[messageFormInputViewArray objectAtIndex:i] getText];
        if (model.isRequired && text.length == 0) {
            [MQToast showToast:[NSString stringWithFormat:[MQBundleUtil localizedStringForKey:@"param_not_allow_null"], model.tip] duration:1.0 window:self.view];
            return;
        }
        [dict setObject:text forKey:model.key];
    }
    
    NSString *message = [dict objectForKey:kMessageFormMessageKey];
    [dict removeObjectForKey:kMessageFormMessageKey];
    
    [self dismissKeyboard];
    [self showActivityIndicatorView];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
#ifdef INCLUDE_MEIQIA_SDK
    [MQMessageFormViewService submitMessageFormWithMessage:message images:[messageFormImageView getImages] clientInfo:dict completion:^(BOOL success, NSError *error) {
        [self dismissActivityIndicatorView];
        
        if (success) {
            [self dismissMessageFormViewController];
        } else {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            [MQToast showToast:[MQBundleUtil localizedStringForKey:@"submit_failure"] duration:1.0 window:self.view];
        }
    }];
#endif
}

/**
 显示数据提交遮罩层
 */
- (void)showActivityIndicatorView {
    if (!translucentView) {
        translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
        translucentView.backgroundColor = [UIColor blackColor];
        translucentView.alpha = 0.5;
        
        activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicatorView setCenter:CGPointMake(viewSize.width / 2.0, viewSize.height / 2.0)];
        [translucentView addSubview:activityIndicatorView];
        [self.view addSubview:translucentView];
    }
    
    translucentView.hidden = NO;
    translucentView.alpha = 0;
    [activityIndicatorView startAnimating];
    [UIView animateWithDuration:0.5 animations:^{
        translucentView.alpha = 0.5;
    }];
}

/**
 隐藏数据提交遮罩层
 */
- (void)dismissActivityIndicatorView {
    if (translucentView) {
        [activityIndicatorView stopAnimating];
        translucentView.hidden = YES;
    }
}

- (void)dismissMessageFormViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    if (translucentView) {
        [translucentView removeFromSuperview];
    }
}

- (void)keyboardWillChangeFrame:(NSNotification *)note {
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGFloat keyboardMinY = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    CGFloat keyboardHeight = screenHeight - keyboardMinY;
    
    UIView *responderView = [self findFirstResponderForParentView:formContainer];
    // UITextView单独处理
    if (responderView && keyboardHeight > 0 && [responderView isKindOfClass:[UITextView class]]) {
        CGRect rect = [responderView.superview convertRect:responderView.frame toView:[[[UIApplication sharedApplication] delegate] window]];
        
        CGFloat responderMinY = rect.origin.y;
        CGFloat responderMaxY = CGRectGetMaxY(rect);
        
        CGFloat offsetY = 0;
        // 处理UITextView被键盘遮挡的情况
        if (responderMaxY > keyboardMinY) {
            offsetY = keyboardHeight + responderView.frame.size.height - (screenHeight - responderMinY);
        }
        // 处理UITextView被导航栏遮挡的情况
        if (responderMinY < 64) {
            offsetY = responderMinY - 64;
        }
        if (offsetY != 0) {
            [UIView animateWithDuration:duration animations:^{
                CGPoint offset = scrollView.contentOffset;
                scrollView.contentOffset = CGPointMake(offset.x, offset.y + offsetY);
            }];
        }
    }
    
    [UIView animateWithDuration:duration animations:^{
        UIEdgeInsets inset = scrollView.contentInset;
        inset.bottom = keyboardHeight;
        scrollView.contentInset = inset;
    }];
}

- (UIView *)findFirstResponderForParentView:(UIView *)parentView {
    for (UIView *view1 in parentView.subviews) {
        if ([view1 isFirstResponder]) {
            return view1;
        }
        
        if ([view1.subviews count] > 0) {
            UIView *view2 = [self findFirstResponderForParentView:view1];
            if (view2) {
                return view2;
            }
        }
    }
    return nil;
}

#pragma MQMessageFormImageViewDelegate
- (void)choosePictureWithSourceType:(UIImagePickerControllerSourceType *)sourceType {
    NSString *mediaPermission = [MQChatDeviceUtil isDeviceSupportImageSourceType:(int)sourceType];
    if (!mediaPermission) {
        return;
    }
    if (![mediaPermission isEqualToString:@"ok"]) {
        [MQToast showToast:[MQBundleUtil localizedStringForKey:mediaPermission] duration:2 window:self.view];
        return;
    }
    //兼容ipad打不开相册问题，使用队列延迟
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType               = (int)sourceType;
        picker.delegate                 = (id)self;
        [self presentViewController:picker animated:YES completion:nil];
    }];
}

#pragma UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if (![type isEqualToString:@"public.image"]) {
        return;
    }
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    [messageFormImageView addImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    //修改status样式
    if ([navigationController isKindOfClass:[UIImagePickerController class]]) {
        [UIApplication sharedApplication].statusBarStyle = currentStatusBarStyle;
    }
}

@end
