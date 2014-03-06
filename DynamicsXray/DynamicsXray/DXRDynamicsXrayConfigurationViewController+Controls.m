//
//  DXRDynamicsXrayConfigurationViewController+Controls.m
//  DynamicsXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController+Controls.h"
#import "DXRDynamicsXrayConfigurationViewController_Internal.h"

#import "DXRDynamicsXrayConfigurationActiveView.h"
#import "DXRDynamicsXrayConfigurationFaderView.h"
#import "DXRDynamicsXrayConfigurationTitleView.h"
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

- (DXRDynamicsXrayConfigurationControlsView *)newControlsViewWithFrame:(CGRect)frame
{
    DXRDynamicsXrayConfigurationControlsView *controlsView = [[DXRDynamicsXrayConfigurationControlsView alloc] initWithFrame:frame];
    controlsView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    controlsView.backgroundColor = [UIColor clearColor];

    controlsView.tintColor = [self controlsTintColor];

    [controlsView.activeView.activeToggleSwitch setOn:self.dynamicsXray.isActive];
    [controlsView.activeView.activeToggleSwitch setOnTintColor:[self controlsTintColor]];
    [controlsView.activeView.activeToggleSwitch addTarget:self action:@selector(activeToggleAction:) forControlEvents:UIControlEventValueChanged];

    [controlsView.faderView.faderSlider setValue:(self.dynamicsXray.crossFade+1.0f)/2.0f];
    [controlsView.faderView.faderSlider addTarget:self action:@selector(faderSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:controlsView];

    return controlsView;
}


#pragma mark - Actions

- (void)dismissAction:(__unused id)sender
{
    DXRDynamicsXrayWindowController *xrayWindowController = (DXRDynamicsXrayWindowController *)self.parentViewController;

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
