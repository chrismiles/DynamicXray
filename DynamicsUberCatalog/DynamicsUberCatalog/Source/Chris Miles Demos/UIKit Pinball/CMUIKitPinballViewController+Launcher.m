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
    [self setupLaunchButton];
}

- (void)setupLaunchButton
{
    CGRect bounds = self.view.bounds;
    CGFloat launcherWidth = self.launcherWidth;
    CGFloat buttonWidth = (CGFloat)round(launcherWidth * 0.9f);
    CGFloat buttonHeight = self.launchButtonHeight;

    CGFloat yPos = [self launcherEndYPos];

    CGRect buttonFrame = CGRectMake(CGRectGetWidth(bounds) - launcherWidth + (launcherWidth - buttonWidth)/2.0f,
                                    yPos,
                                    buttonWidth,
                                    buttonHeight);


    if (self.launchButton == nil) {
        UILabel *launchButton = [[UILabel alloc] initWithFrame:buttonFrame];
        launchButton.text = @"⇧";
        launchButton.textColor = [UIColor blackColor];
        launchButton.font = [UIFont systemFontOfSize:24.0f];
        launchButton.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        launchButton.textAlignment = NSTextAlignmentCenter;
        launchButton.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin);
        launchButton.userInteractionEnabled = YES;

        [self.view addSubview:launchButton];

        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(launchTapGestureRecognized:)];
        [launchButton addGestureRecognizer:tapGestureRecognizer];

        [self.collisionBehavior removeItem:launchButton];
        [self.launchSpringItemBehavior removeItem:launchButton];

        [self.collisionBehavior addItem:launchButton];
        [self.launchSpringItemBehavior addItem:launchButton];

        self.launchButton = launchButton;
    }

    self.launchButton.frame = buttonFrame;
}

- (CGFloat)launcherEndYPos
{
    return CGRectGetHeight(self.view.bounds) - self.launchButtonHeight - self.launchSpringHeight;
}


#pragma mark - Launch Gesture

- (void)launchTapGestureRecognized:(__unused UITapGestureRecognizer *)tapGestureRecognizer
{
    UIView *launcherView = self.launchButton;

    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[launcherView] mode:UIPushBehaviorModeContinuous];
    [pushBehavior setAngle:-M_PI_2 magnitude:20.0f];

    __weak UIPushBehavior *weakPushBehavior = pushBehavior;
    __weak CMUIKitPinballViewController *weakSelf = self;

    CGFloat launcherEndY = [self launcherEndYPos];

    pushBehavior.action = ^{
        CGRect launchFrame = launcherView.frame;
        if (CGRectGetMinY(launchFrame) <= launcherEndY) {
            launchFrame.origin.y = launcherEndY;
            [weakPushBehavior.dynamicAnimator removeBehavior:weakPushBehavior]; // push finished!

            __strong CMUIKitPinballViewController *strongSelf = weakSelf;

            // Cancel out velocity of launch spring
            CGPoint velocity = [strongSelf.launchSpringItemBehavior linearVelocityForItem:launcherView];
            velocity.x = -velocity.x;
            velocity.y = -velocity.y;
            [strongSelf.launchSpringItemBehavior addLinearVelocity:velocity forItem:launcherView];

            strongSelf.ballReadyForLaunch = nil;
        }
    };

    [self.dynamicAnimator addBehavior:pushBehavior];
    [pushBehavior setActive:YES];
}


@end
