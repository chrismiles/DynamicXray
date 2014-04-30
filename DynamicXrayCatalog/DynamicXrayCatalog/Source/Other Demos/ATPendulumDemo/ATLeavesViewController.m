//
//  ATLeavesViewController.m
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import "ATLeavesViewController.h"

#import "ATBouncyBehavior.h"
#import "ATPendulumBehavior.h"
#import "ATWindBehavior.h"

#import <DynamicXray/DynamicXray.h>

@interface ATLeavesViewController ()

@property UIDynamicAnimator *animator;

@property UIView *greenSquare;
@property UIView *redSquare;

@property UIDynamicItemBehavior *squareBehavior;
@property ATBouncyBehavior *bouncyBehavior;
@property ATWindBehavior *windBehavior;

@end
@implementation ATLeavesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setGreenSquare:[[UIView alloc] initWithFrame:CGRectMake([[self view] center].x, [[self view] center].y + 100., 25., 25.)]];
    [[self greenSquare] setBackgroundColor:[UIColor greenColor]];
    [[self view] addSubview:[self greenSquare]];
    [self setRedSquare:[[UIView alloc] initWithFrame:CGRectMake([[self view] center].x, [[self view] center].y + 100., 25., 25.)]];
    [[self redSquare] setBackgroundColor:[UIColor redColor]];
    [[self view] addSubview:[self redSquare]];
    NSArray *squares = @[[self greenSquare], [self redSquare]];

    [self setAnimator:[[UIDynamicAnimator alloc] initWithReferenceView:[self view]]];

    [self setBouncyBehavior:[[ATBouncyBehavior alloc] initWithItems:squares]];
    [self setWindBehavior:[[ATWindBehavior alloc] initWithItems:squares]];
    [self setSquareBehavior:[[UIDynamicItemBehavior alloc] initWithItems:squares]];
    [[self squareBehavior] setAngularResistance:0.5];

    [[self animator] addBehavior:[self bouncyBehavior]];
    [[self animator] addBehavior:[self windBehavior]];
    [[self animator] addBehavior:[self squareBehavior]];

    [[self animator] addBehavior:[[DynamicXray alloc] init]];
}


@end
