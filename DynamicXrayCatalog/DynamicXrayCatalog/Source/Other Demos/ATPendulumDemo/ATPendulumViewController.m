//
//  ATBehaviorsViewController.m
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import "ATPendulumViewController.h"

#import "ATBouncyBehavior.h"
#import "ATPendulumBehavior.h"
#import "ATWindBehavior.h"

#import <DynamicXray/DynamicXray.h>

@interface ATPendulumViewController ()

@property UIDynamicAnimator *animator;
@property ATPendulumBehavior *pendulumBehavior;
@property UIGravityBehavior *gravityBehavior;
@property UIView *greenSquare;
@property UIView *redSquare;

@property (nonatomic) DynamicXray *dynamicXray;

@end

@implementation ATPendulumViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupDynamics];

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *xrayItem = [[UIBarButtonItem alloc] initWithTitle:@"Xray" style:UIBarButtonItemStyleBordered target:self action:@selector(xrayAction:)];
    self.toolbarItems = @[flexibleItem, xrayItem];
}

- (void)setupDynamics
{
    CGPoint anchorPoint = CGPointMake([[self view] center].x, [[self view] center].y);
    [self addDotAtPoint:anchorPoint];
    NSArray *squares = @[[self greenSquare], [self redSquare]];

    [self setPendulumBehavior:[[ATPendulumBehavior alloc] initWithItems:squares attachedToAnchor:anchorPoint]];
    [self setGravityBehavior:[[UIGravityBehavior alloc] initWithItems:squares]];

    [[self animator] addBehavior:[self pendulumBehavior]];
    [[self animator] addBehavior:[self gravityBehavior]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)addDotAtPoint:(CGPoint)point
{
    UIView *dot = [[UIView alloc] initWithFrame:(CGRect){point, {2., 2.}}];
    [dot setBackgroundColor:[UIColor redColor]];
    [[self view] addSubview:dot];
}

#pragma mark - DynamicXray

- (DynamicXray *)dynamicXray
{
    if (_dynamicXray == nil) {
        _dynamicXray = [[DynamicXray alloc] init];
        _dynamicXray.active = NO;

        [self.animator addBehavior:_dynamicXray];
    }

    return _dynamicXray;
}

- (void)xrayAction:(__unused id)sender
{
    [self.dynamicXray presentConfigurationViewController];
}

@end
