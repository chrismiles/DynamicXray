//
//  DXRDynamicsXRayItemSnapshot.m
//  DynamicsXRay
//
//  Created by Chris Miles on 7/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayItemSnapshot.h"

@interface DXRDynamicsXRayItemSnapshot ()

@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readwrite) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;

@end


@implementation DXRDynamicsXRayItemSnapshot

+ (instancetype)snapshotWithBounds:(CGRect)bounds center:(CGPoint)center transform:(CGAffineTransform)transform
{
    DXRDynamicsXRayItemSnapshot *snapshot = [[self alloc] init];
    snapshot.center = center;
    snapshot.bounds = bounds;
    snapshot.transform = transform;

    return snapshot;
}

@end
