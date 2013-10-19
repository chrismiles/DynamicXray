//
//  DXRDynamicsXRayConfigurationViewController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayConfigurationViewController.h"
#import "DynamicsXRay.h"


@interface DXRDynamicsXRayConfigurationViewController ()

@property (weak, nonatomic) DynamicsXRay *dynamicsXRay;

@end


@implementation DXRDynamicsXRayConfigurationViewController

- (id)initWithDynamicsXRay:(DynamicsXRay *)dynamicsXRay
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _dynamicsXRay = dynamicsXRay;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8f];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
