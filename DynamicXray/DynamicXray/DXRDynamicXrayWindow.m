//
//  DXRDynamicXrayWindow.m
//  DynamicXray
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayWindow.h"

@implementation DXRDynamicXrayWindow

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
    __strong id<DXRDynamicXrayWindowDelegate> delegate = self.xrayWindowDelegate;
    [delegate dynamicXrayWindowNeedsToLayoutSubviews:self];
}

@end
