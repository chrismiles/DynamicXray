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
#import "CMUIKitPinballViewController+Flippers.h"
#import "CMUIKitPinballViewController+Launcher.h"


static NSString * const LaunchButtonBoundary = @"LaunchButtonBoundary";


@implementation CMUIKitPinballViewController

- (void)awakeFromNib
{
    self.ballsInPlay = [NSMutableArray array];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.toolbarHidden = YES;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Xray" style:UIBarButtonItemStyleBordered target:self action:@selector(xrayAction:)];

    [self configureSizesWithViewBounds:self.view.bounds];

    [self setupDynamics];
    [self setupEdges];
    [self setupLauncher];
    [self setupFlippers];
    [self setupFlipperButtons];

    [self.dynamicsXray setActive:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self addBall];
}

- (void)viewDidLayoutSubviews
{
    CGSize viewSize = self.view.bounds.size;
    if (CGSizeEqualToSize(viewSize, self.viewSize) == NO) {
        self.viewSize = viewSize;

        [self configureSizesWithViewBounds:self.view.bounds];

        [self setupEdges];
        [self setupLauncher];
        [self layoutFlippers];
    }
}

- (void)configureSizesWithViewBounds:(CGRect)bounds
{
    self.launcherWidth = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 120.0f : 60.0f);
    self.launchButtonHeight = 60.0f;
    self.launchSpringHeight = 100.0f;
    self.flipperSize = CGSizeMake(100.0f, 30.0f);
    self.flipperAngle = 25.0f * M_PI / 180.0f;

    self.launcherWallSize = CGSizeMake(4.0f, CGRectGetHeight(bounds) * 0.7f);
}


#pragma mark - Set Up Dynamics

- (void)setupDynamics
{
    if (self.dynamicAnimator == nil) {
        __weak CMUIKitPinballViewController *weakSelf = self;

        UIDynamicAnimator *dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];

        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[]];
        gravityBehavior.action = ^{
            __strong CMUIKitPinballViewController *strongSelf = weakSelf;
            [strongSelf checkLostBalls];
        };
        [dynamicAnimator addBehavior:gravityBehavior];

        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[]];
        //collisionBehavior.collisionDelegate = self;
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

        [self.gravityBehavior addItem:newBall];
        [self.collisionBehavior addItem:newBall];

        self.ballReadyForLaunch = newBall;
        [self.ballsInPlay addObject:newBall];
    }
}

- (void)removeBall:(UIView *)ball
{
    [ball removeFromSuperview];

    [self.gravityBehavior removeItem:ball];
    [self.collisionBehavior removeItem:ball];

    [self.ballsInPlay removeObject:ball];
    if (self.ballReadyForLaunch == ball) self.ballReadyForLaunch = nil;
}

- (void)checkLostBalls
{
    CGRect bounds = self.view.bounds;

    for (UIView *ball in [self.ballsInPlay copy]) {
        CGRect frame = ball.frame;
        if (CGRectIntersectsRect(frame, bounds) == NO) {
            [self removeBall:ball];
        }
    }

    if ([self.ballsInPlay count] == 0) {
        [self addBall];
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


//#pragma mark - UICollisionBehaviorDelegate
//
//- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p
//{
//    DLog(@"%@ item: %@ identifier: %@", behavior, item, identifier);
//}

@end
