//
//  DXRDynamicsXrayItemSnapshot.m
//  DynamicsXray
//
//  Created by Chris Miles on 7/11/2013.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayItemSnapshot.h"

@interface DXRDynamicsXrayItemSnapshot ()

@property (nonatomic, readwrite) CGPoint center;
@property (nonatomic, readwrite) CGRect bounds;
@property (nonatomic, readwrite) CGAffineTransform transform;
@property (nonatomic, readwrite) BOOL isContacted;

@end


@implementation DXRDynamicsXrayItemSnapshot

+ (instancetype)snapshotWithBounds:(CGRect)bounds center:(CGPoint)center transform:(CGAffineTransform)transform contacted:(BOOL)isContacted
{
    DXRDynamicsXrayItemSnapshot *snapshot = [[self alloc] init];
    snapshot.center = center;
    snapshot.bounds = bounds;
    snapshot.transform = transform;
    snapshot.isContacted = isContacted;

    return snapshot;
}

@end
