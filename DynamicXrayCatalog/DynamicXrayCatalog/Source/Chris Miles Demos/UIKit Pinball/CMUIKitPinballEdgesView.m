//
//  CMUIKitPinballEdgesView.m
//  DynamicXrayCatalog
//
//  Created by Chris Miles on 18/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballEdgesView.h"

@interface CMUIKitPinballEdgesView ()

@property (strong, nonatomic) NSMutableArray *paths;

@end


@implementation CMUIKitPinballEdgesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _paths = [NSMutableArray array];
    }
    return self;
}

- (void)removeAllPaths
{
    [self.paths removeAllObjects];

    [self setNeedsDisplay];
}

- (void)addPath:(UIBezierPath *)path
{
    [self.paths addObject:path];

    [self setNeedsDisplay];
}

- (void)drawRect:(__unused CGRect)rect
{
    for (UIBezierPath *path in self.paths) {
        [path stroke];
        [path fill];
    }
}

@end
