//
//  DXRDynamicsXRayItemBoundaryCollision.m
//  DynamicsXRay
//
//  Created by Chris Miles on 11/09/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayItemBoundaryCollision.h"

@implementation DXRDynamicsXRayItemBoundaryCollision

- (id)initWithBoundaryRect:(CGRect)boundaryRect
{
    self = [super init];
    if (self) {
        _boundaryRect = boundaryRect;
    }
    return self;
}

@end
