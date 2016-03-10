#import <Foundation/Foundation.h>
#import "MEIQIA_FBFontSymbol.h"
#import <UIKit/UIKit.h>

typedef enum {
    FBFontDotTypeSquare,
    FBFontDotTypeCircle
} FBFontDotType;

@interface MEIQIA_FBBitmapFont : NSObject
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
