#import "MQToast.h"
#import <UIKit/UIKit.h>

static const float MQToastMaxWidth = 0.8; //window宽度的80%
static const float MQToastFontSize = 14;

@implementation MQToast

+ (void)showToast:(NSString*)message duration:(NSTimeInterval)interval window:(UIView*)window
{
    CGSize windowSize          = window.frame.size;

    UILabel* titleLabel        = [[UILabel alloc] init];
    titleLabel.numberOfLines   = 0;
    titleLabel.font            = [UIFont boldSystemFontOfSize:MQToastFontSize];
    titleLabel.textAlignment   = NSTextAlignmentCenter;
    titleLabel.lineBreakMode   = NSLineBreakByWordWrapping;
    titleLabel.textColor       = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.alpha           = 1.0;
    titleLabel.text            = message;
    
    CGSize maxSizeTitle      = CGSizeMake(windowSize.width * MQToastMaxWidth, windowSize.height);
    CGSize expectedSizeTitle = [message sizeWithFont:titleLabel.font constrainedToSize:maxSizeTitle lineBreakMode:titleLabel.lineBreakMode];
    titleLabel.frame         = CGRectMake(2, 2, expectedSizeTitle.width + 4, expectedSizeTitle.height);
    
    UIView* view             = [[UIView alloc] init];
    view.frame               = CGRectMake((windowSize.width - titleLabel.frame.size.width) / 2,
                                          windowSize.height * .85 - titleLabel.frame.size.height,
                                          titleLabel.frame.size.width + 4,
                                          titleLabel.frame.size.height + 4);
    view.backgroundColor     = [UIColor colorWithWhite:.2 alpha:.7];
    view.alpha               = 0;
    view.layer.cornerRadius  = view.frame.size.height * .15;
    view.layer.masksToBounds = YES;
    [view addSubview:titleLabel];
    
    [window addSubview:view];

    [UIView animateWithDuration:.25 animations:^{
        view.alpha = 1;
    } completion:^(BOOL finished) {
        if (interval > 0) {
            dispatch_time_t popTime =
            dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [UIView animateWithDuration:.25 animations:^{
                    view.alpha = 0;
                } completion:^(BOOL finished) {
                    [view removeFromSuperview];
                }];
            });
        }

    }];
}

@end