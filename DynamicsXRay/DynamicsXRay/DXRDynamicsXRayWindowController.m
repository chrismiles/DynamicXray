//
//  DXRDynamicsXRayWindowController.m
//  DynamicsXRay
//
//  Created by Chris Miles on 14/10/13.
//  Copyright (c) 2013 Chris Miles. All rights reserved.
//

#import "DXRDynamicsXRayWindowController.h"

@interface DXRDynamicsXRayWindowController ()

@property (weak, nonatomic) UIWindow *window;

@end


@implementation DXRDynamicsXRayWindowController

- (UIWindow *)xrayWindow
{
    UIWindow *window = self.window;

    if (window == nil) {
        CGRect screenBounds = [[UIScreen mainScreen] bounds];

        window = [[UIWindow alloc] initWithFrame:screenBounds];
        window.windowLevel = UIWindowLevelAlert;
        window.userInteractionEnabled = NO;
        self.window = window;
    }

    return window;
}

@end
