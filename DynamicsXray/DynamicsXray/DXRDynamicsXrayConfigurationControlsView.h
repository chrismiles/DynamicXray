//
//  DXRDynamicsXrayConfigurationControlsView.h
//  DynamicsXray
//
//  Created by Chris Miles on 6/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXRDynamicsXrayConfigurationActiveView;
@class DXRDynamicsXrayConfigurationFaderView;


@interface DXRDynamicsXrayConfigurationControlsView : UIView

@property (strong, nonatomic, readonly) DXRDynamicsXrayConfigurationActiveView *activeView;
@property (strong, nonatomic, readonly) DXRDynamicsXrayConfigurationFaderView *faderView;

@end
