//
//  DXRDynamicXrayConfigurationControlsView.h
//  DynamicsXray
//
//  Created by Chris Miles on 6/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DXRDynamicXrayConfigurationActiveView;
@class DXRDynamicXrayConfigurationFaderView;


typedef NS_ENUM(NSInteger, DXRDynamicsXrayConfigurationControlsLayoutStyle)
{
    DXRDynamicsXrayConfigurationControlsLayoutStyleWide,
    DXRDynamicsXrayConfigurationControlsLayoutStyleNarrow,
};


@interface DXRDynamicXrayConfigurationControlsView : UIView

- (id)initWithLayoutStyle:(DXRDynamicsXrayConfigurationControlsLayoutStyle)layoutStyle;

@property (strong, nonatomic, readonly) DXRDynamicXrayConfigurationActiveView *activeView;
@property (strong, nonatomic, readonly) DXRDynamicXrayConfigurationFaderView *faderView;

@end
