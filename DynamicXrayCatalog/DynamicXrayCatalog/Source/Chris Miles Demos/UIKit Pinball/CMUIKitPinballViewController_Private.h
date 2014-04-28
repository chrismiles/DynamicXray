//
//  CMUIKitPinballViewController_Private.h
//  DynamicXrayCatalog
//
//  Created by Chris Miles on 7/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"
#import "CMUIKitPinballEdgesView.h"

@interface CMUIKitPinballViewController () <UICollisionBehaviorDelegate>

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;

@property (strong, nonatomic) NSMutableArray *ballsInPlay;
@property (strong, nonatomic) UIView *ballReadyForLaunch;

@property (assign, nonatomic) CGFloat launcherWidth;
@property (assign, nonatomic) CGSize launcherWallSize;
@property (assign, nonatomic) CGFloat launchSpringHeight;
@property (assign, nonatomic) CGFloat launchButtonHeight;

@property (strong, nonatomic) UIView *launchButton;
@property (strong, nonatomic) UIDynamicItemBehavior *launchSpringItemBehavior;

@property (assign, nonatomic) CGFloat flipperAngle;
@property (assign, nonatomic) CGSize flipperSize;
@property (strong, nonatomic) UIView *leftFlipper;
@property (strong, nonatomic) UIView *rightFlipper;
@property (strong, nonatomic) UIAttachmentBehavior *leftFlipperRotationAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *leftFlipperAnchorAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *rightFlipperRotationAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *rightFlipperAnchorAttachment;

@property (strong, nonatomic) UIView *flapView;
@property (strong, nonatomic) UIAttachmentBehavior *flapPivotAttachment;
@property (strong, nonatomic) UICollisionBehavior *flapCollisionBehavior;

@property (strong, nonatomic) CMUIKitPinballEdgesView *edgesView;

@property (strong, nonatomic) NSMutableArray *bumperViews;
@property (strong, nonatomic) NSMutableDictionary *bumperPushBehaviors;

@property (assign, nonatomic) CGSize lastBoundsSize;

@property (strong, nonatomic) DynamicXray *dynamicXray;

- (UIColor *)wallColour;

@end
