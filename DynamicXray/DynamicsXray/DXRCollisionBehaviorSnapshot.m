//
//  DXRCollisionBehaviorSnapshot.m
//  DynamicsXray
//
//  Created by Chris Miles on 5/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRCollisionBehaviorSnapshot.h"

@implementation DXRCollisionBehaviorSnapshot

- (id)initWithPath:(UIBezierPath *)path
{
    self = [super init];
    if (self) {
        _path = path;
    }
    return self;
}

@end
