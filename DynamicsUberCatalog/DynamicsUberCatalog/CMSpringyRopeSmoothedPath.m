//
//  CMSpringyRopeSmoothedPath.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 30/09/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//
//  Based on CMTraerPhysics demo by Chris Miles, https://github.com/chrismiles/CMTraerPhysics
//  Parts derived from code by Erica Sadun, BSD Licensed.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CMSpringyRopeSmoothedPath.h"

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]
#define VALUE(_INDEX_) [NSValue valueWithCGPoint:points[_INDEX_]]

static void getPointsFromBezier(void *info, const CGPathElement *element)
{
    // Silence warning about use of __bridge outside of ARC, but required
    // for auto ARC conversion
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-bridge-casts-disallowed-in-nonarc"
    
    NSMutableArray *bezierPoints = (__bridge NSMutableArray *)info;
    
#pragma clang diagnostic pop
    
    
    // Retrieve the path element type and its points
    CGPathElementType type = element->type;
    CGPoint *points = element->points;
    
    // Add the points if they're available (per type)
    if (type != kCGPathElementCloseSubpath)
    {
        [bezierPoints addObject:VALUE(0)];
        if ((type != kCGPathElementAddLineToPoint) &&
            (type != kCGPathElementMoveToPoint))
            [bezierPoints addObject:VALUE(1)];
    }
    if (type == kCGPathElementAddCurveToPoint)
        [bezierPoints addObject:VALUE(2)];
}

static NSArray *pointsFromBezierPath(UIBezierPath *bpath)
{
    NSMutableArray *points = [NSMutableArray array];
    
    // Silence warning about use of __bridge outside of ARC, but required
    // for auto ARC conversion
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-bridge-casts-disallowed-in-nonarc"
    
    CGPathApply(bpath.CGPath, (__bridge void *)points, getPointsFromBezier);
    
#pragma clang diagnostic pop
    
    return points;
}

UIBezierPath *smoothedPath(UIBezierPath *bpath, int granularity)
{
    NSArray *points = pointsFromBezierPath(bpath);
    
    if (points.count < 4) return bpath;
    
    UIBezierPath *smoothedPath = [UIBezierPath bezierPath];
    
    // Copy traits
    smoothedPath.lineWidth = bpath.lineWidth;
    
    [smoothedPath moveToPoint:POINT(0)];
    for (NSUInteger index = 1; index < points.count-2; index++)
    {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++)
        {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5f * (2.0f*p1.x+(p2.x-p0.x)*t + (2.0f*p0.x-5.0f*p1.x+4.0f*p2.x-p3.x)*tt + (3.0f*p1.x-p0.x-3.0f*p2.x+p3.x)*ttt);
            pi.y = 0.5f * (2.0f*p1.y+(p2.y-p0.y)*t + (2.0f*p0.y-5.0f*p1.y+4.0f*p2.y-p3.y)*tt + (3.0f*p1.y-p0.y-3.0f*p2.y+p3.y)*ttt);
            [smoothedPath addLineToPoint:pi];
        }
        
        // Now add p2
        [smoothedPath addLineToPoint:p2];
    }
    
    // finish by adding the last point
    [smoothedPath addLineToPoint:POINT(points.count - 1)];
    
    return smoothedPath;
}
