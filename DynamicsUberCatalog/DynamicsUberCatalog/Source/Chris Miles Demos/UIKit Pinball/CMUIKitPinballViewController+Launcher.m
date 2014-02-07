//
//  CMUIKitPinballViewController+Launcher.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 7/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController+Launcher.h"
#import "CMUIKitPinballViewController_Private.h"


@implementation CMUIKitPinballViewController (Launcher)


#pragma mark - Set Up

- (void)setupLauncher
{
    [self setupLaunchSpring];
    [self setupLaunchButton];
}

- (void)setupLaunchButton
{
    if (self.launchButton == nil) {
        CGRect bounds = self.view.bounds;
        CGFloat launcherWidth = self.launcherWidth;
        CGFloat buttonHeight = self.launchButtonHeight;

        UILabel *launchButton = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(bounds) - launcherWidth, CGRectGetHeight(bounds) - buttonHeight, launcherWidth, buttonHeight)];
        launchButton.text = @"LAUNCH";
        launchButton.textColor = [UIColor blackColor];
        launchButton.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        launchButton.textAlignment = NSTextAlignmentCenter;
        launchButton.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);
        launchButton.userInteractionEnabled = YES;

        [self.view addSubview:launchButton];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchTapGestureRecognized:)];
        [launchButton addGestureRecognizer:tapGestureRecognizer];

        self.launchButton = launchButton;
    }
}

- (void)setupLaunchSpring
{
    if (self.launchSpringView == nil) {
        UIView *launchSpringView = [[UIView alloc] initWithFrame:CGRectZero];
        launchSpringView.backgroundColor = [UIColor darkGrayColor];

        [self.view addSubview:launchSpringView];

        self.launchSpringView = launchSpringView;
    }

    [self.collisionBehavior removeItem:self.launchSpringView];
    [self.launchSpringItemBehavior removeItem:self.launchSpringView];

    CGRect bounds = self.view.bounds;
    CGFloat launcherWidth = self.launcherWidth;
    CGFloat launchSpringHeight = self.launchSpringHeight;
    CGFloat launchButtonHeight = self.launchButtonHeight;

    CGRect frame = CGRectMake(CGRectGetWidth(bounds) - launcherWidth + 1.0f, CGRectGetHeight(bounds) - launchButtonHeight - launchSpringHeight, launcherWidth-2.0f, launchSpringHeight);
    self.launchSpringView.frame = frame;

    [self.collisionBehavior addItem:self.launchSpringView];
    [self.launchSpringItemBehavior addItem:self.launchSpringView];
}


#pragma mark - Launch Gesture

- (void)launchTapGestureRecognized:(__unused UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *launchSpringView = self.launchSpringView;

    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[launchSpringView] mode:UIPushBehaviorModeContinuous];
    [pushBehavior setAngle:-M_PI_2 magnitude:25.0f];

    __weak UIPushBehavior *weakPushBehavior = pushBehavior;

    pushBehavior.action = ^{
        CGRect launchFrame = launchSpringView.frame;
        CGFloat midY = CGRectGetMidY(self.view.bounds);
        if (CGRectGetMinY(launchFrame) <= midY) {
            launchFrame.origin.y = midY;
            [weakPushBehavior.dynamicAnimator removeBehavior:weakPushBehavior]; // finished!

            CGPoint velocity = [self.launchSpringItemBehavior linearVelocityForItem:launchSpringView];
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;
            [self.launchSpringItemBehavior addLinearVelocity:velocity forItem:launchSpringView];
        }
    };

    [self.dynamicAnimator addBehavior:pushBehavior];
    [pushBehavior setActive:YES];
}


@end
