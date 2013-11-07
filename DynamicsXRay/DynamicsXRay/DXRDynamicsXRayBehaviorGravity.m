//
//  DXRDynamicsXRayBehaviorGravity.m
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayBehaviorGravity.h"

@implementation DXRDynamicsXRayBehaviorGravity

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
