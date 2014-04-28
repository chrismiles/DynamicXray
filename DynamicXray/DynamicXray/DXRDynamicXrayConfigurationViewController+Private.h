//
//  DXRDynamicXrayConfigurationViewController+Private.h
//  DynamicXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013-2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicXrayConfigurationViewController.h"

@class DynamicXray;

@interface DXRDynamicXrayConfigurationViewController (Private)

- (id)initWithDynamicXray:(DynamicXray *)dynamicXray;

- (void)setAnimateAppearance:(BOOL)animateAppearance;

@end
