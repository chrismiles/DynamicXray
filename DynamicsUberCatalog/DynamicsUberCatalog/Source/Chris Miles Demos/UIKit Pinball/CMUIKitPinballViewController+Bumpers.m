//
//  CMUIKitPinballViewController+Bumpers.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 18/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController+Bumpers.h"
#import "CMUIKitPinballViewController_Private.h"
#import "CMUIKitPinballBumperView.h"

@implementation CMUIKitPinballViewController (Bumpers)

- (void)setupBumpers
{
    if (self.bumperViews == nil) {
        self.bumperViews = [NSMutableArray array];
    }

    for (UIView *bumperView in self.bumperViews) {
        [bumperView removeFromSuperview];
        [self.bumperItemBehavior removeItem:bumperView];
        [self.collisionBehavior removeItem:bumperView];
    }
    [self.bumperViews removeAllObjects];

    if (self.bumperItemBehavior == nil) {
        UIDynamicItemBehavior *bumperBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[]];
        bumperBehavior.allowsRotation = NO;
        bumperBehavior.density = 0.1f;

        __weak CMUIKitPinballViewController *weakSelf = self;

        bumperBehavior.action = ^{
            __strong CMUIKitPinballViewController *strongSelf = weakSelf;

            for (CMUIKitPinballBumperView *bumperView in strongSelf.bumperViews) {
                bumperView.center = bumperView.originalCenterPosition;
                [strongSelf.dynamicAnimator updateItemUsingCurrentState:bumperView];

                CGPoint velocity = [strongSelf.launchSpringItemBehavior linearVelocityForItem:bumperView];
                velocity.x = -velocity.x;
                velocity.y = -velocity.y;
                [strongSelf.launchSpringItemBehavior addLinearVelocity:velocity forItem:bumperView];
            }
        };
        [self.dynamicAnimator addBehavior:bumperBehavior];

        self.bumperItemBehavior = bumperBehavior;
    }

    {
        UIView *bumper1View = [self newBumperViewAtPosition:CGPointMake(100.0f, 100.0f)];
        [self.view addSubview:bumper1View];

        [self.bumperItemBehavior addItem:bumper1View];
        [self.collisionBehavior addItem:bumper1View];
        [self.bumperViews addObject:bumper1View];
    }

    {
        UIView *bumper2View = [self newBumperViewAtPosition:CGPointMake(200.0f, 100.0f)];
        [self.view addSubview:bumper2View];

        [self.bumperItemBehavior addItem:bumper2View];
        [self.collisionBehavior addItem:bumper2View];
        [self.bumperViews addObject:bumper2View];
    }
}

- (UIView *)newBumperViewAtPosition:(CGPoint)position
{
    CGFloat const bumperRadius = 15.0f;

    CMUIKitPinballBumperView *bumperView = [[CMUIKitPinballBumperView alloc] initWithFrame:CGRectMake(0, 0, bumperRadius * 2.0f, bumperRadius * 2.0f)];
    bumperView.originalCenterPosition = position;
    bumperView.center = position;
    bumperView.backgroundColor = [UIColor greenColor];
    bumperView.layer.cornerRadius = bumperRadius;
    bumperView.layer.masksToBounds = YES;

    return bumperView;
}

- (void)checkBumperContactWithItem1:(id<UIDynamicItem>)item1 item2:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p
{
    if ([item1 isKindOfClass:[CMUIKitPinballBumperView class]]) {
        [self handleContactWithBumper:(CMUIKitPinballBumperView *)item1 ballView:(UIView *)item2 atPoint:p];
    }
    else if ([item2 isKindOfClass:[CMUIKitPinballBumperView class]]) {
        [self handleContactWithBumper:(CMUIKitPinballBumperView *)item2 ballView:(UIView *)item1 atPoint:p];
    }
}

- (void)handleContactWithBumper:(CMUIKitPinballBumperView *)bumperView ballView:(UIView *)ballView atPoint:(__unused CGPoint)p
{
    CGFloat bumpAngle = atan2(ballView.center.x - bumperView.center.x, ballView.center.y - bumperView.center.y);

    UIPushBehavior *bumpBehavior = [[UIPushBehavior alloc] initWithItems:@[ballView] mode:UIPushBehaviorModeInstantaneous];
    bumpBehavior.magnitude = 1.0f;
    bumpBehavior.angle = bumpAngle;
    [self.dynamicAnimator addBehavior:bumpBehavior];

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5f, 1.5f, 1.0f)];
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [bumperView.layer addAnimation:animation forKey:@"transform"];
}

@end
