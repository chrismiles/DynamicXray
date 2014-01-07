//
//  DXRDynamicsXrayBehaviorGravity.h
//  DynamicsXray
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayBehavior.h"
@import CoreGraphics;

@interface DXRDynamicsXrayBehaviorGravity : DXRDynamicsXrayBehavior

- (id)initWithGravityMagnitude:(CGFloat)magnitude angle:(CGFloat)angle;

@property (assign, nonatomic) CGFloat magnitude;
@property (assign, nonatomic) CGFloat angle;

@end
