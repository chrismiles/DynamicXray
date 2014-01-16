//
//  DXRBoundaryCollisionBehaviorSnapshot.m
//  DynamicsXray
//
//  Created by Chris Miles on 11/09/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRBoundaryCollisionBehaviorSnapshot.h"

@implementation DXRBoundaryCollisionBehaviorSnapshot

- (id)initWithBoundaryRect:(CGRect)boundaryRect
{
    self = [super init];
    if (self) {
        _boundaryRect = boundaryRect;
    }
    return self;
}

@end
