//
//  DXRDynamicsXRayConfigurationViewController+Controls.m
//  DynamicsXRay
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayConfigurationViewController+Controls.h"
#import "DXRDynamicsXRayConfigurationViewController_Internal.h"

#import "DXRDynamicsXRayWindowController.h"


@implementation DXRDynamicsXRayConfigurationViewController (Controls)

#pragma mark - View/Control Creation

- (UIButton *)newDismissButtonWithFrame:(CGRect)frame
{
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = frame;
    dismissButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    return dismissButton;
}

- (UIView *)newControlsViewWithFrame:(CGRect)frame
{
    UIView *containerView = [[UIView alloc] initWithFrame:frame];
    containerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    containerView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.94f];

    UISwitch *activeToggleSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(20.0f, 20.0f, 0, 0)];
    [activeToggleSwitch sizeToFit];
    [activeToggleSwitch setOn:self.dynamicsXRay.isActive];
    [activeToggleSwitch addTarget:self action:@selector(activeToggleAction:) forControlEvents:UIControlEventValueChanged];

    UILabel *activeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    activeLabel.text = @"Active";
    [activeLabel sizeToFit];

    [containerView addSubview:activeToggleSwitch];
    [containerView addSubview:activeLabel];

    activeToggleSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    activeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeToggleSwitch, activeLabel);
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[activeToggleSwitch]-[activeLabel]-(>=20)-|" options:0 metrics:nil views:layoutViews]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[activeToggleSwitch]-(>=20)-|" options:0 metrics:nil views:layoutViews]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:activeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:activeToggleSwitch attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];

    return containerView;
}


#pragma mark - Actions

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
