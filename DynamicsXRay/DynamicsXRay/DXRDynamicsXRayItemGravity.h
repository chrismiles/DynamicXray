//
//  DXRDynamicsXRayItemGravity.h
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayItem.h"
@import CoreGraphics;

@interface DXRDynamicsXRayItemGravity : DXRDynamicsXRayItem

- (id)initWithGravityMagnitude:(CGFloat)magnitude angle:(CGFloat)angle;

@property (assign, nonatomic) CGFloat magnitude;
@property (assign, nonatomic) CGFloat angle;

@end
