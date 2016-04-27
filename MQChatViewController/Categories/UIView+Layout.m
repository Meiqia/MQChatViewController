

#import "UIView+Layout.h"

@implementation UIView(Layout)

- (CGFloat)viewWidth{
    return self.frame.size.width;
}

- (void)setViewWidth:(CGFloat)viewWidth{
    CGRect rect = self.frame;
    rect.size.width = viewWidth;
    self.frame = rect;
}

- (void)setViewHeight:(CGFloat)viewHeight
{
    CGRect rect = self.frame;
    rect.size.height = viewHeight;
    self.frame = rect;
}

- (CGFloat)viewHeight
{
    return self.frame.size.height;
}

- (CGFloat)viewRightEdge
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setViewRightEdge:(CGFloat)viewRightEdge
{
    CGRect rect = self.frame;
    rect.origin.x = viewRightEdge - rect.size.width;
    self.frame = rect;
}

- (CGFloat)viewBottomEdge
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setViewBottomEdge:(CGFloat)viewBottomEdge
{
    CGRect rect = self.frame;
    rect.origin.y = viewBottomEdge - rect.size.height;
    self.frame = rect;
}

- (CGFloat)viewY
{
    return self.frame.origin.y;
}

- (void)setViewY:(CGFloat)viewY
{
    CGRect rect = self.frame;
    rect.origin.y = viewY;
    self.frame = rect;
}

- (void)setViewX:(CGFloat)viewX
{
    CGRect rect = self.frame;
    rect.origin.x = viewX;
    self.frame = rect;
}

- (CGFloat)viewX
{
    return self.frame.origin.x;
}

- (void)setViewSize:(CGSize)viewSize
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, viewSize.width, viewSize.height);
}

- (CGSize)viewSize
{
    return self.frame.size;
}

- (void)setViewOrigin:(CGPoint)viewOrigin
{
    self.frame = CGRectMake(viewOrigin.x, viewOrigin.y, self.frame.size.width, self.frame.size.height);
}

- (CGPoint)viewOrigin
{
    return self.frame.origin;
}

- (CGPoint)boundsCenter{
    return CGPointMake(self.bounds.origin.x+self.bounds.size.width/2,self.bounds.origin.y+self.bounds.size.height/2);
}

//in .m file
- (void)frameIntegral{
    self.frame = CGRectIntegral(self.frame);
}

- (CGPoint)leftBottomCorner
{
    return CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
}

- (CGPoint)leftTopCorner
{
    return self.frame.origin;
}

- (CGPoint)rightTopCorner
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y);
}

- (CGPoint)rightBottomCorner
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

//-------------------------
#pragma mark View Alignment
//-------------------------

-(void)align:( ViewAlignment)alignment relativeToPoint:(CGPoint)point{
    switch (alignment) {
        case  ViewAlignmentTopLeft:
            self.viewOrigin = CGPointMake(point.x, point.y);
            break;
        case  ViewAlignmentTopCenter:
            self.viewOrigin = CGPointMake(point.x-self.viewWidth/2, point.y);
            break;
        case  ViewAlignmentTopRight:
            self.viewOrigin = CGPointMake(point.x-self.viewWidth, point.y);
            break;
        case  ViewAlignmentMiddleLeft:
            self.viewOrigin = CGPointMake(point.x, point.y-self.viewHeight/2);
            break;
        case  ViewAlignmentCenter:
            self.center     = CGPointMake(point.x, point.y);
            break;
        case  ViewAlignmentMiddleRight:
            self.viewOrigin = CGPointMake(point.x-self.viewWidth, point.y-self.viewHeight/2);
            break;
        case  ViewAlignmentBottomLeft:
            self.viewOrigin = CGPointMake(point.x, point.y-self.viewHeight);
            break;
        case  ViewAlignmentBottomCenter:
            self.viewOrigin = CGPointMake(point.x-self.viewWidth/2, point.y-self.viewHeight);
            break;
        case  ViewAlignmentBottomRight:
            self.viewOrigin = CGPointMake(point.x-self.viewWidth, point.y-self.viewHeight);
            break;
        default:
            break;
    }
    
    //just to be safe
//    [self frameIntegral];
}


-(void)align:( ViewAlignment)alignment relativeToRect:(CGRect)rect{
    CGPoint point = CGPointZero;
    switch (alignment){
        case  ViewAlignmentTopLeft:
            point = rect.origin;
            break;
        case  ViewAlignmentTopCenter:
            point = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y);
            break;
        case  ViewAlignmentTopRight:
            point = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y);
            break;
        case  ViewAlignmentMiddleLeft:
            point = CGPointMake(rect.origin.x, rect.origin.y +rect.size.height/2);
            break;
        case  ViewAlignmentCenter:
            point = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height/2);
            break;
        case  ViewAlignmentMiddleRight:
            point = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height/2);
            break;
        case  ViewAlignmentBottomLeft:
            point = CGPointMake(rect.origin.x, rect.origin.y+rect.size.height);
            break;
        case  ViewAlignmentBottomCenter:
            point = CGPointMake(rect.origin.x+rect.size.width/2, rect.origin.y+rect.size.height);
            break;
        case  ViewAlignmentBottomRight:
            point = CGPointMake(rect.origin.x+rect.size.width, rect.origin.y+rect.size.height);
            break;
        default:
            return;
    }
    [self align:alignment relativeToPoint:point];
}
@end
