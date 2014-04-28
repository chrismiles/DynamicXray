//
//  DXRDynamicXrayConfigurationViewController+Controls.h
//  DynamicXray
//
//  Created by Chris Miles on 24/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayConfigurationViewController.h"
@class DXRDynamicXrayConfigurationControlsView;


@interface DXRDynamicXrayConfigurationViewController (Controls)

- (UIButton *)newDismissButtonWithFrame:(CGRect)frame;

- (void)setupControlsView;
- (void)setupControlsViewWithInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end
