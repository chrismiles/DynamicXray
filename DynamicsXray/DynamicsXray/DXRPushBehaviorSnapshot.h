//
//  DXRPushBehaviorSnapshot.h
//  DynamicsXray
//
//  Created by Chris Miles on 21/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRBehaviorSnapshot.h"
@import UIKit;


@interface DXRPushBehaviorSnapshot : DXRBehaviorSnapshot

- (id)initWithAngle:(CGFloat)angle magnitude:(CGFloat)magnitude location:(CGPoint)pushLocation mode:(UIPushBehaviorMode)mode;

@property (assign, nonatomic, readonly) CGFloat angle;
@property (assign, nonatomic, readonly) CGFloat magnitude;
@property (assign, nonatomic, readonly) CGPoint pushLocation;
@property (assign, nonatomic, readonly) UIPushBehaviorMode mode;

@end
