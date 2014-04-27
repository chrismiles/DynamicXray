//
//  DXRDynamicsXrayConfigurationViewController.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController.h"
#import "DXRDynamicsXrayConfigurationViewController_Internal.h"
#import "DXRDynamicsXrayConfigurationViewController+Private.h"
#import "DXRDynamicsXrayConfigurationViewController+Controls.h"


@implementation DXRDynamicsXrayConfigurationViewController

- (id)initWithDynamicsXray:(DynamicXray *)dynamicsXray
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXray = dynamicsXray;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillChangeStatusBarOrientationNotification:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];

    CGRect bounds = self.view.bounds;

    UIButton *dismissButton = [self newDismissButtonWithFrame:bounds];
    [self.view addSubview:dismissButton];

    [self setupControlsView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (self.animateAppearance && self.initialAppearanceWasAnimated == NO) {
        // Hide views, preparing to animate in
        self.view.backgroundColor = [UIColor clearColor];
        [self.controlsView layoutIfNeeded];
        self.controlsBottomLayoutConstraint.constant = CGRectGetHeight(self.controlsView.frame);
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


#pragma mark - Rotation

- (void)applicationWillChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
        [self.controlsView removeFromSuperview];
        UIInterfaceOrientation toInterfaceOrientation = [notification.userInfo[UIApplicationStatusBarOrientationUserInfoKey] integerValue];
        [self setupControlsViewWithInterfaceOrientation:toInterfaceOrientation];
        [self.view layoutIfNeeded];
    }
}


#pragma mark - Transition Animations

- (void)transitionInAnimatedWithCompletion:(void (^)(void))completion
{
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:0 animations:^{

        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];

        self.controlsBottomLayoutConstraint.constant = 0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

- (void)transitionOutAnimatedWithCompletion:(void (^)(void))completion
{
    CGRect controlsFrame = self.controlsView.frame;

    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:1.0f initialSpringVelocity:0 options:0 animations:^{

        self.view.backgroundColor = [UIColor clearColor];

        self.controlsBottomLayoutConstraint.constant = CGRectGetHeight(controlsFrame);
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (completion) completion();
    }];
}

@end
