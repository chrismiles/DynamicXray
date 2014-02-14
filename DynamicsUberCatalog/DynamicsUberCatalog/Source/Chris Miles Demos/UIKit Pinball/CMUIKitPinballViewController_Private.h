//
//  CMUIKitPinballViewController_Private.h
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 7/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"

@interface CMUIKitPinballViewController ()

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
@property (strong, nonatomic) UIView *launchSpringView;
@property (strong, nonatomic) UIDynamicItemBehavior *launchSpringItemBehavior;

@property (strong, nonatomic) UIView *leftFlipper;
@property (strong, nonatomic) UIView *rightFlipper;
@property (assign, nonatomic) CGFloat flipperAngle;
@property (assign, nonatomic) CGSize flipperSize;
@property (strong, nonatomic) UIAttachmentBehavior *leftFlipperRotationAttachment;
@property (strong, nonatomic) UIAttachmentBehavior *leftFlipperAnchorAttachment;

@property (assign, nonatomic) CGSize viewSize;

@property (strong, nonatomic) DynamicsXray *dynamicsXray;

@end
