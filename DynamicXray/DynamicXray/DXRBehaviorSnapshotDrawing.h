//
//  DXRBehaviorSnapshotDrawing.h
//  DynamicsXray
//
//  Created by Chris Miles on 2/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

@import Foundation;
@import CoreGraphics;

@protocol DXRBehaviorSnapshotDrawing <NSObject>

- (void)drawInContext:(CGContextRef)context;

@end
