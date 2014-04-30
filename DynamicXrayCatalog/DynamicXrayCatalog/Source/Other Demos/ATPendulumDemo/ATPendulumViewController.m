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

@interface ATPendulumViewController ()

@property UIDynamicAnimator *animator;
@property ATPendulumBehavior *pendulumBehavior;
@property UIGravityBehavior *gravityBehavior;
@property UIView *greenSquare;
@property UIView *redSquare;

@end

@implementation ATPendulumViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  CGPoint anchorPoint = CGPointMake([[self view] center].x, [[self view] center].y);
  [self addDotAtPoint:anchorPoint];
  NSArray *squares = @[[self greenSquare], [self redSquare]];

  [self setPendulumBehavior:[[ATPendulumBehavior alloc] initWithItems:squares attachedToAnchor:anchorPoint]];
  [self setGravityBehavior:[[UIGravityBehavior alloc] initWithItems:squares]];

  [[self animator] addBehavior:[self pendulumBehavior]];
  [[self animator] addBehavior:[self gravityBehavior]];
}

- (void)addDotAtPoint:(CGPoint)point;
{
  UIView *dot = [[UIView alloc] initWithFrame:(CGRect){point, 2., 2.}];
  [dot setBackgroundColor:[UIColor redColor]];
  [[self view] addSubview:dot];
}

@end
