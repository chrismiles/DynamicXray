//
//  DXRDynamicsXrayBehaviorBoundaryCollision.h
//  DynamicsXray
//
//  Created by Chris Miles on 11/09/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayBehavior.h"
@import UIKit;

@interface DXRDynamicsXrayBehaviorBoundaryCollision : DXRDynamicsXrayBehavior

- (id)initWithBoundaryRect:(CGRect)boundaryRect;

@property (assign, nonatomic) CGRect boundaryRect;

@end
