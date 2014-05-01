//
//  ATBouncyFallBehavior.m
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import "ATBouncyBehavior.h"

@implementation ATBouncyBehavior

- (id)initWithItems:(NSArray *)items
{
  self = [super init];
  if (self)
  {
    UICollisionBehavior *c = [[UICollisionBehavior alloc] initWithItems:items];
    [c setTranslatesReferenceBoundsIntoBoundary:YES];

    UIDynamicItemBehavior *elastic = [[UIDynamicItemBehavior alloc] initWithItems:items];
    [elastic setElasticity:0.8];

    [self addChildBehavior:elastic];
    [self addChildBehavior:c];
  }
  return self;
}

@end
