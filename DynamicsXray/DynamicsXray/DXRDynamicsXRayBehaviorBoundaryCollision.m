//
//  DXRDynamicsXrayBehaviorBoundaryCollision.m
//  DynamicsXray
//
//  Created by Chris Miles on 11/09/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayBehaviorBoundaryCollision.h"

@implementation DXRDynamicsXrayBehaviorBoundaryCollision

- (id)initWithBoundaryRect:(CGRect)boundaryRect
{
    self = [super init];
    if (self) {
        _boundaryRect = boundaryRect;
    }
    return self;
}

@end
