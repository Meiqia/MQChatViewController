#import <Foundation/Foundation.h>
#import "FBFontSymbol.h"
#import <UIKit/UIKit.h>

@interface FBLCDFont : NSObject
+ (void)drawSymbol:(FBFontSymbolType)symbol
        edgeLength:(CGFloat)edgeLength
         lineWidth:(CGFloat)lineWidth
        startPoint:(CGPoint)startPoint
         inContext:(CGContextRef)ctx;
@end

