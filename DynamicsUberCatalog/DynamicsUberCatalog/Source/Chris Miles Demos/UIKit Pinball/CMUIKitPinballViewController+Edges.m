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

    [self drawEdges];
}

- (void)setupBorderEdges
{
    UIBezierPath *path = [self borderEdgesPath];
    [self.collisionBehavior addBoundaryWithIdentifier:@"Borders" forPath:path];
}

- (UIBezierPath *)borderEdgesPath
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

    return borders;
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
    UIBezierPath *path = [self launcherWallPath];
    [self.collisionBehavior addBoundaryWithIdentifier:@"LauncherWall" forPath:path];
}

- (UIBezierPath *)launcherWallPath
{
    CGRect bounds = self.view.bounds;
    CGSize wallSize = self.launcherWallSize;

    CGFloat minX = CGRectGetWidth(bounds) - self.launcherWidth - wallSize.width;
    CGFloat minY = CGRectGetHeight(bounds) - wallSize.height;

    CGRect boundaryFrame = CGRectMake(minX, minY, wallSize.width, wallSize.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:boundaryFrame];

    return path;
}

- (void)drawEdges
{
    if (self.edgesView == nil) {
        CMUIKitPinballEdgesView *edgesView = [[CMUIKitPinballEdgesView alloc] initWithFrame:self.view.bounds];
        edgesView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        edgesView.backgroundColor = self.view.backgroundColor;
        [self.view addSubview:edgesView];

        self.edgesView = edgesView;
    }

    CGRect bounds = self.view.bounds;
    CGFloat minX = 0;
    CGFloat maxX = CGRectGetMaxX(bounds);
    CGFloat minY = 0;
    CGFloat maxY = CGRectGetMaxY(bounds);

    UIBezierPath *borderEdgesPath = [self borderEdgesPath];
    // close path
    [borderEdgesPath addLineToPoint:CGPointMake(maxX, minY)];
    [borderEdgesPath addLineToPoint:CGPointMake(minX, minY)];
    [borderEdgesPath addLineToPoint:CGPointMake(minX, maxY)];
    [borderEdgesPath closePath];

    UIBezierPath *launcherWallPath = [self launcherWallPath];

    [self.edgesView removeAllPaths];
    [self.edgesView addPath:borderEdgesPath];
    [self.edgesView addPath:launcherWallPath];
}

@end
