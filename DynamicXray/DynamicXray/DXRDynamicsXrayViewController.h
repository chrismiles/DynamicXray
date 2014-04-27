//
//  DXRDynamicsXrayViewController.h
//  DynamicsXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;
@class DynamicsXray;
@class DXRDynamicsXrayView;

@interface DXRDynamicsXrayViewController : UIViewController

- (id)initDynamicsXray:(DynamicsXray *)dynamicsXray;

@property (weak, nonatomic) DynamicsXray *dynamicsXray;

- (DXRDynamicsXrayView *)xrayView;

@end
