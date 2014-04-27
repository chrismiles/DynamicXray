//
//  DXRDynamicsXrayWindow.m
//  DynamicsXray
//
//  Created by Chris Miles on 12/11/2013.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayWindow.h"

@implementation DXRDynamicsXrayWindow

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
    __strong id<DXRDynamicsXrayWindowDelegate> delegate = self.xrayWindowDelegate;
    [delegate dynamicsXrayWindowNeedsToLayoutSubviews:self];
}

@end
