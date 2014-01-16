//
//  DXRBoundaryCollisionBehaviorSnapshot.h
//  DynamicsXray
//
//  Created by Chris Miles on 11/09/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRBehaviorSnapshot.h"
@import UIKit;

@interface DXRBoundaryCollisionBehaviorSnapshot : DXRBehaviorSnapshot

- (id)initWithBoundaryRect:(CGRect)boundaryRect;

@property (assign, nonatomic) CGRect boundaryRect;

@end
