//
//  DXRPushBehaviorSnapshot+DXRDrawing.m
//  DynamicsXray
//
//  Created by Chris Miles on 21/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRPushBehaviorSnapshot+DXRDrawing.h"

static CGFloat const DXRPushBehaviorLineMagnitudeScaleFactor = 50.0f;
static CGFloat const DXRPushBehaviorMinimalLineLength = 10.0f;


@implementation DXRPushBehaviorSnapshot (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    if (self.magnitude > 0) {
        CGPoint pushLocation = self.pushLocation;
        CGFloat lineAngle = self.angle;
        CGFloat lineLength = self.magnitude * DXRPushBehaviorLineMagnitudeScaleFactor;
        if (lineLength < DXRPushBehaviorMinimalLineLength) lineLength = DXRPushBehaviorMinimalLineLength;

        CGPoint lineStartLocation = CGPointMake(pushLocation.x - lineLength * cosf(lineAngle), pushLocation.y - lineLength * sinf(lineAngle));

        CGFloat arrowHeadLength = lineLength * 0.3f;
        CGFloat arrowHeadAngle1 = lineAngle + (150.0f * M_PI / 180.0f);
        CGFloat arrowHeadAngle2 = lineAngle - (150.0f * M_PI / 180.0f);
        CGPoint arrowHeadEndPoint1 = CGPointMake(pushLocation.x + cosf(arrowHeadAngle1)*arrowHeadLength, pushLocation.y + sinf(arrowHeadAngle1)*arrowHeadLength);
        CGPoint arrowHeadEndPoint2 = CGPointMake(pushLocation.x + cosf(arrowHeadAngle2)*arrowHeadLength, pushLocation.y + sinf(arrowHeadAngle2)*arrowHeadLength);

        CGFloat circleRadius = 0.5f;

        if (circleRadius > 0) {
            // Draw circle at push location
            CGContextAddEllipseInRect(context, CGRectMake(pushLocation.x - circleRadius, pushLocation.y - circleRadius, circleRadius*2.0f, circleRadius*2.0f));
            CGContextDrawPath(context, kCGPathFillStroke);
        }

        // Animate the line dash
        CGFloat dashPhase = -fmod([[NSDate date] timeIntervalSinceReferenceDate] * 20.0, 6.0);
        const CGFloat dashPattern[2] = {3.0f, 3.0f};
        CGContextSetLineDash(context, dashPhase, dashPattern, 2);

        // Draw push line
        CGContextMoveToPoint(context, lineStartLocation.x, lineStartLocation.y);
        CGContextAddLineToPoint(context, pushLocation.x, pushLocation.y);

        // Draw arrow head
        CGContextAddLineToPoint(context, arrowHeadEndPoint1.x, arrowHeadEndPoint1.y);
        CGContextMoveToPoint(context, pushLocation.x, pushLocation.y);
        CGContextAddLineToPoint(context, arrowHeadEndPoint2.x, arrowHeadEndPoint2.y);

        CGContextStrokePath(context);
    }
}

@end
