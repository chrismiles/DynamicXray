//
//  DynamicXray+XrayPushBehavior.h
//  DynamicXray
//
//  Created by Chris Miles on 24/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicXray.h"
#import "DynamicXray+XrayPushBehavior.h"
#import "UIPushBehavior+DynamicXrayIntrospection.h"

@interface DynamicXray (XrayPushBehavior)

- (void)instantaneousPushBehaviorDidBecomeActiveNotification:(NSNotification *)notification;

- (void)introspectInstantaneousPushBehaviors;

@end
