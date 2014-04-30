//
//  ATOscillationItem.m
//  Animation Tests
//
//  Created by Peter Hare on 3/07/2013.
//  Copyright (c) 2013 Peter Hare. All rights reserved.
//

#import "ATOscillationItem.h"

@interface ATOscillationItem ()

@property (nonatomic, readwrite) CGRect bounds;
@property CGPoint pin;

@end

@implementation ATOscillationItem

- (id)init;
{
  self = [super init];
  if (self)
  {
    [self setBounds:CGRectMake(0., 0., 2., 2.)];
  }
  return self;
}

@end
