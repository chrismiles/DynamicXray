//
//  DXRDynamicXrayItemSnapshot.h
//  DynamicsXray
//
//  Created by Chris Miles on 7/11/2013.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

@import UIKit;

@interface DXRDynamicXrayItemSnapshot : NSObject

+ (instancetype)snapshotWithBounds:(CGRect)bounds center:(CGPoint)center transform:(CGAffineTransform)transform contacted:(BOOL)isContacted;

@property (nonatomic, readonly) CGPoint center;
@property (nonatomic, readonly) CGRect bounds;
@property (nonatomic, readonly) CGAffineTransform transform;
@property (nonatomic, readonly) BOOL isContacted;

@property (nonatomic, assign) CGFloat contactedAlpha;

@end
