//
//  DynamicsXray+XrayPushBehavior.m
//  DynamicsXray
//
//  Created by Chris Miles on 24/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray+XrayPushBehavior.h"
#import "DynamicsXray_Internal.h"
#import "DynamicsXray+XrayVisualiseBehaviors.h"
#import "DXRDecayingLifetime.h"


static NSString * const DXRXrayPushBehaviorPushPointsKey = @"pushPoints";


@implementation DynamicsXray (XrayPushBehavior)

- (void)instantaneousPushBehaviorDidBecomeActiveNotification:(NSNotification *)notification
{
    UIPushBehavior *pushBehavior = notification.object;

    DXRDecayingLifetime *pushLifetime = [self.instantaneousPushBehaviorCount objectForKey:pushBehavior];
    if (pushLifetime == nil) {
        pushLifetime = [[DXRDecayingLifetime alloc] init];
        pushLifetime.decayTime = 0.5;

        [self.instantaneousPushBehaviorCount setObject:pushLifetime forKey:pushBehavior];
    }

    NSMutableArray *pushPoints = [NSMutableArray array];
    for (id<UIDynamicItem> item in pushBehavior.items) {
        CGPoint pushPoint = item.center;

        UIOffset offset = [pushBehavior targetOffsetFromCenterForItem:item];
        pushPoint.x += offset.horizontal;
        pushPoint.y += offset.vertical;

        [pushPoints addObject:[NSValue valueWithCGPoint:pushPoint]];
    }
    pushLifetime.userInfo = @{DXRXrayPushBehaviorPushPointsKey: pushPoints};

    [pushLifetime incrementReferenceCount];
}


- (void)introspectInstantaneousPushBehaviors
{
    NSMutableArray *snuffedLifetimes = [NSMutableArray array];
    for (UIPushBehavior *instantaneousPushBehavior in self.instantaneousPushBehaviorCount) {
        DXRDecayingLifetime *pushLifetime = [self.instantaneousPushBehaviorCount objectForKey:instantaneousPushBehavior];
        [pushLifetime decrementReferenceCount];
        if (pushLifetime.decay > 0) {
            CGFloat transparency = 1.0f - pushLifetime.decay;
            NSArray *pushPoints = pushLifetime.userInfo[DXRXrayPushBehaviorPushPointsKey];
            [self visualiseInstantaneousPushBehavior:instantaneousPushBehavior atLocations:pushPoints withTransparency:transparency];
        }
        else {
            [snuffedLifetimes addObject:instantaneousPushBehavior];
        }
    }
    for (UIPushBehavior *instantaneousPushBehavior in snuffedLifetimes) {
        [self.instantaneousPushBehaviorCount removeObjectForKey:instantaneousPushBehavior];
    }
}

@end
