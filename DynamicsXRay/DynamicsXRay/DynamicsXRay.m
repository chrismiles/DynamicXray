//
//  DynamicsXRay.m
//  DynamicsXRay
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DynamicsXRay.h"
#import "DXRDynamicsXRayView.h"
//#import "NSObject+CMObjectIntrospection.h" // Only needed during development

@interface DynamicsXRay ()

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
    if (self.xrayView.superview == nil) {
	UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	[keyWindow addSubview:self.xrayView];
    }
    
    [self introspectBehaviors:dynamicAnimator.behaviors];
}

- (void)introspectBehaviors:(NSArray *)behaviors
{
    for (UIDynamicBehavior *behavior in behaviors) {
	if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
	    [self visualiseAttachmentBehavior:(UIAttachmentBehavior *)behavior];
	}
        
        if ([behavior.childBehaviors count] > 0) {
            [self introspectBehaviors:behavior.childBehaviors];
        }
    }
}

- (void)visualiseAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior
{
    //[attachmentBehavior CMObjectIntrospectionDumpInfo]; // Only needed during development
    //[self.dynamicAnimator CMObjectIntrospectionDumpInfo]; // Only needed during development
    
    //id anchorPoint = [attachmentBehavior valueForKey:@"anchorPoint"];
    NSValue *anchorPointAValue = [attachmentBehavior valueForKey:@"anchorPointA"];
    //id anchorPointB = [attachmentBehavior valueForKey:@"anchorPointB"];
    
    CGPoint anchorPointA = CGPointZero;
    if (anchorPointAValue) anchorPointA = [anchorPointAValue CGPointValue];
    
    // TODO: support attachments from item to item
    
    id<UIDynamicItem> item = attachmentBehavior.items[0];
    
    // TODO: need reference to collection view layout + collection view...
    
    UIView *referenceView = self.dynamicAnimator.referenceView;
    if (referenceView == nil) {
        UICollectionViewLayout *referenceSystem = [self.dynamicAnimator valueForKey:@"referenceSystem"];
        if ([referenceSystem respondsToSelector:@selector(collectionView)]) {
            referenceView = referenceSystem.collectionView;
        }
    }
    
    ZAssert(referenceView != nil, @"dynamicAnimator.referenceView is nil");
    CGPoint anchorPoint = [self.xrayView convertPoint:attachmentBehavior.anchorPoint fromView:referenceView];
    
    CGPoint attachmentPoint = item.center;
    anchorPointA = CGPointApplyAffineTransform(anchorPointA, item.transform);
    attachmentPoint.x += anchorPointA.x;
    attachmentPoint.y += anchorPointA.y;
    attachmentPoint = [self.xrayView convertPoint:attachmentPoint fromView:referenceView];
    
    BOOL isSpring = (attachmentBehavior.frequency > 0.0);
    
    [self.xrayView drawAttachmentFromAnchor:anchorPoint toPoint:attachmentPoint length:attachmentBehavior.length isSpring:isSpring];
}

@end
