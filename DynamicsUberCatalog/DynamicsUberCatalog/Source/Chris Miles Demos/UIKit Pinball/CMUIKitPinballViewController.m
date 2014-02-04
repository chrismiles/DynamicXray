//
//  CMUIKitPinballViewController.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 3/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController.h"
#import <DynamicsXray/DynamicsXray.h>

static NSString * const LaunchButtonBoundary = @"LaunchButtonBoundary";


@interface CMUIKitPinballViewController ()

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;

@property (strong, nonatomic) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;

@property (strong, nonatomic) NSMutableArray *ballsInPlay;
@property (strong, nonatomic) UIView *ballReadyForLaunch;

@property (assign, nonatomic) CGFloat launcherWidth;
@property (assign, nonatomic) CGFloat launchSpringHeight;
@property (assign, nonatomic) CGFloat launchButtonHeight;

@property (strong, nonatomic) UIView *launchButton;
@property (strong, nonatomic) UIView *launchSpringView;
@property (strong, nonatomic) UIDynamicItemBehavior *launchSpringItemBehavior;

@property (strong, nonatomic) DynamicsXray *dynamicsXray;

@end


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


#pragma mark - Set Up Launcher

- (void)setupLauncher
{
    [self setupLaunchButton];
    [self setupLaunchSpring];
}

- (void)setupLaunchButton
{
    if (self.launchButton == nil) {
        CGRect bounds = self.view.bounds;
        CGFloat launcherWidth = self.launcherWidth;
        CGFloat buttonHeight = self.launchButtonHeight;

        UILabel *launchButton = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) - launcherWidth, CGRectGetHeight(bounds) - buttonHeight, launcherWidth, buttonHeight)];
        launchButton.text = @"LAUNCH";
        launchButton.textColor = [UIColor blackColor];
        launchButton.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        launchButton.textAlignment = NSTextAlignmentCenter;
        launchButton.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);

        [self.view addSubview:launchButton];

        self.launchButton = launchButton;
    }

//    [self.collisionBehavior removeBoundaryWithIdentifier:LaunchButtonBoundary];
//    UIBezierPath *launchButtonPath = [UIBezierPath bezierPathWithRect:self.launchButton.frame];
//    [self.collisionBehavior addBoundaryWithIdentifier:LaunchButtonBoundary forPath:launchButtonPath];
}

- (void)setupLaunchSpring
{
    if (self.launchSpringView == nil) {
        UIView *launchSpringView = [[UIView alloc] initWithFrame:CGRectZero];
        launchSpringView.backgroundColor = [UIColor darkGrayColor];

        [self.view addSubview:launchSpringView];

        self.launchSpringView = launchSpringView;
    }

    [self.collisionBehavior removeItem:self.launchSpringView];
    [self.launchSpringItemBehavior removeItem:self.launchSpringView];

    CGRect bounds = self.view.bounds;
    CGFloat launcherWidth = self.launcherWidth;
    CGFloat launchSpringHeight = self.launchSpringHeight;
    CGFloat launchButtonHeight = self.launchButtonHeight;

    CGRect frame = CGRectMake(CGRectGetWidth(bounds) - launcherWidth + 1.0f, CGRectGetHeight(bounds) - launchButtonHeight - launchSpringHeight, launcherWidth-2.0f, launchSpringHeight);
    self.launchSpringView.frame = frame;

    [self.collisionBehavior addItem:self.launchSpringView];
    [self.launchSpringItemBehavior addItem:self.launchSpringView];
}


#pragma mark - Add "Ball"

- (void)addBall
{
    if (self.ballReadyForLaunch == nil) {
        UISwitch *newBall = [[UISwitch alloc] initWithFrame:CGRectZero];
        [newBall sizeToFit];
        CGSize ballSize = newBall.bounds.size;
        newBall.center = CGPointMake(CGRectGetWidth(self.view.bounds) - self.launcherWidth/2.0f - ballSize.width/2.0f , CGRectGetHeight(self.view.bounds) - ballSize.height/2.0f - self.launchButtonHeight - self.launchSpringHeight - 50.0f);
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
