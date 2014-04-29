//
//  DXRDynamicXrayItemSnapshot+DXRDrawing.m
//  DynamicXray
//
//  Created by Chris Miles on 7/11/2013.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayItemSnapshot+DXRDrawing.h"
#import "DynamicXray_Internal.h"

@implementation DXRDynamicXrayItemSnapshot (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    CGRect bounds = self.bounds;

    CGRect clipRect = CGContextGetClipBoundingBox(context);
    if (CGRectIntersectsRect(bounds, clipRect)) {
        CGContextSetShouldAntialias(context, false);

        CGFloat halfWidth = CGRectGetWidth(bounds)/2.0f;
        CGFloat halfHeight = CGRectGetHeight(bounds)/2.0f;

        CGContextTranslateCTM(context, self.center.x - halfWidth, self.center.y - halfHeight);

        CGContextTranslateCTM(context, halfWidth, halfHeight);
        CGContextConcatCTM(context, self.transform);
        CGContextTranslateCTM(context, -halfWidth, -halfHeight);

        CGContextAddRect(context, bounds);

        if (self.isContacted)
        {
            CGContextSaveGState(context);
            CGContextSetStrokeColorWithColor(context, [[DynamicXray xrayContactColor] colorWithAlphaComponent:self.contactedAlpha].CGColor);
        }

        CGContextStrokePath(context);

        if (self.isContacted)
        {
            CGContextRestoreGState(context);
        }
    }
}

@end
