//
//  DXCLoadingPattyViewController.m
//  DynamicXrayCatalog
//
//  Created by Peter Hare on 1/05/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXCLoadingPattyViewController.h"
#import "BHLoadingPatty.h"

@interface DXCLoadingPattyViewController ()

@property (nonatomic) BHLoadingPatty *loadingPatty;

@end

@implementation DXCLoadingPattyViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.loadingPatty = [BHLoadingPatty instanceShownInView:self.view];
}

@end
