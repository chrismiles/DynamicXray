//
//  DXRDynamicsXRayConfigurationViewController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayConfigurationViewController.h"
#import "DynamicsXRay.h"
#import "DXRDynamicsXRayWindowController.h"


@interface DXRDynamicsXRayConfigurationViewController ()

@property (weak, nonatomic) DynamicsXRay *dynamicsXRay;

@end


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

    self.view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8f];

    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = self.view.bounds;
    dismissButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];
}

- (void)dismissAction:(__unused id)sender
{
    DXRDynamicsXRayWindowController *xrayWindowController = (DXRDynamicsXRayWindowController *)self.parentViewController;
    [xrayWindowController dismissConfigViewController];
}

@end
