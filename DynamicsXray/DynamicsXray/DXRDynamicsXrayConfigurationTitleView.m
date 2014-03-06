//
//  DXRDynamicsXrayConfigurationTitleView.m
//  DynamicsXray
//
//  Created by Chris Miles on 5/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationTitleView.h"
#import "DynamicsXray.h"


@implementation DXRDynamicsXrayConfigurationTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [self titleLabel];
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:titleLabel];

        UILabel *byLabel = [self byLabel];
        byLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:byLabel];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[titleLabel]-(>=0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, byLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[byLabel]-(>=0)-|" options:NSLayoutFormatAlignAllBaseline metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, byLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel][byLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel, byLabel)]];
    }
    return self;
}

- (UILabel *)titleLabel
{
    NSString *title = [NSString stringWithFormat:@"DynamicsXray %@", DynamicsXrayVersion];

    UIFont *titleFont = [UIFont fontWithName:@"Avenir Next Condensed Demi Bold" size:13.0f];
    UIFont *versionFont = [UIFont fontWithName:@"Avenir Next Condensed" size:13.0f];

    NSDictionary *textAttributes = @{NSFontAttributeName : titleFont};

    NSMutableAttributedString *attributedTitled = [[NSMutableAttributedString alloc] initWithString:title attributes:textAttributes];

    NSDictionary *versionAttributes = @{NSFontAttributeName : versionFont};
    NSUInteger versionLength = [DynamicsXrayVersion length];
    NSRange versionRange = NSMakeRange([title length] - versionLength, versionLength);
    [attributedTitled setAttributes:versionAttributes range:versionRange];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textColor = [UIColor colorWithWhite:1.0f alpha:0.6f];
    label.attributedText = attributedTitled;

    return label;
}

- (UILabel *)byLabel
{
    NSString *byLine = @"by Chris Miles";

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = byLine;
    label.font = [UIFont fontWithName:@"Avenir Next Condensed" size:10.0f];
    label.textColor = [UIColor colorWithWhite:1.0f alpha:0.4f];

    return label;
}

@end
