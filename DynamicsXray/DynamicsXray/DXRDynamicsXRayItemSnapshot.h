//
//  DXRDynamicsXrayItemSnapshot.h
//  DynamicsXray
//
//  Created by Chris Miles on 7/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DXRDynamicsXrayItemSnapshot : NSObject

+ (instancetype)snapshotWithBounds:(CGRect)bounds center:(CGPoint)center transform:(CGAffineTransform)transform;

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGAffineTransform transform;

@end
