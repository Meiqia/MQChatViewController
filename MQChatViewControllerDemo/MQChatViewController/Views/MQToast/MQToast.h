#import <Foundation/Foundation.h>

@interface MQToast : NSObject

+ (void)showToast:(NSString*)message duration:(NSTimeInterval)interval window:(UIView*)window;

@end