//
//  DXRSnapBehaviorSnapshot.m
//  DynamicXray
//
//  Created by Chris Miles on 17/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRSnapBehaviorSnapshot.h"

@interface DXRSnapBehaviorSnapshot ()

@property (assign, nonatomic) CGPoint anchorPoint;
@property (assign, nonatomic) CGPoint itemCenter;
@property (assign, nonatomic) CGRect itemBounds;
@property (assign, nonatomic) CGAffineTransform itemTransform;

@end


@implementation DXRSnapBehaviorSnapshot

- (id)initWithAnchorPoint:(CGPoint)anchorPoint itemCenter:(CGPoint)itemCenter itemBounds:(CGRect)itemBounds itemTransform:(CGAffineTransform)itemTransform
{
    self = [super init];
    if (self) {
        _anchorPoint = anchorPoint;
        _itemCenter = itemCenter;
        _itemBounds = itemBounds;
        _itemTransform = itemTransform;
    }
    return self;
}

@end
