//
//  DXRSnapBehaviorSnapshot.h
//  DynamicXray
//
//  Created by Chris Miles on 17/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRBehaviorSnapshot.h"
@import UIKit;

@interface DXRSnapBehaviorSnapshot : DXRBehaviorSnapshot

- (id)initWithAnchorPoint:(CGPoint)anchorPoint itemCenter:(CGPoint)itemCenter itemBounds:(CGRect)itemBounds itemTransform:(CGAffineTransform)itemTransform;

@property (assign, nonatomic, readonly) CGPoint anchorPoint;
@property (assign, nonatomic, readonly) CGPoint itemCenter;
@property (assign, nonatomic, readonly) CGRect itemBounds;
@property (assign, nonatomic, readonly) CGAffineTransform itemTransform;

@end
