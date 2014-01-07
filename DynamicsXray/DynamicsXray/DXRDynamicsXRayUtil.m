//
//  DXRDynamicsXRayUtil.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayUtil.h"

CGFloat DXRCGPointDistance(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return sqrtf(dx*dx + dy*dy);
}
