//
//  DXRGravityBehaviorSnapshot.m
//  DynamicsXray
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRGravityBehaviorSnapshot.h"

@implementation DXRGravityBehaviorSnapshot

- (id)initWithGravityMagnitude:(CGFloat)magnitude angle:(CGFloat)angle
{
    self = [super init];
    if (self) {
        _magnitude = magnitude;
        _angle = angle;
    }
    return self;
}

@end
