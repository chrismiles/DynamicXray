//
//  DXRCollisionBehaviorSnapshot+DXRDrawing.m
//  DynamicXray
//
//  Created by Chris Miles on 5/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRCollisionBehaviorSnapshot+DXRDrawing.h"

@implementation DXRCollisionBehaviorSnapshot (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 2.0f);
    CGContextAddPath(context, self.path.CGPath);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
