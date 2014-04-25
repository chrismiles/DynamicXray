//
//  DXRDynamicsXrayConfigurationViewController+Controls.h
//  DynamicsXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationViewController.h"
@class DXRDynamicsXrayConfigurationControlsView;


@interface DXRDynamicsXrayConfigurationViewController (Controls)

- (UIButton *)newDismissButtonWithFrame:(CGRect)frame;
- (void)setupControlsView;

@end
