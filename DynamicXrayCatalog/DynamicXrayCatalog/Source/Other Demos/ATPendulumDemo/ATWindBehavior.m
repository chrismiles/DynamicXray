//
//  ATWindBehavior.m
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import "ATWindBehavior.h"
#import "ATOscillationItem.h"

@interface ATWindBehavior ()

@property UIPushBehavior *pushBehavior;
@property ATOscillationItem *oscillationItem;

@end

@implementation ATWindBehavior

- (id)initWithItems:(NSArray *)items
{
  self = [super init];
  if (self)
  {
    [self setPushBehavior:[[UIPushBehavior alloc] initWithItems:items mode:UIPushBehaviorModeContinuous]];
    [self addChildBehavior:[self pushBehavior]];

    [self setOscillationItem:[[ATOscillationItem alloc] init]];
    UIDynamicItemBehavior *rotation = [[UIDynamicItemBehavior alloc] initWithItems:@[[self oscillationItem]]];
    [rotation addAngularVelocity:M_PI forItem:[self oscillationItem]];
    [rotation setAngularResistance:0.];
    [rotation setFriction:0.];

    __weak id weakSelf = self;
    [rotation setAction:^{
      __strong id strongSelf = weakSelf;
      CGFloat strength = [[strongSelf oscillationItem] transform].a;
      [[strongSelf pushBehavior] setPushDirection:CGVectorMake(strength, 0.f)];
      [strongSelf setStrength:strength];
    }];

    [self addChildBehavior:rotation];
  }
  return self;
}

@end
