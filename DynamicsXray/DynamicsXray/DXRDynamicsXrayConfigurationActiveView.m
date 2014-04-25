//
//  DXRDynamicsXrayConfigurationActiveView.m
//  DynamicsXray
//
//  Created by Chris Miles on 5/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationActiveView.h"

@interface DXRDynamicsXrayConfigurationActiveView ()

@property (strong, nonatomic, readwrite) UISwitch *activeToggleSwitch;

@end


@implementation DXRDynamicsXrayConfigurationActiveView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UISwitch *activeToggleSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        activeToggleSwitch.translatesAutoresizingMaskIntoConstraints = NO;

        UILabel *activeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        activeLabel.translatesAutoresizingMaskIntoConstraints = NO;
        activeLabel.text = @"Xray";
        activeLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:29.0f];
        activeLabel.textColor = [UIColor colorWithWhite:1.0f alpha:0.6f];

        [self addSubview:activeLabel];
        [self addSubview:activeToggleSwitch];

        NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeLabel, activeToggleSwitch);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[activeLabel]-(5)-[activeToggleSwitch]|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:layoutViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[activeLabel]-(>=0)-|" options:0 metrics:nil views:layoutViews]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[activeToggleSwitch]-(>=0)-|" options:0 metrics:nil views:layoutViews]];

        [activeLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [activeToggleSwitch setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];

        self.activeToggleSwitch = activeToggleSwitch;
    }
    return self;
}

@end
