//
//  DXRDynamicsXRayBehaviorDrawing.h
//  DynamicsXRay
//
//  Created by Chris Miles on 2/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@protocol DXRDynamicsXRayBehaviorDrawing <NSObject>

- (void)drawInContext:(CGContextRef)context;

@end
