#import <Foundation/Foundation.h>
#import "FBFontSymbol.h"
#import <UIKit/UIKit.h>

typedef enum {
    FBFontDotTypeSquare,
    FBFontDotTypeCircle
} FBFontDotType;

@interface FBBitmapFont : NSObject
+ (void)drawBackgroundWithDotType:(FBFontDotType)dotType
                            color:(UIColor *)color
                       edgeLength:(CGFloat)edgeLength
                           margin:(CGFloat)margin
                 horizontalAmount:(CGFloat)horizontalAmount
                   verticalAmount:(CGFloat)verticalAmount
                        inContext:(CGContextRef)ctx;

+ (void)drawSymbol:(FBFontSymbolType)symbol
       withDotType:(FBFontDotType)dotType
             color:(UIColor *)color
        edgeLength:(CGFloat)edgeLength
            margin:(CGFloat)margin
        startPoint:(CGPoint)startPoint
         inContext:(CGContextRef)ctx;

+ (NSInteger)numberOfDotsWideForSymbol:(FBFontSymbolType)symbol;

@end
