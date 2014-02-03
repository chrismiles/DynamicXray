//
//  CMUIKitPinballViewController.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 3/02/2014.
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

@end


@implementation CMUIKitPinballViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _ballsInPlay = [NSMutableArray array];

        _launcherWidth = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad ? 120.0f : 60.0f);
    }
    return self;
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self addBall];
}

- (void)viewDidLayoutSubviews
{

    [self setupDynamics];

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


- (void)addBall
{
    if (self.ballReadyForLaunch == nil) {
        UISwitch *newBall = [[UISwitch alloc] initWithFrame:CGRectZero];
        [newBall sizeToFit];
        CGSize ballSize = newBall.bounds.size;
        newBall.center = CGPointMake(CGRectGetWidth(self.view.bounds) - ballSize.width/2.0f - 5.0f, CGRectGetHeight(self.view.bounds) - ballSize.height/2.0f - 50.0f);
        [self.view addSubview:newBall];

        self.ballReadyForLaunch = newBall;

        [self.gravityBehavior addItem:newBall];
        [self.collisionBehavior addItem:newBall];
    }
}

@end
