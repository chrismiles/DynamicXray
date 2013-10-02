//
//  DynamicsXRay.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DynamicsXRay.h"
#import "DXRDynamicsXRayView.h"

/*
    Enable one or both of these macro definitons to dump object information.
    This is normally only needed by DynamicsXRay developers.
 */
//#define DYNAMIC_ANIMATOR_OBJECT_INTROSPECTION
//#define DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION

#if defined(DYNAMIC_ANIMATOR_OBJECT_INTROSPECTION) || defined(DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION)
#   import "NSObject+CMObjectIntrospection.h"
#endif


@interface DynamicsXRay ()

@property (weak, nonatomic) UIView *referenceView;
@property (strong, nonatomic) DXRDynamicsXRayView *xrayView;

@end


@implementation DynamicsXRay

- (id)init
{
    self = [super init];
    if (self) {
	_xrayView = [[DXRDynamicsXRayView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	__weak DynamicsXRay *weakSelf = self;
        self.action = ^{
	    __strong DynamicsXRay *strongSelf = weakSelf;
	    [strongSelf introspectDynamicAnimator:strongSelf.dynamicAnimator];
	};
    }
    return self;
}

- (void)dealloc
{
    [self.xrayView removeFromSuperview];
}

- (void)introspectDynamicAnimator:(UIDynamicAnimator *)dynamicAnimator
{
#ifdef DYNAMIC_ANIMATOR_OBJECT_INTROSPECTION
    [dynamicAnimator CMObjectIntrospectionDumpInfo];
#endif

    [self findReferenceView];
    
    if (self.xrayView.superview == nil) {
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	[keyWindow addSubview:self.xrayView];
    }
    
    [self introspectBehaviors:dynamicAnimator.behaviors];
}

- (void)findReferenceView
{
    UIView *referenceView = self.dynamicAnimator.referenceView;
    if (referenceView == nil) {
        UICollectionViewLayout *referenceSystem = [self.dynamicAnimator valueForKey:@"referenceSystem"];
        if (referenceSystem) {
            if ([referenceSystem respondsToSelector:@selector(collectionView)]) {
                referenceView = referenceSystem.collectionView;
            }
            else {
                DLog(@"Unknown reference system: %@", referenceSystem);
            }
        }
    }
    
    self.referenceView = referenceView;
}

- (void)introspectBehaviors:(NSArray *)behaviors
{
    for (UIDynamicBehavior *behavior in behaviors)
    {
        
#ifdef DYNAMIC_BEHAVIOR_OBJECT_INTROSPECTION
        [behavior CMObjectIntrospectionDumpInfo];
#endif
        
	if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
	    [self visualiseAttachmentBehavior:(UIAttachmentBehavior *)behavior];
	}
	else if ([behavior isKindOfClass:[UICollisionBehavior class]]) {
	    [self visualiseCollisionBehavior:(UICollisionBehavior *)behavior];
	}
        
        /* Introspect any child behaviors.
         */
        if ([behavior.childBehaviors count] > 0) {
            [self introspectBehaviors:behavior.childBehaviors];
        }
    }
}

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
    
    if (itemB) {
        // Item to Item

        CGPoint anchorPointB = CGPointZero;
        NSValue *anchorPointBValue = [attachmentBehavior valueForKey:@"anchorPointB"];
        if (anchorPointBValue) anchorPointB = [anchorPointBValue CGPointValue];

        anchorPoint = itemA.center;
        anchorPointA = CGPointApplyAffineTransform(anchorPointA, itemA.transform);
        anchorPoint.x += anchorPointA.x;
        anchorPoint.y += anchorPointA.y;
        anchorPoint = [self.xrayView convertPoint:anchorPoint fromView:self.referenceView];
        
        attachmentPoint = itemB.center;
        anchorPointB = CGPointApplyAffineTransform(anchorPointB, itemB.transform);
        attachmentPoint.x += anchorPointB.x;
        attachmentPoint.y += anchorPointB.y;
        attachmentPoint = [self.xrayView convertPoint:attachmentPoint fromView:self.referenceView];
    }
    else {
        // Anchor to Item
        
        anchorPoint = [self.xrayView convertPoint:attachmentBehavior.anchorPoint fromView:self.referenceView];
        
        attachmentPoint = itemA.center;
        anchorPointA = CGPointApplyAffineTransform(anchorPointA, itemA.transform);
        attachmentPoint.x += anchorPointA.x;
        attachmentPoint.y += anchorPointA.y;
        attachmentPoint = [self.xrayView convertPoint:attachmentPoint fromView:self.referenceView];
    }
    
    BOOL isSpring = (attachmentBehavior.frequency > 0.0);
    
    [self.xrayView drawAttachmentFromAnchor:anchorPoint toPoint:attachmentPoint length:attachmentBehavior.length isSpring:isSpring];
}

- (void)visualiseCollisionBehavior:(UICollisionBehavior *)collisionBehavior
{
    // TODO: boundaries by identifier
    //NSArray *boundaryIdentifiers = collisionBehavior.boundaryIdentifiers;
    //DLog(@"boundaryIdentifiers: %@", boundaryIdentifiers);
    
    if (collisionBehavior.translatesReferenceBoundsIntoBoundary) {
        UIView *referenceView = collisionBehavior.dynamicAnimator.referenceView;
        CGRect referenceBoundaryFrame = referenceView.frame;
        CGRect boundaryRect = [self.xrayView convertRect:referenceBoundaryFrame fromView:referenceView.superview];
        [self.xrayView drawBoundsCollisionBoundaryWithRect:boundaryRect];
    }
}

@end
