//
//  CMUIKitPinballViewController.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 3/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//


static NSString * const LaunchButtonBoundary = @"LaunchButtonBoundary";


#import "CMUIKitPinballViewController.h"

@interface CMUIKitPinballViewController ()

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;

@property (strong, nonatomic) NSMutableArray *ballsInPlay;
@property (strong, nonatomic) UIView *ballReadyForLaunch;

@property (assign, nonatomic) CGFloat launcherWidth;
@property (assign, nonatomic) CGFloat launcherHeight;

@property (strong, nonatomic) UIView *launchButton;

@end


@implementation CMUIKitPinballViewController

- (void)awakeFromNib
{
    self.ballsInPlay = [NSMutableArray array];

    self.launcherWidth = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 120.0f : 60.0f);
    self.launcherHeight = 60.0f;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.toolbarHidden = YES;

    [self setupDynamics];
    [self setupLauncher];
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

        self.dynamicAnimator = dynamicAnimator;
        self.collisionBehavior = collisionBehavior;
        self.gravityBehavior = gravityBehavior;
    }
}


#pragma mark - Set Up Launcher

- (void)setupLauncher
{
    if (self.launchButton == nil) {
        CGRect bounds = self.view.bounds;
        CGFloat launchWidth = self.launcherWidth;
        CGFloat buttonHeight = self.launcherHeight;
        UILabel *launchButton = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) - launchWidth, CGRectGetHeight(bounds) - buttonHeight, launchWidth, buttonHeight)];
        launchButton.text = @"LAUNCH";
        launchButton.textColor = [UIColor blackColor];
        launchButton.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        launchButton.textAlignment = NSTextAlignmentCenter;
        launchButton.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);

        [self.view addSubview:launchButton];

        self.launchButton = launchButton;
    }

    [self.collisionBehavior removeBoundaryWithIdentifier:LaunchButtonBoundary];
    UIBezierPath *launchButtonPath = [UIBezierPath bezierPathWithRect:self.launchButton.frame];
    [self.collisionBehavior addBoundaryWithIdentifier:LaunchButtonBoundary forPath:launchButtonPath];
}


#pragma mark - Add "Ball"

- (void)addBall
{
    if (self.ballReadyForLaunch == nil) {
        UISwitch *newBall = [[UISwitch alloc] initWithFrame:CGRectZero];
        [newBall sizeToFit];
        CGSize ballSize = newBall.bounds.size;
        newBall.center = CGPointMake(CGRectGetWidth(self.view.bounds) - self.launcherWidth/2.0f - ballSize.width/2.0f , CGRectGetHeight(self.view.bounds) - ballSize.height/2.0f - self.launcherHeight - 50.0f);
        [self.view addSubview:newBall];

        self.ballReadyForLaunch = newBall;

        [self.gravityBehavior addItem:newBall];
        [self.collisionBehavior addItem:newBall];
    }
}

@end
