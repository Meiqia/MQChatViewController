//
//  MQMessageFormInputView.m
//  MeiQiaSDK
//
//  Created by bingoogolapple on 16/5/6.
//  Copyright © 2016年 MeiQia Inc. All rights reserved.
//

#import "MQMessageFormInputView.h"
#import "MQMessageFormTextView.h"
#import "MQMessageFormConfig.h"

static CGFloat const kMQMessageFormSpacing   = 16.0;

@implementation MQMessageFormInputView {
    UILabel *tipLabel;
    UITextField *contentTf;
    MQMessageFormTextView *contentTv;
    UIView *topLine;
    UIView *bottomLine;
}

- (instancetype)initWithScreenWidth:(CGFloat)screenWidth andModel:(MQMessageFormInputModel *)model {
    self = [super init];
    if (self) {
        [self initTipLabelWithModel:model andScreenWidth:screenWidth];
        if (model.isSingleLine) {
            [self initContentTfWidthModel:model andScreenWidth:screenWidth];
        } else {
            [self initContentTvWidthModel:model andScreenWidth:screenWidth];
        }
    }
    return self;
}

- (void)initTipLabelWithModel:(MQMessageFormInputModel *)model andScreenWidth:(CGFloat)screenWidth {
    tipLabel = [[UILabel alloc] init];
    tipLabel.text = model.tip;
    [self refreshTipLabelFrameWithScreenWidth:screenWidth];
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.textColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTipTextColor;
    
    if (model.isRequired) {
        NSString *text = [NSString stringWithFormat:@"%@%@", tipLabel.text, @"*"];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        [attributedText addAttribute:NSForegroundColorAttributeName value:tipLabel.textColor range:NSMakeRange(0, model.tip.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(model.tip.length, 1)];
        tipLabel.attributedText = attributedText;
    }
    [self addSubview:tipLabel];
}

- (void)refreshTipLabelFrameWithScreenWidth:(CGFloat)screenWidth {
    [tipLabel sizeToFit];
    tipLabel.frame = CGRectMake(kMQMessageFormSpacing, 0, screenWidth - kMQMessageFormSpacing * 2, tipLabel.frame.size.height + kMQMessageFormSpacing / 2);
}

- (void)initContentTfWidthModel:(MQMessageFormInputModel *)model andScreenWidth:(CGFloat)screenWidth {
    contentTf = [[UITextField alloc] init];
    contentTf.textColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTextColor;
    contentTf.backgroundColor = [UIColor whiteColor];
    contentTf.tintColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputPlaceholderTextColor;
    contentTf.font = [UIFont systemFontOfSize:14];
    contentTf.placeholder = model.placeholder;
    contentTf.keyboardType = model.keyboardType;
    contentTf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMQMessageFormSpacing, contentTf.frame.size.height)];
    contentTf.leftViewMode = UITextFieldViewModeAlways;
    
    contentTf.rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMQMessageFormSpacing, contentTf.frame.size.height)];
    contentTf.rightViewMode = UITextFieldViewModeAlways;
    
    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTopBottomBorderColor;
    [contentTf addSubview:topLine];
    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTopBottomBorderColor;
    [contentTf addSubview:bottomLine];
    
    [self refreshcontentTfFrameWithScreenWidth:screenWidth];
    [self addSubview:contentTf];
}

- (void)refreshcontentTfFrameWithScreenWidth:(CGFloat)screenWidth {
    if (contentTf) {
        contentTf.frame = CGRectMake(0, CGRectGetMaxY(tipLabel.frame), screenWidth, 42);
        topLine.frame = CGRectMake(0, 0, contentTf.frame.size.width, 1);
        bottomLine.frame = CGRectMake(0, contentTf.frame.size.height - 1, contentTf.frame.size.width, 1);
    }
}

- (void)initContentTvWidthModel:(MQMessageFormInputModel *)model andScreenWidth:(CGFloat)screenWidth {
    UIView *contentContainer = [[UIView alloc] init];
    contentContainer.backgroundColor = [UIColor whiteColor];
    
    contentTv = [[MQMessageFormTextView alloc] init];
    contentTv.keyboardType = model.keyboardType;
    contentTv.textColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTextColor;
    contentTv.backgroundColor = [UIColor whiteColor];
    contentTv.tintColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputPlaceholderTextColor;
    contentTv.placeholder = model.placeholder;
    contentTv.font = [UIFont systemFontOfSize:14];
    contentTv.showsVerticalScrollIndicator = NO;
    [contentContainer addSubview:contentTv];
    
    topLine = [[UIView alloc] init];
    topLine.backgroundColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTopBottomBorderColor;
    [contentContainer addSubview:topLine];
    bottomLine = [[UIView alloc] init];
    bottomLine.backgroundColor = [MQMessageFormConfig sharedConfig].messageFormViewStyle.inputTopBottomBorderColor;
    [contentContainer addSubview:bottomLine];
    
    [self refreshcontentTvFrameWithScreenWidth:screenWidth];
    [self addSubview:contentContainer];
}

- (void)refreshcontentTvFrameWithScreenWidth:(CGFloat)screenWidth {
    if (contentTv) {
        UIView *contentContainer = contentTv.superview;
        contentContainer.frame = CGRectMake(0, CGRectGetMaxY(tipLabel.frame), screenWidth, 126);
        contentTv.frame = CGRectMake(kMQMessageFormSpacing - 5, 0, screenWidth - kMQMessageFormSpacing * 2 + 5, contentContainer.frame.size.height);
        topLine.frame = CGRectMake(0, 0, contentContainer.frame.size.width, 1);
        bottomLine.frame = CGRectMake(0, contentContainer.frame.size.height, contentContainer.frame.size.width, 1);
    }
}

- (void)refreshFrameWithScreenWidth:(CGFloat)screenWidth andY:(CGFloat)y {
    [self refreshTipLabelFrameWithScreenWidth:screenWidth];
    [self refreshcontentTfFrameWithScreenWidth:screenWidth];
    [self refreshcontentTvFrameWithScreenWidth:screenWidth];
    self.frame = CGRectMake(0, y, screenWidth, CGRectGetMaxY(contentTf == nil ? contentTv.superview.frame : contentTf.frame));
}

- (NSString *)getText {
    if (contentTf) {
        return [contentTf.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        return [contentTv.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

@end
