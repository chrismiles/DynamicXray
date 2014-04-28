//
//  DXRDynamicXrayViewController.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayViewController.h"
#import "DXRDynamicXrayView.h"


@implementation DXRDynamicXrayViewController

- (id)initDynamicsXray:(DynamicXray *)dynamicsXray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXray = dynamicsXray;
    }
    return self;
}

- (void)loadView
{
    self.view = [[DXRDynamicXrayView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 568.0f)];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (DXRDynamicXrayView *)xrayView
{
    return (DXRDynamicXrayView *)self.view;
}

@end
