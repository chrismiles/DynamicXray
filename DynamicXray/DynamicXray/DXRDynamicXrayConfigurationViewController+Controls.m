//
//  DXRDynamicXrayConfigurationViewController+Controls.m
//  DynamicsXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayConfigurationViewController+Controls.h"
#import "DXRDynamicXrayConfigurationViewController_Internal.h"

#import "DXRDynamicsXrayConfigurationActiveView.h"
#import "DXRDynamicsXrayConfigurationFaderView.h"
#import "DXRDynamicsXrayConfigurationTitleView.h"
#import "DXRDynamicXrayWindowController.h"


@implementation DXRDynamicXrayConfigurationViewController (Controls)

#pragma mark - View/Control Creation

- (UIButton *)newDismissButtonWithFrame:(CGRect)frame
{
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = frame;
    dismissButton.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    [dismissButton addTarget:self action:@selector(dismissAction:) forControlEvents:UIControlEventTouchUpInside];
    return dismissButton;
}

- (void)setupControlsView
{
    [self setupControlsViewWithInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)setupControlsViewWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    DXRDynamicsXrayConfigurationControlsLayoutStyle layoutStyle;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone && UIInterfaceOrientationIsPortrait(interfaceOrientation))
    {
        layoutStyle = DXRDynamicsXrayConfigurationControlsLayoutStyleNarrow;
    }
    else
    {
        layoutStyle = DXRDynamicsXrayConfigurationControlsLayoutStyleWide;
    }

    DXRDynamicsXrayConfigurationControlsView *controlsView = [[DXRDynamicsXrayConfigurationControlsView alloc] initWithLayoutStyle:layoutStyle];
    controlsView.translatesAutoresizingMaskIntoConstraints = NO;
    controlsView.backgroundColor = [UIColor clearColor];

    controlsView.tintColor = [self controlsTintColor];

    [controlsView.activeView.activeToggleSwitch setOn:self.dynamicsXray.isActive];
    [controlsView.activeView.activeToggleSwitch setOnTintColor:[self controlsTintColor]];
    [controlsView.activeView.activeToggleSwitch addTarget:self action:@selector(activeToggleAction:) forControlEvents:UIControlEventValueChanged];

    [controlsView.faderView.faderSlider setValue:(self.dynamicsXray.crossFade+1.0f)/2.0f];
    [controlsView.faderView.faderSlider addTarget:self action:@selector(faderSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:controlsView];

    // Contraints

    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(controlsView);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[controlsView]|" options:0 metrics:nil views:layoutViews]];

    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:controlsView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:controlsView.superview attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
    [self.view addConstraint:bottomConstraint];
    self.controlsBottomLayoutConstraint = bottomConstraint;

    self.controlsView = controlsView;
}


#pragma mark - Actions

- (void)dismissAction:(__unused id)sender
{
    DXRDynamicXrayWindowController *xrayWindowController = (DXRDynamicXrayWindowController *)self.parentViewController;

    void ((^completion)(void)) = ^{
        [xrayWindowController dismissConfigViewController];
    };

    if (self.animateAppearance) {
        [self transitionOutAnimatedWithCompletion:completion];
    }
    else {
        completion();
    }
}

- (void)activeToggleAction:(UISwitch *)toggleSwitch
{
    [self.dynamicsXray setActive:toggleSwitch.on];
}

- (void)faderSliderValueChanged:(UISlider *)slider
{
    CGFloat crossFade = slider.value * 2.0f - 1.0f;
    self.dynamicsXray.crossFade = crossFade;
}

- (UIColor *)controlsTintColor
{
    return [UIColor colorWithRed:0 green:0.639216f blue:0.85098f alpha:1.0f];
}

@end
