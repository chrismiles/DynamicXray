//
//  DXRDynamicsXRayViewController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayViewController.h"
#import "DXRDynamicsXRayView.h"


@implementation DXRDynamicsXRayViewController

- (id)initDynamicsXray:(DynamicsXRay *)dynamicsXray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXray = dynamicsXray;
    }
    return self;
}

- (void)loadView
{
    self.view = [[DXRDynamicsXRayView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 568.0f)];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (DXRDynamicsXRayView *)xrayView
{
    return (DXRDynamicsXRayView *)self.view;
}

@end
