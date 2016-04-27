//
//  MQFileDownloadCell.m
//  Meiqia-SDK-Demo
//
//  Created by ian luo on 16/4/6.
//  Copyright © 2016年 ijinmao. All rights reserved.
//

#import "MQFileDownloadCell.h"
#import "UIView+Layout.h"
#import "MQFileDownloadCellModel.h"
#import "MQChatViewConfig.h"
#import "MQImageUtil.h"
#import "MQChatViewConfig.h"
#import "MQAssetUtil.h"
#import "MQBundleUtil.h"

@interface MQFileDownloadCell()

@property (nonatomic, strong) MQFileDownloadCellModel *viewModel;

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UILabel *fileNameLabel;
@property (nonatomic, strong) UILabel *fileDetailLabel;
@property (nonatomic, strong) UIProgressView *downloadProgressBar;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *itemsView;
@property (nonatomic, strong) UITapGestureRecognizer *tagGesture;

@end

@implementation MQFileDownloadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.itemsView addSubview:self.icon];
        [self.itemsView addSubview:self.fileNameLabel];
        [self.itemsView addSubview:self.fileDetailLabel];
        [self.itemsView addSubview:self.actionButton];
        [self.itemsView addSubview:self.downloadProgressBar];
        
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.itemsView];
        
        [self updateUI];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateUI];
}

- (void)updateCellWithCellModel:(id<MQCellModelProtocol>)model {
    self.viewModel = model;
    
    [self updateUI];
    
    //user action callbacks
    __weak typeof (self)wself = self;
    
    [self.viewModel setNeedsToUpdateUI:^{
        __strong typeof (wself)sself = wself;
        [sself updateUI];
    }];
    
    [self.viewModel setAvatarLoaded:^(UIImage *image) {
        __strong typeof (wself)sself = wself;
        [sself.avatarImageView setImage:image];
    }];
    
    [self.viewModel setCellHeight:^CGFloat{
        __strong typeof (wself)sself = wself;
        [sself updateUI];
        return sself.viewHeight;
    }];
}

#pragma mark -

- (void)updateUI {
    MQFileDownloadStatus status = self.viewModel.fileDownloadStatus;
    
    //update UI contents according to status
    
    self.actionButton.hidden = (status == MQFileDownloadStatusDownloadComplete);
    self.downloadProgressBar.hidden = (status != MQFileDownloadStatusDownloading);
    
    CGFloat rightEdgeSpace = 5; //由于图片边界的原因，调整一下有图片和没有图片右边的距离，这样看起来协调一点.
    
    switch (status) {
        case MQFileDownloadStatusNotDownloaded: {
            [self.actionButton setImage:[MQAssetUtil fileDonwload] forState:UIControlStateNormal];
            if (self.viewModel.isExpired) {
                [self.fileDetailLabel setText:[NSString stringWithFormat:@"%@ ∙ %@",self.viewModel.fileSize, [MQBundleUtil localizedStringForKey:@"file_download_file_is_expired"]]];
            } else {
                [self.fileDetailLabel setText:[NSString stringWithFormat:[MQBundleUtil localizedStringForKey:@"file_download_ %@ ∙ %@overdue"], self.viewModel.fileSize, self.viewModel.timeBeforeExpire]];
            }
        }
        break;
        case MQFileDownloadStatusDownloading: {
            [self.actionButton setImage:[MQAssetUtil fileCancel] forState:UIControlStateNormal];
            self.downloadProgressBar.progress = 0;//表示开始下载
            [self.fileDetailLabel setText:[MQBundleUtil localizedStringForKey:@"file_download_downloading"]];
        }
        break;
        case MQFileDownloadStatusDownloadComplete: {
            [self.actionButton setImage:nil forState:UIControlStateNormal];
            [self.fileDetailLabel setText:[MQBundleUtil localizedStringForKey:@"file_download_complete"]];
            rightEdgeSpace = kMQCellBubbleToTextHorizontalLargerSpacing;
        }
        break;
    }
    
    [self.fileNameLabel setText:self.viewModel.fileName];
    [self.fileNameLabel sizeToFit];
    [self.fileDetailLabel sizeToFit];
    
    //layout
    
    [self.avatarImageView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(kMQCellAvatarToVerticalEdgeSpacing, kMQCellAvatarToHorizontalEdgeSpacing)];
    [self.itemsView align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(self.avatarImageView.viewRightEdge + kMQCellAvatarToBubbleSpacing, self.avatarImageView.viewY)];
    
    [self.icon align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(kMQCellBubbleToTextHorizontalLargerSpacing, kMQCellBubbleToTextVerticalSpacing)];
    [self.fileNameLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(self.icon.viewRightEdge + 5, self.icon.viewY)];
    
    [self.fileDetailLabel align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(self.fileNameLabel.viewX, self.fileNameLabel.viewBottomEdge + 5)];
    
    if (self.downloadProgressBar.isHidden) {
        self.downloadProgressBar.viewHeight = 0;
    } else {
        self.downloadProgressBar.viewHeight = 5;
    }
    
    CGFloat maxMiddleRightEdge = self.viewWidth - self.avatarImageView.viewRightEdge - !self.actionButton.isHidden * self.actionButton.viewWidth - kMQCellAvatarToVerticalEdgeSpacing - kMQCellBubbleMaxWidthToEdgeSpacing;
    CGFloat middlePartRightEdge = MIN(MAX(self.fileNameLabel.viewRightEdge, self.fileDetailLabel.viewRightEdge), maxMiddleRightEdge);
    self.fileNameLabel.viewWidth = maxMiddleRightEdge - self.fileNameLabel.viewX; // 防止文件名过长
    
    [self.downloadProgressBar align:ViewAlignmentTopLeft relativeToPoint:CGPointMake([MQChatViewConfig sharedConfig].bubbleImageStretchInsets.left, self.fileDetailLabel.viewBottomEdge + kMQCellBubbleToTextHorizontalSmallerSpacing)];
    
    [self.actionButton align:ViewAlignmentTopLeft relativeToPoint:CGPointMake(middlePartRightEdge + 5, kMQCellBubbleToTextVerticalSpacing)];
    
    self.itemsView.viewWidth = middlePartRightEdge + (5 + self.actionButton.viewWidth) * !self.actionButton.isHidden + rightEdgeSpace;
    
    self.downloadProgressBar.viewWidth = self.itemsView.viewWidth - [MQChatViewConfig sharedConfig].bubbleImageStretchInsets.left - [MQChatViewConfig sharedConfig].bubbleImageStretchInsets.right;
    
    self.itemsView.viewHeight = self.downloadProgressBar.viewBottomEdge;

    self.contentView.viewHeight = self.itemsView.viewBottomEdge + kMQCellAvatarToVerticalEdgeSpacing;
    self.viewHeight = self.contentView.viewHeight;
}

///点击状态按钮和整个cell都会触发此方法
- (void)actionForActionButton:(id)sender {
    switch (self.viewModel.fileDownloadStatus) {
        case MQFileDownloadStatusNotDownloaded: {
            __weak typeof (self)wself = self;
            [self.viewModel startDownloadWitchProcess:^(CGFloat process) {
                __strong typeof (wself)sself = wself;
                if (process >= 0 && process < 100) {
                    [sself.downloadProgressBar setProgress:process];
                } else if (process == 100) {
                    [sself updateUI];
                    [sself.viewModel openFile:self];
                } else {
                    [sself updateUI];
                }
            }];
        }
        break;
        case MQFileDownloadStatusDownloading: {
            if ([sender isKindOfClass:[UIButton class]]) { //取消操作只有在点击取消按钮时响应
                [self.viewModel cancelDownload];
            }
        }
        break;
        case MQFileDownloadStatusDownloadComplete: {
            [self.viewModel openFile:self];
        }
        break;
    }
}

#pragma mark - lazy load

- (UIImageView *)itemsView {
    if (!_itemsView) {
        _itemsView = [UIImageView new];
        _itemsView.userInteractionEnabled = true;
        UIImage *bubbleImage = [MQChatViewConfig sharedConfig].incomingBubbleImage;
        if ([MQChatViewConfig sharedConfig].incomingBubbleColor) {
            bubbleImage = [MQImageUtil convertImageColorWithImage:bubbleImage toColor:[MQChatViewConfig sharedConfig].incomingBubbleColor];
        }
        bubbleImage = [bubbleImage resizableImageWithCapInsets:[MQChatViewConfig sharedConfig].bubbleImageStretchInsets];
        _itemsView.image = bubbleImage;
        [_itemsView addGestureRecognizer:self.tagGesture];
    }
    return _itemsView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithImage:[MQAssetUtil fileIcon]];
        _icon.viewSize = CGSizeMake(kMQCellAvatarDiameter, kMQCellAvatarDiameter);
    }
    return _icon;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton new];
        _actionButton.viewSize = CGSizeMake(35, 35);
        [_actionButton addTarget:self action:@selector(actionForActionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (UILabel *)fileNameLabel {
    if (!_fileNameLabel) {
        _fileNameLabel = [UILabel new];
        _fileNameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _fileNameLabel;
}

- (UILabel *)fileDetailLabel {
    if (!_fileDetailLabel) {
        _fileDetailLabel = [UILabel new];
        _fileDetailLabel.font = [UIFont systemFontOfSize:12];
        _fileDetailLabel.textColor = [UIColor lightGrayColor];
    }
    return _fileDetailLabel;
}

- (UIProgressView *)downloadProgressBar {
    if (!_downloadProgressBar) {
        _downloadProgressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    }
    
    return _downloadProgressBar;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.contentMode = UIViewContentModeScaleAspectFit;
        _avatarImageView.viewSize = CGSizeMake(kMQCellAvatarDiameter, kMQCellAvatarDiameter);
        _avatarImageView.image = [MQChatViewConfig sharedConfig].incomingDefaultAvatarImage;
    }
    return _avatarImageView;
}

- (UITapGestureRecognizer *)tagGesture {
    if (!_tagGesture) {
        _tagGesture = [UITapGestureRecognizer new];
        [_tagGesture addTarget:self action:@selector(actionForActionButton:)];
    }
    return _tagGesture;
}

@end
