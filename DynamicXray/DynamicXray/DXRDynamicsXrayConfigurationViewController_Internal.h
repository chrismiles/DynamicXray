//
//  DXRDynamicsXrayConfigurationViewController_Internal.h
//  DynamicsXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController.h"
#import "DXRDynamicsXrayConfigurationControlsView.h"
#import "DynamicXray.h"

@interface DXRDynamicsXrayConfigurationViewController ()

@property (weak, nonatomic) DynamicXray *dynamicsXray;

@property (assign, nonatomic) BOOL animateAppearance;

@property (assign, nonatomic) BOOL initialAppearanceWasAnimated;
@property (strong, nonatomic) DXRDynamicsXrayConfigurationControlsView *controlsView;
@property (strong, nonatomic) NSLayoutConstraint *controlsBottomLayoutConstraint;

- (void)transitionOutAnimatedWithCompletion:(void (^)(void))completion;

@end
