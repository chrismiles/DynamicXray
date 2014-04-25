//
//  DXRDynamicsXrayConfigurationControlsView.m
//  DynamicsXray
//
//  Created by Chris Miles on 6/03/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXrayConfigurationControlsView.h"

#import "DXRDynamicsXrayConfigurationActiveView.h"
#import "DXRDynamicsXrayConfigurationTitleView.h"
#import "DXRDynamicsXrayConfigurationFaderView.h"


@interface DXRDynamicsXrayConfigurationControlsView ()

@property (strong, nonatomic) UIView *contentsView;

@property (strong, nonatomic) DXRDynamicsXrayConfigurationActiveView *activeView;
@property (strong, nonatomic) DXRDynamicsXrayConfigurationFaderView *faderView;
@property (strong, nonatomic) DXRDynamicsXrayConfigurationTitleView *titleView;

@end


@implementation DXRDynamicsXrayConfigurationControlsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        // Add a UIToolbar simply to get its nice blur :)

        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.barStyle = UIBarStyleBlackTranslucent;
        toolbar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        [self addSubview:toolbar];

        // Contents container for controls, labels, etc

        UIView *contentsView = [[UIView alloc] initWithFrame:self.bounds];
        contentsView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        contentsView.backgroundColor = [UIColor clearColor];
        [self addSubview:contentsView];

        // Titles and Controls

        self.titleView = [self newTitleView];
        self.activeView = [self newActiveView];
        self.faderView = [self newFaderView];

        [contentsView addSubview:self.titleView];
        [contentsView addSubview:self.faderView];
        [contentsView addSubview:self.activeView];

        self.contentsView = contentsView;

        [self configureLayout];
    }
    return self;
}

- (void)configureLayout
{
    UIView *activeView = self.activeView;
    UIView *contentsView = self.contentsView;
    UIView *faderView = self.faderView;
    UIView *titleView = self.titleView;

    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeView, faderView, titleView);

    CGSize titleViewSize = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSDictionary *metrics = @{
                              @"titleViewWidth": @(titleViewSize.width),
                              @"titleViewHeight": @(titleViewSize.height),
                              @"sm": @(10),  // side margin
                              };

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[titleView(titleViewWidth)]-(>=10)-[activeView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[faderView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(sm)-[faderView]-(>=10)-[titleView(titleViewHeight)]-(sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[activeView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];
}

#pragma mark - Subview Creation

- (DXRDynamicsXrayConfigurationActiveView *)newActiveView
{
    DXRDynamicsXrayConfigurationActiveView *activeView = [[DXRDynamicsXrayConfigurationActiveView alloc] initWithFrame:CGRectZero];
    activeView.translatesAutoresizingMaskIntoConstraints = NO;

    // activeView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3f];//DEBUG

    return activeView;
}

- (DXRDynamicsXrayConfigurationTitleView *)newTitleView
{
    DXRDynamicsXrayConfigurationTitleView *titleView = [[DXRDynamicsXrayConfigurationTitleView alloc] initWithFrame:CGRectZero];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;

    //    titleView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3f];//DEBUG

    return titleView;
}

- (DXRDynamicsXrayConfigurationFaderView *)newFaderView
{
    DXRDynamicsXrayConfigurationFaderView *faderView = [[DXRDynamicsXrayConfigurationFaderView alloc] initWithFrame:CGRectZero];
    faderView.translatesAutoresizingMaskIntoConstraints = NO;

    // faderView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.3f];//DEBUG
    
    return faderView;
}

@end
