//
//  DXRDynamicsXrayConfigurationFaderView.m
//  DynamicsXray
//
//  Created by Chris Miles on 5/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationFaderView.h"

@interface DXRDynamicsXrayConfigurationFaderView ()

@property (strong, nonatomic, readwrite) UISlider *faderSlider;

@end


@implementation DXRDynamicsXrayConfigurationFaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UISlider *faderSlider = [[UISlider alloc] initWithFrame:CGRectZero];

        UILabel *faderAppLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        UILabel *faderXrayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        faderAppLabel.text = @"App";
        faderXrayLabel.text = @"Xray";

        [self addSubview:faderSlider];
        [self addSubview:faderAppLabel];
        [self addSubview:faderXrayLabel];

        faderSlider.translatesAutoresizingMaskIntoConstraints = NO;
        faderAppLabel.translatesAutoresizingMaskIntoConstraints = NO;
        faderXrayLabel.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary *layoutMetrics = @{@"margin": @(10.0f)};
        NSDictionary *layoutViews = NSDictionaryOfVariableBindings(faderSlider, faderAppLabel, faderXrayLabel);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[faderAppLabel]-(margin)-[faderSlider]-(margin)-[faderXrayLabel]|"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:layoutMetrics
                                                                       views:layoutViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[faderAppLabel]-(>=0)-|"
                                                                     options:0
                                                                     metrics:layoutMetrics
                                                                       views:layoutViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[faderSlider]-(>=0)-|"
                                                                     options:0
                                                                     metrics:layoutMetrics
                                                                       views:layoutViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[faderXrayLabel]-(>=0)-|"
                                                                     options:0
                                                                     metrics:layoutMetrics
                                                                       views:layoutViews]];

        self.faderSlider = faderSlider;
    }
    return self;
}

@end
