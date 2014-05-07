//
//  CMUIKitPinballViewController+Edges.m
//  DynamicXrayCatalog
//
//  Created by Chris Miles on 7/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "CMUIKitPinballViewController+Edges.h"
#import "CMUIKitPinballViewController+Configuration.h"
#import "CMUIKitPinballViewController_Private.h"


static NSString *const CMUIKitPinballEdgeBoundaryIdentifierBorders = @"Borders";
static NSString *const CMUIKitPinballEdgeBoundaryIdentifierLauncherBase = @"Launcher Base";
static NSString *const CMUIKitPinballEdgeBoundaryIdentifierLauncherWall = @"LauncherWall";


@implementation CMUIKitPinballViewController (Edges)

- (void)setupEdges
{
    [self.collisionBehavior removeBoundaryWithIdentifier:CMUIKitPinballEdgeBoundaryIdentifierBorders];
    [self.collisionBehavior removeBoundaryWithIdentifier:CMUIKitPinballEdgeBoundaryIdentifierLauncherBase];
    [self.collisionBehavior removeBoundaryWithIdentifier:CMUIKitPinballEdgeBoundaryIdentifierLauncherWall];

    [self setupBorderEdges];
    [self setupLauncherBase];
    [self setupLauncherWall];

    [self drawEdges];
}

- (void)setupBorderEdges
{
    UIBezierPath *path = [self borderEdgesPath];
    [self.collisionBehavior addBoundaryWithIdentifier:CMUIKitPinballEdgeBoundaryIdentifierBorders forPath:path];
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
    CGFloat topCornerRadius = ConfigValueForIdiom(CMUIKitPinballTopEdgeCornerRadiusPad, CMUIKitPinballTopEdgeCornerRadiusPhone);
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

    [self.collisionBehavior addBoundaryWithIdentifier:CMUIKitPinballEdgeBoundaryIdentifierLauncherBase
                                            fromPoint:CGPointMake(maxX - self.launcherWidth, maxY)
                                              toPoint:CGPointMake(maxX, maxY)];
}

- (void)setupLauncherWall
{
    UIBezierPath *path = [self launcherWallPath];
    [self.collisionBehavior addBoundaryWithIdentifier:CMUIKitPinballEdgeBoundaryIdentifierLauncherWall forPath:path];
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
