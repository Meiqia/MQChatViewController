#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MQToast : NSObject

+ (void)showToast:(NSString*)message duration:(NSTimeInterval)interval window:(UIView*)window;

@end