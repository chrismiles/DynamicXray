//
//  DynamicsXray+XrayVisualiseBehaviors.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray+XrayVisualiseBehaviors.h"
#import "DynamicsXray_Internal.h"

#import "DXRDynamicsXrayView.h"


@implementation DynamicsXray (XrayVisualiseBehaviors)

#pragma mark - Attachment Behavior

- (void)visualiseAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior
{
    NSValue *anchorPointAValue = [attachmentBehavior valueForKey:@"anchorPointA"];

    CGPoint anchorPointA = CGPointZero;
    if (anchorPointAValue) anchorPointA = [anchorPointAValue CGPointValue];

    id<UIDynamicItem> itemA = nil;
    id<UIDynamicItem> itemB = nil;

    itemA = attachmentBehavior.items[0];

    if ([attachmentBehavior.items  count] > 1) {
        itemB = attachmentBehavior.items[1];
    }

    CGPoint anchorPoint, attachmentPoint;
    DXRDynamicsXrayView *xrayView = [self xrayView];
    UIView *referenceView = self.referenceView;

    if (itemB) {
        // Item to Item

        CGPoint anchorPointB = CGPointZero;
        NSValue *anchorPointBValue = [attachmentBehavior valueForKey:@"anchorPointB"];
        if (anchorPointBValue) anchorPointB = [anchorPointBValue CGPointValue];

        anchorPoint = itemA.center;
        anchorPointA = CGPointApplyAffineTransform(anchorPointA, itemA.transform);
        anchorPoint.x += anchorPointA.x;
        anchorPoint.y += anchorPointA.y;
        anchorPoint = [xrayView convertPoint:anchorPoint fromReferenceView:referenceView];

        attachmentPoint = itemB.center;
        anchorPointB = CGPointApplyAffineTransform(anchorPointB, itemB.transform);
        attachmentPoint.x += anchorPointB.x;
        attachmentPoint.y += anchorPointB.y;
        attachmentPoint = [xrayView convertPoint:attachmentPoint fromReferenceView:referenceView];
    }
    else {
        // Anchor to Item

        anchorPoint = [xrayView convertPoint:attachmentBehavior.anchorPoint fromReferenceView:referenceView];

        attachmentPoint = itemA.center;
        anchorPointA = CGPointApplyAffineTransform(anchorPointA, itemA.transform);
        attachmentPoint.x += anchorPointA.x;
        attachmentPoint.y += anchorPointA.y;
        attachmentPoint = [xrayView convertPoint:attachmentPoint fromReferenceView:referenceView];
    }

    BOOL isSpring = (attachmentBehavior.frequency > 0.0);

    [xrayView drawAttachmentFromAnchor:anchorPoint toPoint:attachmentPoint length:attachmentBehavior.length isSpring:isSpring];

    [self.dynamicItemsToDraw addObjectsFromArray:attachmentBehavior.items];
}


#pragma mark - Collision Behavior

- (void)visualiseCollisionBehavior:(UICollisionBehavior *)collisionBehavior
{
    // TODO: boundaries by identifier
    //NSArray *boundaryIdentifiers = collisionBehavior.boundaryIdentifiers;
    //DLog(@"boundaryIdentifiers: %@", boundaryIdentifiers);

    if (collisionBehavior.translatesReferenceBoundsIntoBoundary) {
        UIView *referenceView = collisionBehavior.dynamicAnimator.referenceView;
        CGRect referenceBoundaryFrame = referenceView.frame;
        CGRect boundaryRect = [self.xrayViewController.xrayView convertRect:referenceBoundaryFrame fromView:referenceView.superview];
        [self.xrayViewController.xrayView drawBoundsCollisionBoundaryWithRect:boundaryRect];
    }

    [self.dynamicItemsToDraw addObjectsFromArray:collisionBehavior.items];
}


#pragma mark - Gravity Behavior

- (void)visualiseGravityBehavior:(UIGravityBehavior *)gravityBehavior
{
    [self.xrayViewController.xrayView drawGravityBehaviorWithMagnitude:gravityBehavior.magnitude angle:gravityBehavior.angle];

    [self.dynamicItemsToDraw addObjectsFromArray:gravityBehavior.items];
}

@end
