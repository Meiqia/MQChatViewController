#import <Foundation/Foundation.h>
#import "MEIQIA_FBFontSymbol.h"
#import <UIKit/UIKit.h>

@interface MEIQIA_FBSquareFont : NSObject
+ (void)drawSymbol:(FBFontSymbolType)symbol
horizontalEdgeLength:(CGFloat)horizontalEdgeLength
  verticalEdgeLength:(CGFloat)verticalEdgeLength
          startPoint:(CGPoint)startPoint
           inContext:(CGContextRef)ctx;
@end
