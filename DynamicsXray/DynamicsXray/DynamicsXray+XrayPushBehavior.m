//
//  DynamicsXray+XrayPushBehavior.m
//  DynamicsXray
//
//  Created by Chris Miles on 24/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray+XrayPushBehavior.h"
#import "DynamicsXray_Internal.h"
#import "DXRDecayingLifetime.h"


@implementation DynamicsXray (XrayPushBehavior)

- (void)instantaneousPushBehaviorDidBecomeActiveNotification:(NSNotification *)notification
{
    UIPushBehavior *pushBehavior = notification.object;

    DXRDecayingLifetime *pushLifetime = [self.instantaneousPushBehaviorCount objectForKey:pushBehavior];
    if (pushLifetime == nil) {
        pushLifetime = [[DXRDecayingLifetime alloc] init];
        [self.instantaneousPushBehaviorCount setObject:pushLifetime forKey:pushBehavior];
    }
    [pushLifetime incrementReferenceCount];
}

@end
