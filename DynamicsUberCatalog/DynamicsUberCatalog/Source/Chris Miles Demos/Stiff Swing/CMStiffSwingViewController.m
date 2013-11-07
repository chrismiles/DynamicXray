//
//  CMStiffSwingViewController.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 6/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "CMStiffSwingViewController.h"
#import <DynamicsXRay/DynamicsXRay.h>


@interface CMStiffSwingViewController ()

@property (strong, nonatomic) IBOutlet UIView *swingView;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;

@property (strong, nonatomic) DynamicsXRay *dynamicsXRay;

@end


@implementation CMStiffSwingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializeAnimator];

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *xrayItem = [[UIBarButtonItem alloc] initWithTitle:@"XRay" style:UIBarButtonItemStyleBordered target:self action:@selector(xrayAction:)];
    self.toolbarItems = @[flexibleItem, xrayItem];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)initializeAnimator
{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

    CGRect swingFrame = self.swingView.frame;
    CGPoint attachmentPoint = CGPointMake(CGRectGetWidth(swingFrame)/2.0f, CGRectGetWidth(swingFrame)/2.0f);
    UIOffset attachmentOffset = UIOffsetMake(attachmentPoint.x - CGRectGetWidth(swingFrame)/2.0f, attachmentPoint.y - CGRectGetHeight(swingFrame)/2.0f);
    CGPoint anchorPoint = [self.view convertPoint:attachmentPoint fromView:self.swingView];
    UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self.swingView offsetFromCenter:attachmentOffset attachedToAnchor:anchorPoint];

    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.swingView]];

    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.swingView] mode:UIPushBehaviorModeInstantaneous];

    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[self.swingView]];
    itemBehavior.density = 1.6f;
    itemBehavior.resistance = 1.4f;

    [self.animator addBehavior:attachmentBehavior];
    [self.animator addBehavior:gravityBehavior];
    [self.animator addBehavior:self.pushBehavior];
    [self.animator addBehavior:itemBehavior];

    self.dynamicsXRay = [[DynamicsXRay alloc] init];
    self.dynamicsXRay.drawDynamicItemsEnabled = YES;
    [self.animator addBehavior:self.dynamicsXRay];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self pushSwingWithAngle:(CGFloat)M_PI magnitude:0.5f swingOffset:UIOffsetMake(30.0f, CGRectGetHeight(self.swingView.frame)/2.0f)];
}


#pragma mark - Tap Gesture Recognizer

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.view];
    [self applySwingPushFromPoint:tapPoint];
}


#pragma mark - Push

- (void)applySwingPushFromPoint:(CGPoint)pushPoint
{
    UIView *swingView = self.swingView;

    UIOffset swingOffset = UIOffsetMake(0, CGRectGetHeight(swingView.bounds) / 2.0f);
    CGPoint itemOffsetPoint = CGPointMake(swingOffset.horizontal + CGRectGetWidth(swingView.bounds)/2.0f, swingOffset.vertical + CGRectGetHeight(swingView.bounds)/2.0f);
    CGPoint itemPoint = [self.view convertPoint:itemOffsetPoint fromView:swingView];

    CGFloat xDiff = itemPoint.x - pushPoint.x;
    CGFloat yDiff = itemPoint.y - pushPoint.y;

    CGFloat angle = atan2f(yDiff, xDiff);

    CGFloat distance = sqrtf(xDiff*xDiff + yDiff*yDiff);
    CGFloat maxPushDistance = [self maximumPushDistance];
    CGFloat magnitude = (maxPushDistance - distance) / maxPushDistance;
    if (magnitude <= 0) magnitude = 0.05f;

    [self pushSwingWithAngle:angle magnitude:magnitude swingOffset:swingOffset];
}

- (CGFloat)maximumPushDistance
{
    return CGRectGetWidth(self.view.bounds);
}

- (void)pushSwingWithAngle:(CGFloat)angle magnitude:(CGFloat)magnitude swingOffset:(UIOffset)swingOffset
{
    //DLog(@"angle: %g˚  magnitude: %g  swingOffset: %@", (angle*180.0f/M_PI), magnitude, NSStringFromUIOffset(swingOffset));
    [self.pushBehavior setTargetOffsetFromCenter:swingOffset forItem:self.swingView];
    [self.pushBehavior setAngle:angle magnitude:magnitude];
    [self.pushBehavior setActive:YES];
}


#pragma mark - DynamicsXray

- (BOOL)isDynamicsXRayEnabled
{
    return (self.dynamicsXRay != nil);
}

- (void)setDynamicsXRayEnabled:(BOOL)dynamicsXRayEnabled
{
    if (dynamicsXRayEnabled) {
        if (self.dynamicsXRay == nil) {
            self.dynamicsXRay = [[DynamicsXRay alloc] init];
            self.dynamicsXRay.crossFade = 0;
            [self.animator addBehavior:self.dynamicsXRay];
        }
    }
    else {
        if (self.dynamicsXRay) {
            [self.animator removeBehavior:self.dynamicsXRay];
            self.dynamicsXRay = nil;
        }
    }
}

- (void)xrayAction:(__unused id)sender
{
    [self.dynamicsXRay presentConfigurationViewController];
}

@end
