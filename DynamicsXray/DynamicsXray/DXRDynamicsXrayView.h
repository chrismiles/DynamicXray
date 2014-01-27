//
//  DXRDynamicsXrayView.h
//  DynamicsXray
//
//  Created by Chris Miles on 4/08/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DXRDynamicsXrayView : UIView

- (void)drawAttachmentFromAnchor:(CGPoint)anchorPoint toPoint:(CGPoint)attachmentPoint length:(CGFloat)length isSpring:(BOOL)isSpring;

- (void)drawBoundsCollisionBoundaryWithRect:(CGRect)boundaryRect;

- (void)drawGravityBehaviorWithMagnitude:(CGFloat)magnitude angle:(CGFloat)angle;

- (void)drawContactPaths:(NSMapTable *)contactedPaths;

- (void)drawSnapWithAnchorPoint:(CGPoint)anchorPoint forItem:(id<UIDynamicItem>)item;

- (void)drawPushWithAngle:(CGFloat)angle magnitude:(CGFloat)magnitude transparency:(CGFloat)transparency atLocation:(CGPoint)pushLocation;

- (void)drawDynamicItems:(NSSet *)dynamicItems contactedItems:(NSMapTable *)contactedItems;


- (CGPoint)convertPoint:(CGPoint)point fromReferenceView:(UIView *)referenceView;


@property (assign, nonatomic) UIOffset drawOffset;

@property (assign, nonatomic) BOOL allowsAntialiasing;

@property (weak, nonatomic) UIView *dynamicsReferenceView;

@end
