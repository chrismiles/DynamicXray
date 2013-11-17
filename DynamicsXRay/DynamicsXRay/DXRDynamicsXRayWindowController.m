//
//  DXRDynamicsXRayWindowController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayWindowController.h"
#import "DXRDynamicsXRayViewController.h"
#import "DXRDynamicsXRayWindow.h"
#import "DXRDynamicsXRayConfigurationViewController.h"
#import "DXRDynamicsXRayConfigurationViewController+Private.h"
#import "DynamicsXRay_Internal.h"


static CGFloat
AngleForUIInterfaceOrientation(UIInterfaceOrientation interfaceOrientation);


@interface DXRDynamicsXRayWindowController () <DXRDynamicsXRayWindowDelegate>

@property (strong, nonatomic) DXRDynamicsXRayConfigurationViewController *configurationViewController;
@property (strong, nonatomic) NSMutableArray *xrayViewControllers;

@property (weak, nonatomic) DXRDynamicsXRayWindow *window;

@end


@implementation DXRDynamicsXRayWindowController

- (id)init
{
    self = [super init];
    if (self) {
        _xrayViewControllers = [NSMutableArray array];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarFrameNotification:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidChangeStatusBarOrientationNotification:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (UIWindow *)xrayWindow
{
    DXRDynamicsXRayWindow *window = self.window;

    if (window == nil) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        // Create a new shared UIWindow to host dynamics xray views
        window = [[DXRDynamicsXRayWindow alloc] initWithFrame:screenBounds];
        window.xrayWindowDelegate = self;
        window.windowLevel = UIWindowLevelStatusBar + 1;
        window.userInteractionEnabled = NO;

        // Create a share root view controller on the window
        UIViewController *rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        [window setRootViewController:rootViewController];
        rootViewController.view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);

        self.window = window;
    }

    return window;
}


#pragma mark - Xray View Controller Presentation

- (void)presentDynamicsXRayViewController:(DXRDynamicsXRayViewController *)dynamicsXRayViewController
{
    if ([self.xrayViewControllers containsObject:dynamicsXRayViewController] == NO) {
        [self.xrayViewControllers addObject:dynamicsXRayViewController];

        UIView *rootView = self.window.rootViewController.view;
        [dynamicsXRayViewController.view setTransform:rootView.transform];
        [dynamicsXRayViewController.view setFrame:rootView.frame];
        [dynamicsXRayViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

        if (self.configurationViewController.view.superview == self.window) {
            [self.window insertSubview:dynamicsXRayViewController.view belowSubview:self.configurationViewController.view];
        }
        else {
            [self.window addSubview:dynamicsXRayViewController.view];
        }

        [self addChildViewController:dynamicsXRayViewController];
    }
}

- (void)dismissDynamicsXRayViewController:(DXRDynamicsXRayViewController *)xrayViewController
{
    [xrayViewController.view removeFromSuperview];
    [xrayViewController removeFromParentViewController];
    [self.xrayViewControllers removeObject:xrayViewController];
}


#pragma mark - Config View Controller Presentation

- (void)presentConfigViewControllerWithDynamicsXray:(DynamicsXRay *)dynamicsXray
{
    if (self.configurationViewController == nil) {
        DXRDynamicsXRayConfigurationViewController *configViewController = [[DXRDynamicsXRayConfigurationViewController alloc] initWithDynamicsXRay:dynamicsXray];
        self.configurationViewController = configViewController;

        [configViewController.view setFrame:self.window.bounds];
        [configViewController.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];

        [self.window addSubview:configViewController.view];

        [self addChildViewController:configViewController];

        [self.window setUserInteractionEnabled:YES];
    }
    else {
        NSLog(@"Warning: attempt to present a DynamicsXray Configuration view when one is already visible.");
    }
}

- (void)dismissConfigViewController
{
    [self.configurationViewController.view removeFromSuperview];
    self.configurationViewController = nil;

    [self.window setUserInteractionEnabled:NO];
}


#pragma mark - Status Bar Frame & Orientation Changes

- (void)applicationDidChangeStatusBarFrameNotification:(NSNotification *)notification
{
    [self layoutRootViews];
}

- (void)applicationDidChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    [self layoutRootViews];
}

- (void)layoutRootViews
{
    if (self.window == nil) return;

    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    CGFloat angle = AngleForUIInterfaceOrientation(statusBarOrientation);

    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    CGSize frameSize = self.window.frame.size;
    CGRect frame = CGRectMake(0, 0, frameSize.width, frameSize.height);

    NSArray *viewControllers = self.childViewControllers;

    for (UIViewController *viewController in viewControllers) {
        UIView *rootView = viewController.view;

        if (CGRectEqualToRect(frame, rootView.frame) == NO || CGAffineTransformEqualToTransform(transform, rootView.transform) == NO) {
            rootView.transform = transform;
            rootView.frame = CGRectMake(0, 0, frameSize.width, frameSize.height);

            if ([viewController isKindOfClass:[DXRDynamicsXRayViewController class]]) {
                [[(DXRDynamicsXRayViewController *)viewController dynamicsXray] redraw];
            }
        }
    }
}


#pragma mark - DXRDynamicsXRayWindowDelegate

- (void)dynamicsXRayWindowNeedsToLayoutSubviews:(DXRDynamicsXRayWindow *)dynamicsXRayWindow
{
    [self layoutRootViews];
}

@end


static CGFloat
AngleForUIInterfaceOrientation(UIInterfaceOrientation interfaceOrientation)
{
    CGFloat angle;

    if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        angle = M_PI;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        angle = -M_PI_2;
    }
    else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        angle = M_PI_2;
    }
    else {
        angle = 0;
    }

    return angle;
}
