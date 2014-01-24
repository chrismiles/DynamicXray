//
//  DXRPushBehaviorSnapshot.m
//  DynamicsXray
//
//  Created by Chris Miles on 21/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRPushBehaviorSnapshot.h"


@interface DXRPushBehaviorSnapshot ()

@property (assign, nonatomic) CGFloat angle;
@property (assign, nonatomic) CGFloat magnitude;
@property (assign, nonatomic) CGPoint pushLocation;

@end


@implementation DXRPushBehaviorSnapshot

- (id)initWithAngle:(CGFloat)angle magnitude:(CGFloat)magnitude location:(CGPoint)pushLocation
{
    self = [super init];
    if (self) {
        _angle = angle;
        _magnitude = magnitude;
        _pushLocation = pushLocation;
    }
    return self;
}

@end
