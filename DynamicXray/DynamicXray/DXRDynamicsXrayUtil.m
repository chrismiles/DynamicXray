//
//  DXRDynamicXrayUtil.m
//  DynamicXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayUtil.h"

CGFloat DXRCGPointDistance(CGPoint point1, CGPoint point2)
{
    CGFloat dx = point2.x - point1.x;
    CGFloat dy = point2.y - point1.y;
    return (CGFloat)sqrt(dx*dx + dy*dy);
}
