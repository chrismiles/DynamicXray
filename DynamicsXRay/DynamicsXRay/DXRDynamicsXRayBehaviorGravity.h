//
//  DXRDynamicsXRayBehaviorGravity.h
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayBehavior.h"
@import CoreGraphics;

@interface DXRDynamicsXRayBehaviorGravity : DXRDynamicsXRayBehavior

- (id)initWithGravityMagnitude:(CGFloat)magnitude angle:(CGFloat)angle;

@property (assign, nonatomic) CGFloat magnitude;
@property (assign, nonatomic) CGFloat angle;

@end
