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
    [self setupLaunchFlap];
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
    [self.dynamicAnimator updateItemUsingCurrentState:self.launchButton];
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

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                __strong CMUIKitPinballViewController *strongSelf = weakSelf;
                [strongSelf addBall];
            });
        }
    };

    [self.dynamicAnimator addBehavior:pushBehavior];
    [pushBehavior setActive:YES];
}


#pragma mark - Launch Flap

- (void)setupLaunchFlap
{
    CGRect bounds = self.view.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    CGSize wallSize = self.launcherWallSize;
    CGSize flapSize = CGSizeMake(wallSize.width, self.launcherWidth * 1.5f);

    CGRect flapFrame = CGRectMake(width - self.launcherWidth - flapSize.width*1.5f,
                                  height - wallSize.height - wallSize.width*2.0f - flapSize.height,
                                  flapSize.width,
                                  flapSize.height);

    CGPoint pivotAnchor = CGPointMake(CGRectGetMidX(flapFrame), CGRectGetMaxY(flapFrame));

    [self.flapCollisionBehavior removeBoundaryWithIdentifier:@"FlapBoundary"];

    if (self.flapView == nil) {
        UIView *flapView = [[UIView alloc] initWithFrame:flapFrame];
        flapView.backgroundColor = [self wallColour];
        [self.view addSubview:flapView];

        UIOffset attachmentOffset = UIOffsetMake(0, flapSize.height/2.0f);
        UIAttachmentBehavior *flapPivotAttachment = [[UIAttachmentBehavior alloc] initWithItem:flapView offsetFromCenter:attachmentOffset attachedToAnchor:pivotAnchor];
        flapPivotAttachment.length = 0;
        [self.dynamicAnimator addBehavior:flapPivotAttachment];

        UICollisionBehavior *flapCollisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[flapView]];
        [self.dynamicAnimator addBehavior:flapCollisionBehavior];

        UIDynamicItemBehavior *flapBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[flapView]];
        flapBehavior.density = 0.1f;
        [self.dynamicAnimator addBehavior:flapBehavior];

        [self.collisionBehavior addItem:flapView];
        [self.gravityBehavior addItem:flapView];

        self.flapView = flapView;
        self.flapPivotAttachment = flapPivotAttachment;
        self.flapCollisionBehavior = flapCollisionBehavior;
    }

    self.flapView.frame = flapFrame;
    [self.dynamicAnimator updateItemUsingCurrentState:self.flapView];

    self.flapPivotAttachment.anchorPoint = pivotAnchor;

    CGRect flapCollisionRect = CGRectInset(flapFrame, -10.0f, 20.0f);
    flapCollisionRect = CGRectOffset(flapCollisionRect, -CGRectGetWidth(flapCollisionRect)/2.0f-2.0f, 0);
    UIBezierPath *flapCollisionPath = [UIBezierPath bezierPathWithRect:flapCollisionRect];
    CGAffineTransform rotateTransform = CGAffineTransformIdentity;
    rotateTransform = CGAffineTransformTranslate(rotateTransform, CGRectGetMidX(flapCollisionRect), CGRectGetMidY(flapCollisionRect));
    rotateTransform = CGAffineTransformRotate(rotateTransform, 2.0f*M_PI/180.0f);
    rotateTransform = CGAffineTransformTranslate(rotateTransform, -CGRectGetMidX(flapCollisionRect), -CGRectGetMidY(flapCollisionRect));
    [flapCollisionPath applyTransform:rotateTransform];
    [self.flapCollisionBehavior addBoundaryWithIdentifier:@"FlapBoundary" forPath:flapCollisionPath];
}

@end
