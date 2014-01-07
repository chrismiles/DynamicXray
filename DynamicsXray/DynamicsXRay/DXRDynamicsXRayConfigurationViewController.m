//
//  DXRDynamicsXRayConfigurationViewController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayConfigurationViewController.h"
#import "DXRDynamicsXRayConfigurationViewController_Internal.h"
#import "DXRDynamicsXRayConfigurationViewController+Controls.h"


static CGFloat const ConfigurationControlsContainerHeight = 100.0f;


@implementation DXRDynamicsXRayConfigurationViewController

- (id)initWithDynamicsXRay:(DynamicsXRay *)dynamicsXRay
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXRay = dynamicsXRay;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];

    CGRect bounds = self.view.bounds;

    UIButton *dismissButton = [self newDismissButtonWithFrame:bounds];
    [self.view addSubview:dismissButton];

    UIView *controlsView = [self newControlsViewWithFrame:CGRectMake(0, CGRectGetHeight(bounds) - ConfigurationControlsContainerHeight, CGRectGetWidth(bounds), ConfigurationControlsContainerHeight)];
    [self.view addSubview:controlsView];
}

@end
