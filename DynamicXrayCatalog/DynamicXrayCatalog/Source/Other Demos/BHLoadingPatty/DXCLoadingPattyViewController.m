//
//  DXCLoadingPattyViewController.m
//  DynamicXrayCatalog
//
//  Created by Peter Hare on 1/05/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXCLoadingPattyViewController.h"
#import "BHLoadingPatty.h"

#import <DynamicXray/DynamicXray.h>

@interface DXCLoadingPattyViewController ()

@property (nonatomic) BHLoadingPatty *loadingPatty;

@end

@implementation DXCLoadingPattyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *xrayItem = [[UIBarButtonItem alloc] initWithTitle:@"Xray" style:UIBarButtonItemStyleBordered target:self action:@selector(xrayAction:)];
    self.toolbarItems = @[flexibleItem, xrayItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.loadingPatty = [BHLoadingPatty instanceShownInView:self.view];
}

#pragma mark - DynamicXray

- (void)xrayAction:(__unused id)sender
{
    [self.loadingPatty.dynamicXray presentConfigurationViewController];
}


@end
