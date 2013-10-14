//
//  DXRDynamicsXRayItemGravity+DXRDrawing.m
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayItemGravity+DXRDrawing.h"
@import UIKit;

static CGFloat const circleDiameter = 30.0f;
static CGFloat const arrowHeadPointOffsetAngle = 0.2f;


@implementation DXRDynamicsXRayItemGravity (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    CGRect circleFrame = CGRectMake(20.0f, 70.0f, circleDiameter, circleDiameter);
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(circleFrame), CGRectGetMidY(circleFrame));

    CGFloat angle = self.angle;
    CGPoint arrowEndPoint = CGPointMake(circleCenter.x + circleDiameter * cosf(angle), circleCenter.y + circleDiameter * sinf(angle));
    CGFloat arrowHeadPointPointRadius = circleDiameter * 0.8f;
    CGPoint arrowHeadPoint1 = CGPointMake(circleCenter.x + arrowHeadPointPointRadius * cosf(angle-arrowHeadPointOffsetAngle),
                                          circleCenter.y + arrowHeadPointPointRadius * sinf(angle-arrowHeadPointOffsetAngle));
    CGPoint arrowHeadPoint2 = CGPointMake(circleCenter.x + arrowHeadPointPointRadius * cosf(angle+arrowHeadPointOffsetAngle),
                                          circleCenter.y + arrowHeadPointPointRadius * sinf(angle+arrowHeadPointOffsetAngle));

    // Draw filled circle
    UIColor *circleColor = [[UIColor greenColor] colorWithAlphaComponent:0.9f];

    CGContextSetFillColorWithColor(context, [circleColor CGColor]);
    CGContextSetLineWidth(context, 1.0f);
    CGContextAddEllipseInRect(context, circleFrame);
    CGContextDrawPath(context, kCGPathFill);

    // Draw arrow
    CGContextSetStrokeColorWithColor(context, [circleColor CGColor]);
    CGContextMoveToPoint(context, circleCenter.x, circleCenter.y);
    CGContextAddLineToPoint(context, arrowEndPoint.x, arrowEndPoint.y);
    CGContextAddLineToPoint(context, arrowHeadPoint1.x, arrowHeadPoint1.y);
    CGContextMoveToPoint(context, arrowEndPoint.x, arrowEndPoint.y);
    CGContextAddLineToPoint(context, arrowHeadPoint2.x, arrowHeadPoint2.y);
    CGContextDrawPath(context, kCGPathStroke);

    // Draw label inside circle
    NSString *label = [NSString stringWithFormat:@"g=%g", self.magnitude];
    
    [[UIColor whiteColor] set];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attr = @{
                           NSParagraphStyleAttributeName: style,
                           NSFontAttributeName: [UIFont systemFontOfSize:10.0f]
                           };

    CGSize labelSize = [label sizeWithAttributes:attr];
    CGRect labelFrame = CGRectMake(circleFrame.origin.x, circleFrame.origin.y + (CGRectGetHeight(circleFrame) - labelSize.height)/2.0f, CGRectGetWidth(circleFrame), labelSize.height);
    [label drawInRect:labelFrame withAttributes:attr];
}

@end
