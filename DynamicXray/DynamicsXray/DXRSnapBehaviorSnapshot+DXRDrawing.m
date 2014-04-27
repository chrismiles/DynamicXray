//
//  DXRSnapBehaviorSnapshot+DXRDrawing.m
//  DynamicsXray
//
//  Created by Chris Miles on 17/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRSnapBehaviorSnapshot+DXRDrawing.h"

@implementation DXRSnapBehaviorSnapshot (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    CGPoint itemCenter = self.itemCenter;
    CGPoint anchorPoint = self.anchorPoint;

    CGFloat xDiff = self.anchorPoint.x - self.itemCenter.x;
    CGFloat yDiff = self.anchorPoint.y - self.itemCenter.y;
    CGFloat lineLength = sqrtf(xDiff*xDiff + yDiff*yDiff);
    CGFloat arrowHeadLength = lineLength * 0.2f;
    CGFloat lineAngle = atan2f(yDiff, xDiff);
    CGFloat arrowHeadAngle1 = lineAngle + (150.0f * M_PI / 180.0f);
    CGFloat arrowHeadAngle2 = lineAngle - (150.0f * M_PI / 180.0f);
    CGPoint arrowHeadEndPoint1 = CGPointMake(anchorPoint.x + cosf(arrowHeadAngle1)*arrowHeadLength, anchorPoint.y + sinf(arrowHeadAngle1)*arrowHeadLength);
    CGPoint arrowHeadEndPoint2 = CGPointMake(anchorPoint.x + cosf(arrowHeadAngle2)*arrowHeadLength, anchorPoint.y + sinf(arrowHeadAngle2)*arrowHeadLength);

    const CGFloat dashPattern[2] = {3.0f, 3.0f};
    CGContextSetLineDash(context, 3, dashPattern, 2);

    CGContextMoveToPoint(context, itemCenter.x, itemCenter.y);
    CGContextAddLineToPoint(context, anchorPoint.x, anchorPoint.y);

    CGContextAddLineToPoint(context, arrowHeadEndPoint1.x, arrowHeadEndPoint1.y);
    CGContextMoveToPoint(context, anchorPoint.x, anchorPoint.y);
    CGContextAddLineToPoint(context, arrowHeadEndPoint2.x, arrowHeadEndPoint2.y);

    CGContextStrokePath(context);
}

@end
