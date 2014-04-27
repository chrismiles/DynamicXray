//
//  DXRDynamicsXrayViewController.h
//  DynamicsXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;
@class DynamicXray;
@class DXRDynamicsXrayView;

@interface DXRDynamicsXrayViewController : UIViewController

- (id)initDynamicsXray:(DynamicXray *)dynamicsXray;

@property (weak, nonatomic) DynamicXray *dynamicsXray;

- (DXRDynamicsXrayView *)xrayView;

@end
