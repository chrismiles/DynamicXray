//
//  DXRDynamicsXRayViewController.h
//  DynamicsXRay
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;
@class DynamicsXRay;
@class DXRDynamicsXRayView;

@interface DXRDynamicsXRayViewController : UIViewController

- (id)initDynamicsXray:(DynamicsXRay *)dynamicsXray;

@property (weak, nonatomic) DynamicsXRay *dynamicsXray;

- (DXRDynamicsXRayView *)xrayView;

@end
