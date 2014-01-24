//
//  DynamicsXray+XrayPushBehavior.h
//  DynamicsXray
//
//  Created by Chris Miles on 24/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "DynamicsXray.h"
#import "DynamicsXray+XrayPushBehavior.h"
#import "UIPushBehavior+DynamicsXrayIntrospection.h"

@interface DynamicsXray (XrayPushBehavior)

- (void)instantaneousPushBehaviorDidBecomeActiveNotification:(NSNotification *)notification;

@end
