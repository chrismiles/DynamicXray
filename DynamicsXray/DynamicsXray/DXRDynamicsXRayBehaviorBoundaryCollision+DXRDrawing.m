//
//  DXRDynamicsXrayBehaviorBoundaryCollision+DXRDrawing.m
//  DynamicsXray
//
//  Created by Chris Miles on 2/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayBehaviorBoundaryCollision+DXRDrawing.h"

@implementation DXRDynamicsXrayBehaviorBoundaryCollision (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, [[[UIColor yellowColor] colorWithAlphaComponent:0.5f] CGColor]);
    CGContextSetLineWidth(context, 2.0f);
    CGContextAddRect(context, self.boundaryRect);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
