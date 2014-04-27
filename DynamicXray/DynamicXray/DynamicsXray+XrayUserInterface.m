//
//  DynamicsXray+XrayUserInterface.m
//  DynamicsXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray.h"
#import "DynamicsXray_Internal.h"
#import "DXRDynamicsXrayWindowController.h"


@implementation DynamicsXray (XrayUserInterface)

- (void)presentConfigurationViewController
{
    [[self xrayWindowController] presentConfigViewControllerWithDynamicsXray:self animated:YES];
}

@end
