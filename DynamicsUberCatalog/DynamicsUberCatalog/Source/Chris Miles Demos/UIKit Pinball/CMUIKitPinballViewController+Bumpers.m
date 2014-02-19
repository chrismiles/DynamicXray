//
//  CMUIKitPinballViewController+Bumpers.m
//  DynamicsUberCatalog
//
//  Created by Chris Miles on 18/02/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "CMUIKitPinballViewController+Bumpers.h"
#import "CMUIKitPinballViewController_Private.h"
#import "CMUIKitPinballViewController+Configuration.h"
#import "CMUIKitPinballBumperView.h"


NSString * const CMUIKitPinballBumperBoundaryIdentifierPrefix = @"bumper";


@implementation CMUIKitPinballViewController (Bumpers)

- (void)setupBumpers
{
    CGRect bounds = self.view.bounds;
    CGFloat width = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);

    NSArray *bumperPositions = @[
                                 @[@(width * 0.3f), @(height * 0.15f)],
                                 @[@(width * 0.7f), @(height * 0.15f)],
                                 ];

    if (self.bumperViews == nil) {
        self.bumperViews = [NSMutableArray array];

        for (NSArray *bumperPosValue in bumperPositions) {
            CGPoint position;
            position.x = [bumperPosValue[0] floatValue];
            position.y = [bumperPosValue[1] floatValue];

            UIView *bumperView = [self newBumperView];
            [self.view addSubview:bumperView];
            [self.bumperViews addObject:bumperView];
        }
    }

    if (self.bumperPushBehaviors == nil) {
        self.bumperPushBehaviors = [NSMutableDictionary dictionary];
    }

    for (NSString *boundaryID in [self.collisionBehavior.boundaryIdentifiers copy]) {
        if ([boundaryID hasPrefix:CMUIKitPinballBumperBoundaryIdentifierPrefix]) {
            [self.collisionBehavior removeBoundaryWithIdentifier:boundaryID];
        }
    }

    [self.bumperViews enumerateObjectsUsingBlock:^(UIView *bumperView, NSUInteger idx, __unused BOOL *stop) {
        NSArray *bumperPosValue = bumperPositions[idx];
        CGPoint position;
        position.x = [bumperPosValue[0] floatValue];
        position.y = [bumperPosValue[1] floatValue];

        bumperView.center = position;

        NSString *boundaryID = [NSString stringWithFormat:@"%@%lu", CMUIKitPinballBumperBoundaryIdentifierPrefix, (unsigned long)idx];
        UIBezierPath *bumperPath = [UIBezierPath bezierPathWithOvalInRect:bumperView.frame];
        [self.collisionBehavior addBoundaryWithIdentifier:boundaryID forPath:bumperPath];
    }];
}

- (UIView *)newBumperView
{
    CGFloat const bumperRadius = ConfigValueForIdiom(CMUIKitPinballBumperRadiusPad, CMUIKitPinballBumperRadiusPhone);

    UIView *bumperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, bumperRadius * 2.0f, bumperRadius * 2.0f)];
    bumperView.backgroundColor = [UIColor greenColor];
    bumperView.layer.cornerRadius = bumperRadius;
    bumperView.layer.masksToBounds = YES;

    return bumperView;
}

- (void)handleBumperContactWithBoundaryIdentifier:(NSString *)boundaryID item:(id<UIDynamicItem>)item atPoint:(__unused CGPoint)p
{
    UIView *bumperView = [self bumperViewForBoundaryIdentifier:boundaryID];
    UIView *ballView = (UIView *)item;

    CGFloat bumpAngle = atan2(item.center.y - bumperView.center.y, item.center.x - bumperView.center.x);

    CGPoint itemBumpPoint = [ballView convertPoint:p fromView:self.dynamicAnimator.referenceView];

    UIOffset bumpOffset = UIOffsetMake(itemBumpPoint.x - CGRectGetWidth(ballView.bounds)/2.0f,
                                       itemBumpPoint.y - CGRectGetWidth(ballView.bounds)/2.0f);

    UIPushBehavior *bumpBehavior = self.bumperPushBehaviors[boundaryID];
    if (bumpBehavior) {
        [self.dynamicAnimator removeBehavior:bumpBehavior];
    }
    bumpBehavior = [[UIPushBehavior alloc] initWithItems:@[item] mode:UIPushBehaviorModeInstantaneous];
    [self.dynamicAnimator addBehavior:bumpBehavior];
    self.bumperPushBehaviors[boundaryID] = bumpBehavior;
    bumpBehavior.magnitude = 0.5f;
    bumpBehavior.angle = bumpAngle;
    [bumpBehavior setTargetOffsetFromCenter:bumpOffset forItem:item];
    bumpBehavior.active = YES;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5f, 1.5f, 1.0f)];
    animation.duration = 0.1;
    animation.autoreverses = YES;
    [bumperView.layer addAnimation:animation forKey:@"transform"];
}

- (UIView *)bumperViewForBoundaryIdentifier:(NSString *)boundaryID
{
    NSInteger index = [[boundaryID substringFromIndex:[CMUIKitPinballBumperBoundaryIdentifierPrefix length]] integerValue];
    UIView *bumperView = self.bumperViews[index];
    return bumperView;
}

@end
