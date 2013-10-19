//
//  DXRDynamicsXRayWindowController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayWindowController.h"
#import "DXRDynamicsXRayViewController.h"
#import "DXRDynamicsXRayConfigurationViewController.h"


@interface DXRDynamicsXRayWindowController ()

@property (strong, nonatomic) DXRDynamicsXRayConfigurationViewController *configurationViewController;
@property (strong, nonatomic) NSMutableArray *xrayViewControllers;

@property (weak, nonatomic) UIWindow *window;

@end


@implementation DXRDynamicsXRayWindowController

- (id)init
{
    self = [super init];
    if (self) {
        _xrayViewControllers = [NSMutableArray array];
    }
    return self;
}

- (UIWindow *)xrayWindow
{
    UIWindow *window = self.window;

    if (window == nil) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        // Create a new shared UIWindow to host dynamics xray views
        window = [[UIWindow alloc] initWithFrame:screenBounds];
        window.windowLevel = UIWindowLevelStatusBar + 1;
        window.userInteractionEnabled = NO;

        // Create a share root view controller on the window
        UIViewController *rootViewController = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        [window setRootViewController:rootViewController];

        self.window = window;
    }

    return window;
}


#pragma mark - Xray View Controller Presentation

- (void)presentDynamicsXRayViewController:(DXRDynamicsXRayViewController *)dynamicsXRayViewController
{
    if ([self.xrayViewControllers containsObject:dynamicsXRayViewController] == NO) {
        [self.xrayViewControllers addObject:dynamicsXRayViewController];

        [dynamicsXRayViewController.view setFrame:self.window.bounds];
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
    [self.xrayViewControllers removeObject:xrayViewController];
}


#pragma mark - Config View Controller Presentation

- (void)presentConfigViewController:(DXRDynamicsXRayConfigurationViewController *)configViewController
{
    if (self.configurationViewController == nil) {
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

@end
