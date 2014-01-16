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

    const CGFloat dashPattern[2] = {3.0f, 3.0f};
    CGContextSetLineDash(context, 3, dashPattern, 2);

    CGContextMoveToPoint(context, itemCenter.x, itemCenter.y);
    CGContextAddLineToPoint(context, anchorPoint.x, anchorPoint.y);

    CGContextStrokePath(context);
}

@end
