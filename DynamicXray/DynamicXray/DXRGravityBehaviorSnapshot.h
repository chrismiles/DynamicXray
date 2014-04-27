//
//  DXRGravityBehaviorSnapshot.h
//  DynamicsXray
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRBehaviorSnapshot.h"
@import CoreGraphics;

@interface DXRGravityBehaviorSnapshot : DXRBehaviorSnapshot

- (id)initWithGravityMagnitude:(CGFloat)magnitude angle:(CGFloat)angle;

@property (assign, nonatomic) CGFloat magnitude;
@property (assign, nonatomic) CGFloat angle;

@end
