//
//  DynamicsXray+XrayUserInterface.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"
#import "DynamicXray_Internal.h"
#import "DXRDynamicsXrayWindowController.h"


@implementation DynamicXray (XrayUserInterface)

- (void)presentConfigurationViewController
{
    [[self xrayWindowController] presentConfigViewControllerWithDynamicsXray:self animated:YES];
}

@end
