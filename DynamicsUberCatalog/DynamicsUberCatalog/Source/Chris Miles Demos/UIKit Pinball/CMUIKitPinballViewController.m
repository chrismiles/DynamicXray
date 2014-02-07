//
//  CMUIKitPinballViewController.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 3/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"
#import "CMUIKitPinballViewController_Private.h"
#import "CMUIKitPinballViewController+Edges.h"
#import "CMUIKitPinballViewController+Launcher.h"


static NSString * const LaunchButtonBoundary = @"LaunchButtonBoundary";


@implementation CMUIKitPinballViewController

- (void)awakeFromNib
{
    self.ballsInPlay = [NSMutableArray array];

    self.launcherWidth = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 120.0f : 60.0f);
    self.launchButtonHeight = 60.0f;
    self.launchSpringHeight = 100.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.toolbarHidden = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Xray" style:UIBarButtonItemStyleBordered target:self action:@selector(xrayAction:)];

    [self setupDynamics];
    [self setupEdges];
    [self setupLauncher];

    [self.dynamicsXray setActive:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self addBall];
}

- (void)viewDidLayoutSubviews
{
    [self setupLauncher];
}


#pragma mark - Set Up Dynamics

- (void)setupDynamics
{
    if (self.dynamicAnimator == nil) {
        UIDynamicAnimator *dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
        [dynamicAnimator addBehavior:gravityBehavior];

        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        collisionBehavior.collisionMode = UICollisionBehaviorModeEverything;
        [dynamicAnimator addBehavior:collisionBehavior];

        UIDynamicItemBehavior *launchSpringItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
        launchSpringItemBehavior.allowsRotation = NO;
        [dynamicAnimator addBehavior:launchSpringItemBehavior];

        self.dynamicAnimator = dynamicAnimator;
        self.collisionBehavior = collisionBehavior;
        self.gravityBehavior = gravityBehavior;
        self.launchSpringItemBehavior = launchSpringItemBehavior;
    }
}


#pragma mark - Add "Ball"

- (void)addBall
{
    if (self.ballReadyForLaunch == nil) {
        UISwitch *newBall = [[UISwitch alloc] initWithFrame:CGRectZero];
        [newBall sizeToFit];
        CGSize ballSize = newBall.bounds.size;
        newBall.center = CGPointMake(CGRectGetWidth(self.view.bounds) - self.launcherWidth/2.0f, CGRectGetHeight(self.view.bounds) - ballSize.height/2.0f - self.launchButtonHeight - self.launchSpringHeight - 50.0f);
        [self.view addSubview:newBall];

        self.ballReadyForLaunch = newBall;

        [self.gravityBehavior addItem:newBall];
        [self.collisionBehavior addItem:newBall];
    }
}


#pragma mark - DynamicsXray

- (DynamicsXray *)dynamicsXray
{
    if (_dynamicsXray == nil) {
        _dynamicsXray = [[DynamicsXray alloc] init];
        _dynamicsXray.active = NO;

        [self.dynamicAnimator addBehavior:_dynamicsXray];
    }

    return _dynamicsXray;
}

- (void)xrayAction:(__unused id)sender
{
    [self.dynamicsXray presentConfigurationViewController];
}

@end
