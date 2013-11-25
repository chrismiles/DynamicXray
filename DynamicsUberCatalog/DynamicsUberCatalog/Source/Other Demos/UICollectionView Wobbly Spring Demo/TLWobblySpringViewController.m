//
//  TLWobblySpringViewController.m
//  UICollectionView-Spring-Demo
//
//  Created by Ash Furrow on 2013-07-31.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//
//  Modified by Gerald Kim
//  DynamicsXray added by Chris Miles
//

#import "TLWobblySpringViewController.h"
#import "TLWobblySpringFlowLayout.h"


@interface TLWobblySpringViewController () <UICollectionViewDelegateFlowLayout>

@end


@implementation TLWobblySpringViewController

static NSString * CellIdentifier = @"CellIdentifier";

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.137f alpha:1.0f];

    [self setupToolbar];
}

- (void)setupToolbar
{
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *xrayItem = [[UIBarButtonItem alloc] initWithTitle:@"Xray" style:UIBarButtonItemStylePlain target:self action:@selector(xrayAction:)];
    self.toolbarItems = @[flexibleItem, xrayItem];
    self.navigationController.toolbarHidden = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


#pragma mark - Xray

- (void)xrayAction:(__unused id)sender
{
    TLWobblySpringFlowLayout *layout = (TLWobblySpringFlowLayout *)self.collectionViewLayout;
    [layout.dynamicsXray presentConfigurationViewController];
}


#pragma mark - UICollectionView Methods

- (NSInteger)collectionView:(__unused UICollectionView *)collectionView numberOfItemsInSection:(__unused NSInteger)section
{
    return 10000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UIColor *tlBlue = [UIColor colorWithHue:0.5472f saturation:0.6f brightness:0.53f alpha:1.0f];
    cell.backgroundColor = tlBlue;
    
    return cell;
}

@end
