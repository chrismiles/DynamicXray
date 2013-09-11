//
//  DXRDynamicsXRayView.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayView.h"
#import "DXRDynamicsXRayItemAttachment.h"
#import "DXRDynamicsXRayItemBoundaryCollision.h"
#import "DXRDynamicsXRayUtil.h"


@interface DXRDynamicsXRayView ()

@property (strong, nonatomic) NSMutableArray *dynamicItemsToDraw;

@end


@implementation DXRDynamicsXRayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
	_dynamicItemsToDraw = [NSMutableArray array];
        
	self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.1f];
	self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint length:(CGFloat)length isSpring:(BOOL)isSpring
{
    DXRDynamicsXRayItemAttachment *attachment = [[DXRDynamicsXRayItemAttachment alloc] initWithAnchorPoint:anchorPoint attachmentPoint:attachmentPoint length:length isSpring:isSpring];
    [self.dynamicItemsToDraw addObject:attachment];
    
    [self setNeedsDisplay];
}

- (void)drawBoundsCollisionBoundaryWithRect:(CGRect)boundaryRect
{
    DXRDynamicsXRayItemBoundaryCollision *collision = [[DXRDynamicsXRayItemBoundaryCollision alloc] initWithBoundaryRect:boundaryRect];
    [self.dynamicItemsToDraw addObject:collision];
    
    [self setNeedsDisplay];
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[[UIColor blueColor] colorWithAlphaComponent:0.6f] set];
    
    for (DXRDynamicsXRayItem *item in self.dynamicItemsToDraw) {
        CGContextSaveGState(context);
        [self dispatchItemDraw:item context:context];
        CGContextRestoreGState(context);
    }
    
    [self.dynamicItemsToDraw removeAllObjects];
}

- (void)dispatchItemDraw:(DXRDynamicsXRayItem *)item context:(CGContextRef)context
{
    if ([item isKindOfClass:[DXRDynamicsXRayItemAttachment class]]) {
        [self drawAttachmentItem:(DXRDynamicsXRayItemAttachment *)item context:context];
    }
    else if ([item isKindOfClass:[DXRDynamicsXRayItemBoundaryCollision class]]) {
        [self drawBoundaryCollisionItem:(DXRDynamicsXRayItemBoundaryCollision *)item context:context];
    }
}

- (void)drawAttachmentItem:(DXRDynamicsXRayItemAttachment *)item context:(CGContextRef)context
{
    CGFloat anchorCircleRadius = 2.0f;
    CGContextAddEllipseInRect(context, CGRectMake(item.anchorPoint.x - anchorCircleRadius, item.anchorPoint.y - anchorCircleRadius, anchorCircleRadius*2.0f, anchorCircleRadius*2.0f));
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextAddEllipseInRect(context, CGRectMake(item.attachmentPoint.x - anchorCircleRadius, item.attachmentPoint.y - anchorCircleRadius, anchorCircleRadius*2.0f, anchorCircleRadius*2.0f));
    CGContextDrawPath(context, kCGPathStroke);
    
    CGContextMoveToPoint(context, item.anchorPoint.x, item.anchorPoint.y);
    
    CGContextSaveGState(context);
    
    if (item.isSpring) {
        // Spring attachments are drawn as dashed lines
        CGFloat lineLength = DXRCGPointDistance(item.anchorPoint, item.attachmentPoint);
        CGFloat itemLength = (item.length > 0 ? item.length : 1.0f);
        CGFloat lineDiff = lineLength / itemLength;
        CGFloat dashSize = fmaxf(0.5f, 3.0f * lineDiff);
        const CGFloat dashPattern[2] = {dashSize, dashSize};
        CGContextSetLineDash(context, 3, dashPattern, 2);
    }
    
    CGContextAddLineToPoint(context, item.attachmentPoint.x, item.attachmentPoint.y);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

- (void)drawBoundaryCollisionItem:(DXRDynamicsXRayItemBoundaryCollision *)item context:(CGContextRef)context
{
    CGContextSetStrokeColorWithColor(context, [[[UIColor yellowColor] colorWithAlphaComponent:0.5f] CGColor]);
    CGContextSetLineWidth(context, 2.0f);
    CGContextAddRect(context, item.boundaryRect);
    CGContextDrawPath(context, kCGPathStroke);
}

@end
