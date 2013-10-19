//
//  DXRDynamicsXRayViewController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayViewController.h"
#import "DXRDynamicsXRayView.h"


@interface DXRDynamicsXRayViewController ()

@end


@implementation DXRDynamicsXRayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)loadView
{
    self.view = [[DXRDynamicsXRayView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 568.0f)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (DXRDynamicsXRayView *)xrayView
{
    return (DXRDynamicsXRayView *)self.view;
}

@end
