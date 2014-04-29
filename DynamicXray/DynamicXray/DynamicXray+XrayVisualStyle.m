//
//  DynamicXray+XrayVisualStyle.m
//  DynamicXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"
#import "DynamicXray_Internal.h"
#import "DXRDynamicXrayView.h"


@implementation DynamicXray (XrayVisualStyle)

#pragma mark - Cross Fade

- (void)setCrossFade:(CGFloat)crossFade
{
    _crossFade = crossFade;
    [self updateDynamicsViewTransparencyLevels];
}

- (CGFloat)crossFade
{
    return _crossFade;
}

- (void)updateDynamicsViewTransparencyLevels
{
    CGFloat xrayViewAlpha = 1.0f;
    UIColor *backgroundColor;

    if (self.crossFade > 0) {
        backgroundColor = [UIColor colorWithWhite:0 alpha:fabsf(self.crossFade)];
    }
    else {
        backgroundColor = [UIColor clearColor];
        xrayViewAlpha = 1.0f + self.crossFade;
    }

    self.xrayViewController.view.alpha = xrayViewAlpha;
    self.xrayWindow.backgroundColor = backgroundColor;
}


#pragma mark - viewOffset

- (void)setViewOffset:(UIOffset)viewOffset
{
    [[self xrayView] setDrawOffset:viewOffset];
}

- (UIOffset)viewOffset
{
    return [[self xrayView] drawOffset];
}


#pragma mark - drawDynamicItemsEnabled

- (void)setDrawDynamicItemsEnabled:(BOOL)drawDynamicItemsEnabled
{
    _drawDynamicItemsEnabled = drawDynamicItemsEnabled;

    if (drawDynamicItemsEnabled) {
        if (self.dynamicItemsToDraw == nil) {
            self.dynamicItemsToDraw = [NSMutableSet set];
        }
    }
    else if (self.dynamicItemsToDraw)
    {
        self.dynamicItemsToDraw = nil;
    }
}

- (BOOL)drawDynamicItemsEnabled
{
    return _drawDynamicItemsEnabled;
}


#pragma mark - allowsAntialiasing

- (void)setAllowsAntialiasing:(BOOL)allowsAntialiasing
{
    [[self xrayView] setAllowsAntialiasing:allowsAntialiasing];
}

- (BOOL)allowsAntialiasing
{
    return [[self xrayView] allowsAntialiasing];
}

@end
