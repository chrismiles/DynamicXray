//
//  DXRDynamicXrayViewController.h
//  DynamicXray
//
//  Created by Chris Miles on 16/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

@import UIKit;
@class DynamicXray;
@class DXRDynamicXrayView;

@interface DXRDynamicXrayViewController : UIViewController

- (id)initDynamicXray:(DynamicXray *)dynamicXray;

@property (weak, nonatomic) DynamicXray *dynamicXray;

- (DXRDynamicXrayView *)xrayView;

@end
