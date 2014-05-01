//
//  ATPendulumBehavior.m
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import "ATPendulumBehavior.h"

@interface ATPendulumBehavior ()

@end

@implementation ATPendulumBehavior

- (id)initWithItems:(NSArray *)items attachedToAnchor:(CGPoint)point
{
  self = [super init];
  if (self)
  {
      [items enumerateObjectsUsingBlock:^(id<UIDynamicItem> item, __unused NSUInteger idx, __unused BOOL *stop) {
          UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:point];
          [self addChildBehavior:attachmentBehavior];
      }];
  }
  return self;
}

@end
