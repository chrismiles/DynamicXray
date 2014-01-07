//
//  DXRDynamicsXrayViewController.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayViewController.h"
#import "DXRDynamicsXrayView.h"


@implementation DXRDynamicsXrayViewController

- (id)initDynamicsXray:(DynamicsXray *)dynamicsXray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXray = dynamicsXray;
    }
    return self;
}

- (void)loadView
{
    self.view = [[DXRDynamicsXrayView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 568.0f)];
    self.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
}

- (DXRDynamicsXrayView *)xrayView
{
    return (DXRDynamicsXrayView *)self.view;
}

@end
