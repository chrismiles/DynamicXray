//
//  DXRDynamicsXrayConfigurationViewController+Controls.m
//  DynamicsXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController+Controls.h"
#import "DXRDynamicsXRayConfigurationViewController_Internal.h"

#import "DXRDynamicsXrayWindowController.h"


@implementation DXRDynamicsXrayConfigurationViewController (Controls)

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

    UIView *faderView = [self faderViewWithFrame:CGRectZero];

    [containerView addSubview:activeToggleSwitch];
    [containerView addSubview:activeLabel];
    [containerView addSubview:faderView];

    activeToggleSwitch.translatesAutoresizingMaskIntoConstraints = NO;
    activeLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *layoutMetrics = @{@"faderViewHeight": @(CGRectGetHeight(faderView.frame))};
    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeToggleSwitch, activeLabel, faderView);

    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[activeToggleSwitch]-[activeLabel]-(==20,>=20@650)-[faderView(>=80,<=200)]-|" options:0 metrics:nil views:layoutViews]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[activeToggleSwitch]-(>=20)-|" options:0 metrics:nil views:layoutViews]];
    [containerView addConstraint:[NSLayoutConstraint constraintWithItem:activeLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:activeToggleSwitch attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0]];
    [containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[faderView(==faderViewHeight)]" options:0 metrics:layoutMetrics views:layoutViews]];

    return containerView;
}

- (UIView *)faderViewWithFrame:(CGRect)frame
{
    CGFloat const margin = 20.0f;

    UISlider *faderSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [faderSlider setValue:(self.dynamicsXRay.crossFade+1.0f)/2.0f];
    [faderSlider addTarget:self action:@selector(faderSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    UILabel *faderAppLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *faderXrayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    faderAppLabel.text = @"App";
    faderXrayLabel.text = @"Xray";

    [faderSlider sizeToFit];
    [faderAppLabel sizeToFit];
    [faderXrayLabel sizeToFit];

    CGFloat viewHeight = margin + CGRectGetHeight(faderSlider.frame) + CGRectGetHeight(faderAppLabel.frame) + margin;
    frame.size.height = viewHeight;

    UIView *faderView = [[UIView alloc] initWithFrame:frame];
    [faderView addSubview:faderSlider];
    [faderView addSubview:faderAppLabel];
    [faderView addSubview:faderXrayLabel];

    faderView.translatesAutoresizingMaskIntoConstraints = NO;
    faderSlider.translatesAutoresizingMaskIntoConstraints = NO;
    faderAppLabel.translatesAutoresizingMaskIntoConstraints = NO;
    faderXrayLabel.translatesAutoresizingMaskIntoConstraints = NO;

    NSDictionary *layoutMetrics = @{@"margin": @(margin)};
    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(faderSlider, faderAppLabel, faderXrayLabel);

    [faderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(margin)-[faderSlider]-(margin)-|" options:0 metrics:layoutMetrics views:layoutViews]];
    [faderView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(margin)-[faderSlider][faderAppLabel]-(margin)-|" options:0 metrics:layoutMetrics views:layoutViews]];

    // Fader labels
    [faderView addConstraint:[NSLayoutConstraint constraintWithItem:faderAppLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:faderSlider attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0]];
    [faderView addConstraint:[NSLayoutConstraint constraintWithItem:faderXrayLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:faderSlider attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
    [faderView addConstraint:[NSLayoutConstraint constraintWithItem:faderXrayLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:faderSlider attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0]];

    return faderView;
}


#pragma mark - Actions

- (void)dismissAction:(__unused id)sender
{
    DXRDynamicsXrayWindowController *xrayWindowController = (DXRDynamicsXrayWindowController *)self.parentViewController;
    [xrayWindowController dismissConfigViewController];
}

- (void)activeToggleAction:(UISwitch *)toggleSwitch
{
    [self.dynamicsXRay setActive:toggleSwitch.on];
}

- (void)faderSliderValueChanged:(UISlider *)slider
{
    CGFloat crossFade = slider.value * 2.0f - 1.0f;
    self.dynamicsXRay.crossFade = crossFade;
}

@end
