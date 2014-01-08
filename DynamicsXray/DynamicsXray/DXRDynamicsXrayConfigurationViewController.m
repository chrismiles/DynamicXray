//
//  DXRDynamicsXrayConfigurationViewController.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController.h"
#import "DXRDynamicsXrayConfigurationViewController_Internal.h"
#import "DXRDynamicsXrayConfigurationViewController+Private.h"
#import "DXRDynamicsXrayConfigurationViewController+Controls.h"


static CGFloat const ConfigurationControlsContainerHeight = 100.0f;


@implementation DXRDynamicsXrayConfigurationViewController

- (id)initWithDynamicsXray:(DynamicsXray *)dynamicsXray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXray = dynamicsXray;
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

    self.controlsView = [self newControlsViewWithFrame:CGRectMake(0, CGRectGetHeight(bounds) - ConfigurationControlsContainerHeight, CGRectGetWidth(bounds), ConfigurationControlsContainerHeight)];
    [self.view addSubview:self.controlsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.animateAppearance && self.initialAppearanceWasAnimated == NO) {
        // Hide views, preparing to animate in
        self.view.backgroundColor = [UIColor clearColor];

        CGRect controlsFrame = self.controlsView.frame;
        controlsFrame.origin.y = CGRectGetHeight(self.view.bounds);
        self.controlsView.frame = controlsFrame;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (self.animateAppearance && self.initialAppearanceWasAnimated == NO) {
        self.initialAppearanceWasAnimated = YES;
        [self transitionInAnimatedWithCompletion:NULL];
    }
}


#pragma mark - Transition Animations

- (void)transitionInAnimatedWithCompletion:(void (^)(void))completion
{
    CGRect controlsFrame = self.controlsView.frame;
    controlsFrame.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(controlsFrame);

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:0 animations:^{

        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];

        self.controlsView.frame = controlsFrame;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)transitionOutAnimatedWithCompletion:(void (^)(void))completion
{
    CGRect controlsFrame = self.controlsView.frame;
    controlsFrame.origin.y = CGRectGetHeight(self.view.bounds);

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:0 animations:^{

        self.view.backgroundColor = [UIColor clearColor];

        self.controlsView.frame = controlsFrame;
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

@end
