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
    
    NSArray *behaviors = dynamicAnimator.behaviors;
    for (UIDynamicBehavior *behavior in behaviors) {
	if ([behavior isKindOfClass:[UIAttachmentBehavior class]]) {
	    [self visualiseAttachmentBehavior:(UIAttachmentBehavior *)behavior];
	}
    }
    
}

- (void)visualiseAttachmentBehavior:(UIAttachmentBehavior *)attachmentBehavior
{
    //[attachmentBehavior CMObjectIntrospectionDumpInfo]; // Only needed during development
    
    //id anchorPoint = [attachmentBehavior valueForKey:@"anchorPoint"];
    NSValue *anchorPointAValue = [attachmentBehavior valueForKey:@"anchorPointA"];
    //id anchorPointB = [attachmentBehavior valueForKey:@"anchorPointB"];
    
    CGPoint anchorPointA = CGPointZero;
    if (anchorPointAValue) anchorPointA = [anchorPointAValue CGPointValue];
    
    // TODO: support attachments from item to item
    
    id<UIDynamicItem> item = attachmentBehavior.items[0];
    
    CGPoint anchorPoint = [self.xrayView convertPoint:attachmentBehavior.anchorPoint fromView:self.dynamicAnimator.referenceView];
    
    CGPoint attachmentPoint = item.center;
    anchorPointA = CGPointApplyAffineTransform(anchorPointA, item.transform);
    attachmentPoint.x += anchorPointA.x;
    attachmentPoint.y += anchorPointA.y;
    attachmentPoint = [self.xrayView convertPoint:attachmentPoint fromView:self.dynamicAnimator.referenceView];
    
    BOOL isSpring = (attachmentBehavior.frequency > 0.0);
    
    [self.xrayView drawAttachmentFromAnchor:anchorPoint toPoint:attachmentPoint length:attachmentBehavior.length isSpring:isSpring];
}

@end
