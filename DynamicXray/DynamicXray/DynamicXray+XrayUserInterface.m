//
//  DynamicXray+XrayUserInterface.m
//  DynamicXray
//
//  Created by Chris Miles on 16/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"
#import "DynamicXray_Internal.h"
#import "DXRDynamicXrayWindowController.h"


@implementation DynamicXray (XrayUserInterface)

- (void)presentConfigurationViewController
{
    [[self xrayWindowController] presentConfigViewControllerWithDynamicXray:self animated:YES];
}

@end
