//
//  CMUIKitPinballViewController+Edges.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 7/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController+Edges.h"
#import "CMUIKitPinballViewController_Private.h"


@implementation CMUIKitPinballViewController (Edges)

- (void)setupEdges
{
    CGRect bounds = self.view.bounds;

    UIBezierPath *topCornersPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(90.0f, 90.0f)];
    [self.collisionBehavior addBoundaryWithIdentifier:@"Top Corner" forPath:topCornersPath];

}

@end
