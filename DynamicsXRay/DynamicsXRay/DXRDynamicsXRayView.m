//
//  DXRDynamicsXRayView.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayView.h"
#import "DXRDynamicsXRayBehaviorDrawing.h"
#import "DXRDynamicsXRayBehaviorAttachment.h"
#import "DXRDynamicsXRayBehaviorBoundaryCollision.h"
#import "DXRDynamicsXRayBehaviorGravity.h"
#import "DXRDynamicsXRayItemSnapshot.h"
#import "DXRDynamicsXRayItemSnapshot+DXRDrawing.h"


@interface DXRDynamicsXRayView ()

@property (strong, nonatomic) NSMutableArray *behaviorsToDraw;
@property (strong, nonatomic) NSMutableArray *dynamicItemsToDraw;

@end


@implementation DXRDynamicsXRayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _allowsAntialiasing = YES;

        _behaviorsToDraw = [NSMutableArray array];
        _dynamicItemsToDraw = [NSMutableArray array];
        
	self.backgroundColor = [UIColor clearColor];
	self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint length:(CGFloat)length isSpring:(BOOL)isSpring
{
    DXRDynamicsXRayBehaviorAttachment *attachment = [[DXRDynamicsXRayBehaviorAttachment alloc] initWithAnchorPoint:anchorPoint attachmentPoint:attachmentPoint length:length isSpring:isSpring];
    [self itemNeedsDrawing:attachment];
}

- (void)drawBoundsCollisionBoundaryWithRect:(CGRect)boundaryRect
{
    DXRDynamicsXRayBehaviorBoundaryCollision *collision = [[DXRDynamicsXRayBehaviorBoundaryCollision alloc] initWithBoundaryRect:boundaryRect];
    [self itemNeedsDrawing:collision];
}

- (void)drawGravityBehaviorWithMagnitude:(CGFloat)magnitude angle:(CGFloat)angle
{
    DXRDynamicsXRayBehaviorGravity *gravity = [[DXRDynamicsXRayBehaviorGravity alloc] initWithGravityMagnitude:magnitude angle:angle];
    [self itemNeedsDrawing:gravity];
}

- (void)itemNeedsDrawing:(DXRDynamicsXRayBehavior *)item
{
    [self.behaviorsToDraw addObject:item];

    [self setNeedsDisplay];
}

- (void)drawDynamicItems:(NSSet *)dynamicItems withReferenceView:(UIView *)referenceView
{
    if (dynamicItems && [dynamicItems count] > 0) {
        for (id<UIDynamicItem> item in dynamicItems) {
            CGRect itemBounds = item.bounds;
            CGPoint itemCenter = [self convertPoint:item.center fromReferenceView:referenceView];
            CGAffineTransform itemTransform = item.transform;

            DXRDynamicsXRayItemSnapshot *itemSnapshot = [DXRDynamicsXRayItemSnapshot snapshotWithBounds:itemBounds center:itemCenter transform:itemTransform];
            [self.dynamicItemsToDraw addObject:itemSnapshot];
        }

        [self setNeedsDisplay];
    }
}


#pragma mark - Coordinate Conversion

- (CGPoint)convertPoint:(CGPoint)point fromReferenceView:(UIView *)referenceView
{
    UIWindow *appWindow = [UIApplication sharedApplication].keyWindow;
    CGPoint result;

    if (referenceView) {
        result = [referenceView convertPoint:point toView:nil];
    }
    else {
        result = [self pointTransformedFromDeviceOrientation:point];
    }

    result = [self.window convertPoint:result fromWindow:appWindow];

    result.x += self.drawOffset.horizontal;
    result.y += self.drawOffset.vertical;

    return result;
}

- (CGPoint)pointTransformedFromDeviceOrientation:(CGPoint)point
{
    CGPoint result;
    CGSize windowSize = [UIApplication sharedApplication].keyWindow.bounds.size;
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;

    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight) {
        result.x = windowSize.width - point.y;
        result.y = point.x;
    }
    else if (statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        result.x = windowSize.width - point.x;
        result.y = windowSize.height - point.y;
    }
    else if (statusBarOrientation == UIInterfaceOrientationLandscapeLeft) {
        result.x = point.y;
        result.y = windowSize.height - point.x;
    }
    else {
        result = point;
    }

    return result;
}


#pragma mark - Drawing

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextClipToRect(context, self.bounds);
    CGContextSetAllowsAntialiasing(context, (bool)self.allowsAntialiasing);

    [[UIColor blueColor] set];

    for (DXRDynamicsXRayItemSnapshot *itemSnapshot in self.dynamicItemsToDraw) {
        CGContextSaveGState(context);
        [itemSnapshot drawInContext:context];
        CGContextRestoreGState(context);
    }

    for (DXRDynamicsXRayBehavior *behavior in self.behaviorsToDraw) {
        if ([behavior conformsToProtocol:@protocol(DXRDynamicsXRayBehaviorDrawing)]) {
            CGContextSaveGState(context);
            [(id<DXRDynamicsXRayBehaviorDrawing>)behavior drawInContext:context];
            CGContextRestoreGState(context);
        }
        else {
            DLog(@"WARNING: DXRDynamicsXRayBehavior is not drawable: %@", behavior);
        }
    }
    
    [self.behaviorsToDraw removeAllObjects];
    [self.dynamicItemsToDraw removeAllObjects];
}

@end
