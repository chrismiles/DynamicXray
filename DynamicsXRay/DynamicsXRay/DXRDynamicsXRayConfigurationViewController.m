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

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];

    CGRect bounds = self.view.bounds;

    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = bounds;
    dismissButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];

    CGFloat containerHeight = 100.0f;
    CGRect containerFrame = CGRectMake(0, CGRectGetHeight(bounds) - containerHeight, CGRectGetWidth(bounds), containerHeight);
    UIView *containerView = [[UIView alloc] initWithFrame:containerFrame];
    containerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    containerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    [self.view addSubview:containerView];

    UISwitch *activeToggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 0, 0)];
    [activeToggleSwitch sizeToFit];
    [activeToggleSwitch setOn:self.dynamicsXRay.isActive];
    [activeToggleSwitch addTarget:self action:@selector(activeToggleAction:) forControlEvents:UIControlEventValueChanged];
    [containerView addSubview:activeToggleSwitch];
}

- (void)dismissAction:(__unused id)sender
{
    DXRDynamicsXRayWindowController *xrayWindowController = (DXRDynamicsXRayWindowController *)self.parentViewController;
    [xrayWindowController dismissConfigViewController];
}

- (void)activeToggleAction:(UISwitch *)toggleSwitch
{
    [self.dynamicsXRay setActive:toggleSwitch.on];
}

@end
