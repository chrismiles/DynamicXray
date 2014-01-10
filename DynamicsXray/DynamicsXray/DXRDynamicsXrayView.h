//
//  DXRDynamicsXrayView.h
//  DynamicsXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DXRDynamicsXrayView : UIView

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint length:(CGFloat)length isSpring:(BOOL)isSpring;

- (void)drawBoundsCollisionBoundaryWithRect:(CGRect)boundaryRect;

- (void)drawGravityBehaviorWithMagnitude:(CGFloat)magnitude angle:(CGFloat)angle;

- (void)drawDynamicItems:(NSSet *)dynamicItems contactedItems:(NSHashTable *)contactedItems withReferenceView:(UIView *)referenceView;

- (CGPoint)convertPoint:(CGPoint)point fromReferenceView:(UIView *)referenceView;

@property (assign, nonatomic) UIOffset drawOffset;

@property (assign, nonatomic) BOOL allowsAntialiasing;

@end
