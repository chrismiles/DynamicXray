//
//  DXRCollisionBehaviorSnapshot.h
//  DynamicsXray
//
//  Created by Chris Miles on 5/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRBehaviorSnapshot.h"
@import UIKit;


@interface DXRCollisionBehaviorSnapshot : DXRBehaviorSnapshot

- (id)initWithPath:(UIBezierPath *)path;

@property (strong, nonatomic) UIBezierPath *path;

@end
