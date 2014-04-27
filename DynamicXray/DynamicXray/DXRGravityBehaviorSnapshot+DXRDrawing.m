//
//  DXRGravityBehaviorSnapshot+DXRDrawing.m
//  DynamicsXray
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRGravityBehaviorSnapshot+DXRDrawing.h"
#import "DynamicXray_Internal.h"
@import UIKit;

static CGFloat const circleDiameter = 40.0f;
static CGFloat const arrowHeadPointOffsetAngle = 0.25f;


@implementation DXRGravityBehaviorSnapshot (DXRDrawing)

- (void)drawInContext:(CGContextRef)context
{
    CGRect circleFrame = CGRectMake(20.0f, 70.0f, circleDiameter, circleDiameter);
    CGPoint circleCenter = CGPointMake(CGRectGetMidX(circleFrame), CGRectGetMidY(circleFrame));

    CGFloat angle = self.angle;
    CGFloat arrowRadius = circleDiameter / 2.0f - 1.0f;
    CGPoint arrowEndPoint = CGPointMake(circleCenter.x + arrowRadius * cosf(angle), circleCenter.y + arrowRadius * sinf(angle));
    CGFloat arrowHeadPointEndRadius = arrowRadius * 0.7f;
    CGPoint arrowHeadPoint1 = CGPointMake(circleCenter.x + arrowHeadPointEndRadius * cosf(angle-arrowHeadPointOffsetAngle),
                                          circleCenter.y + arrowHeadPointEndRadius * sinf(angle-arrowHeadPointOffsetAngle));
    CGPoint arrowHeadPoint2 = CGPointMake(circleCenter.x + arrowHeadPointEndRadius * cosf(angle+arrowHeadPointOffsetAngle),
                                          circleCenter.y + arrowHeadPointEndRadius * sinf(angle+arrowHeadPointOffsetAngle));

    // Draw circle
    CGContextSetLineWidth(context, 1.0f);
    CGContextAddEllipseInRect(context, circleFrame);
    CGContextDrawPath(context, kCGPathStroke);

    // Draw arrow
    CGContextMoveToPoint(context, arrowEndPoint.x, arrowEndPoint.y);
    CGContextAddLineToPoint(context, arrowHeadPoint1.x, arrowHeadPoint1.y);
    CGContextMoveToPoint(context, arrowEndPoint.x, arrowEndPoint.y);
    CGContextAddLineToPoint(context, arrowHeadPoint2.x, arrowHeadPoint2.y);
    CGContextDrawPath(context, kCGPathStroke);

    // Draw label inside circle
    NSString *label = [NSString stringWithFormat:@"%0.1fg", self.magnitude];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attr = @{
                           NSParagraphStyleAttributeName: style,
                           NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:11.0f],
                           NSForegroundColorAttributeName: [DynamicXray xrayStrokeColor],
                           };

    CGSize labelSize = [label sizeWithAttributes:attr];
    CGRect labelFrame = CGRectMake(circleFrame.origin.x, circleFrame.origin.y + (CGRectGetHeight(circleFrame) - labelSize.height)/2.0f, CGRectGetWidth(circleFrame), labelSize.height);
    [label drawInRect:labelFrame withAttributes:attr];
}

@end
