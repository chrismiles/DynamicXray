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
    [self.collisionBehavior removeAllBoundaries];

    [self setupBorderEdges];
    [self setupLauncherBase];
    [self setupLauncherWall];
}

- (void)setupBorderEdges
{
    CGRect bounds = self.view.bounds;
    CGFloat minX = 0;
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat minY = 0;
    CGFloat maxY = CGRectGetMaxY(bounds);
    CGFloat height = CGRectGetHeight(bounds);

    // Left/right/top borders
    CGFloat topCornerRadius = 90.0f;
    UIBezierPath *borders = [UIBezierPath bezierPath];
    [borders moveToPoint:CGPointMake(minX, maxY + height)];
    [borders addLineToPoint:CGPointMake(minX, topCornerRadius)];
    [borders addArcWithCenter:CGPointMake(topCornerRadius, topCornerRadius) radius:topCornerRadius startAngle:M_PI endAngle:M_PI_2*3.0f clockwise:YES];
    [borders addLineToPoint:CGPointMake(maxX - topCornerRadius, minY)];
    [borders addArcWithCenter:CGPointMake(maxX - topCornerRadius, topCornerRadius) radius:topCornerRadius startAngle:M_PI_2*3.0f endAngle:0 clockwise:YES];
    [borders addLineToPoint:CGPointMake(maxX, maxY + height)];

    [self.collisionBehavior addBoundaryWithIdentifier:@"Borders" forPath:borders];
}

- (void)setupLauncherBase
{
    CGRect bounds = self.view.bounds;
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat maxY = CGRectGetMaxY(bounds);

    [self.collisionBehavior addBoundaryWithIdentifier:@"Launcher Base"
                                            fromPoint:CGPointMake(maxX - self.launcherWidth, maxY)
                                              toPoint:CGPointMake(maxX, maxY)];
}

- (void)setupLauncherWall
{
    CGRect bounds = self.view.bounds;
    CGSize wallSize = self.launcherWallSize;

    CGFloat minX = CGRectGetWidth(bounds) - self.launcherWidth - wallSize.width;
    CGFloat minY = CGRectGetHeight(bounds) - wallSize.height;

    CGRect boundaryFrame = CGRectMake(minX, minY, wallSize.width, wallSize.height);
    UIBezierPath *boundaryPath = [UIBezierPath bezierPathWithRect:boundaryFrame];

    [self.collisionBehavior addBoundaryWithIdentifier:@"LauncherWall" forPath:boundaryPath];
}

@end
