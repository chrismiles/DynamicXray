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


typedef NS_ENUM(NSInteger, DXRDynamicsXrayConfigurationControlsLayoutStyle)
{
    DXRDynamicsXrayConfigurationControlsLayoutStyleWide,
    DXRDynamicsXrayConfigurationControlsLayoutStyleNarrow,
};


@interface DXRDynamicsXrayConfigurationControlsView : UIView

- (id)initWithLayoutStyle:(DXRDynamicsXrayConfigurationControlsLayoutStyle)layoutStyle;

@property (strong, nonatomic, readonly) DXRDynamicsXrayConfigurationActiveView *activeView;
@property (strong, nonatomic, readonly) DXRDynamicsXrayConfigurationFaderView *faderView;

@end
