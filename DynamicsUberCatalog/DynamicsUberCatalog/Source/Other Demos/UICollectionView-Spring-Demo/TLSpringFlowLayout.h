//
//  TLSpringFlowLayout.h
//  UICollectionView-Spring-Demo
//
//  Created by Ash Furrow on 2013-07-31.
//  Copyright (c) 2013 Teehan+Lax. All rights reserved.
//
//  DynamicsXray added by Chris Miles
//

#import <UIKit/UIKit.h>
#import <DynamicsXRay/DynamicsXRay.h>

@interface TLSpringFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong, readonly) DynamicsXRay *dynamicsXray;

@end
