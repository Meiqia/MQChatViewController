#import <Foundation/Foundation.h>
#import "MEIQIA_FBFontSymbol.h"
#import <UIKit/UIKit.h>

@interface MEIQIA_FBLCDFont : NSObject
+ (void)drawSymbol:(FBFontSymbolType)symbol
        edgeLength:(CGFloat)edgeLength
         lineWidth:(CGFloat)lineWidth
        startPoint:(CGPoint)startPoint
         inContext:(CGContextRef)ctx;
@end

