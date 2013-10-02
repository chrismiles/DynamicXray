//
//  DXRDynamicsXRayView.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayView.h"
#import "DXRDynamicsXRayItemDrawing.h"
#import "DXRDynamicsXRayItemAttachment.h"
#import "DXRDynamicsXRayItemBoundaryCollision.h"


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
        if ([item conformsToProtocol:@protocol(DXRDynamicsXRayItemDrawing)]) {
            CGContextSaveGState(context);
            [(id<DXRDynamicsXRayItemDrawing>)item drawInContext:context];
            CGContextRestoreGState(context);
        }
        else {
            DLog(@"WARNING: DXRDynamicsXRayItem is not drawable: %@", item);
        }
    }
    
    [self.dynamicItemsToDraw removeAllObjects];
}

@end
