//
//  TLWobblySpringFlowLayout.h
//  UICollectionView-Spring-Demo
//
//  Created by Ash Furrow on 2013-07-31.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//
//  Modified by Gerald Kim
//  DynamicXray added by Chris Miles
//

#import <UIKit/UIKit.h>
#import <DynamicXray/DynamicXray.h>

@interface TLWobblySpringFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong, readonly) DynamicXray *dynamicXray;

@end
