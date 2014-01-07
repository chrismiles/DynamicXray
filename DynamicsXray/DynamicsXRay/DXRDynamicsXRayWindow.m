//
//  DXRDynamicsXRayWindow.m
//  DynamicsXRay
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayWindow.h"

@implementation DXRDynamicsXRayWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    __strong id<DXRDynamicsXRayWindowDelegate> delegate = self.xrayWindowDelegate;
    [delegate dynamicsXRayWindowNeedsToLayoutSubviews:self];
}

@end
