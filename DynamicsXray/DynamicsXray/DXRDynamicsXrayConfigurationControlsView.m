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
@property (strong, nonatomic) UIView *titleFaderSeparatorView;

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
        self.titleFaderSeparatorView = [self newTitleFaderSeparatorView];
        self.faderView = [self newFaderView];

        [contentsView addSubview:self.titleFaderSeparatorView];
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
    UIView *titleFaderSeparatorView = self.titleFaderSeparatorView;
    UIView *titleView = self.titleView;

    NSDictionary *layoutViews = NSDictionaryOfVariableBindings(activeView, faderView, titleFaderSeparatorView, titleView);

    UIScreen *screen = (self.window.screen ?: [UIScreen mainScreen]);
    CGFloat scale = screen.scale;
    CGSize titleViewSize = [titleView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    NSDictionary *metrics = @{
                              @"titleViewWidth": @(titleViewSize.width),
                              @"titleViewHeight": @(titleViewSize.height),
                              @"sm": @(10.0f),  // side margin
                              @"separatorLineHeight": @(1.0f / scale),
                              };

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[titleView(titleViewWidth)]-(>=10)-[activeView]-(sm)-|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[faderView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(sm)-[titleFaderSeparatorView]-(sm)-|" options:0 metrics:metrics views:layoutViews]];

    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(sm)-[faderView]-(10)-[titleFaderSeparatorView(separatorLineHeight)]-(>=5)-[titleView(titleViewHeight)]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
    [contentsView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleFaderSeparatorView]-(>=5)-[activeView]-(>=sm)-|" options:0 metrics:metrics views:layoutViews]];
}


#pragma mark - Subview Creation

- (DXRDynamicsXrayConfigurationActiveView *)newActiveView
{
    DXRDynamicsXrayConfigurationActiveView *activeView = [[DXRDynamicsXrayConfigurationActiveView alloc] initWithFrame:CGRectZero];
    activeView.translatesAutoresizingMaskIntoConstraints = NO;
    return activeView;
}

- (DXRDynamicsXrayConfigurationTitleView *)newTitleView
{
    DXRDynamicsXrayConfigurationTitleView *titleView = [[DXRDynamicsXrayConfigurationTitleView alloc] initWithFrame:CGRectZero];
    titleView.translatesAutoresizingMaskIntoConstraints = NO;
    return titleView;
}

- (DXRDynamicsXrayConfigurationFaderView *)newFaderView
{
    DXRDynamicsXrayConfigurationFaderView *faderView = [[DXRDynamicsXrayConfigurationFaderView alloc] initWithFrame:CGRectZero];
    faderView.translatesAutoresizingMaskIntoConstraints = NO;
    return faderView;
}

- (UIView *)newTitleFaderSeparatorView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor colorWithRed:0.192157f green:0.192157f blue:0.192157f alpha:1.0f];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

@end
