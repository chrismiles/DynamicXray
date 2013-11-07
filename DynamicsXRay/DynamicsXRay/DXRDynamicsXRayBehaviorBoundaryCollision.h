//
//  DXRDynamicsXRayBehaviorBoundaryCollision.h
//  DynamicsXRay
//
//  Created by Chris Miles on 11/09/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayBehavior.h"
@import UIKit;

@interface DXRDynamicsXRayBehaviorBoundaryCollision : DXRDynamicsXRayBehavior

- (id)initWithBoundaryRect:(CGRect)boundaryRect;

@property (assign, nonatomic) CGRect boundaryRect;

@end
