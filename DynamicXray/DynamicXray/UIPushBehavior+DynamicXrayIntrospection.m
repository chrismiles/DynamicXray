//
//  UIPushBehavior+DynamicXrayIntrospection.m
//  DynamicsXray
//
//  Created by Chris Miles on 24/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "UIPushBehavior+DynamicXrayIntrospection.h"
#import "JRSwizzle.h"


NSString * const DXRDynamicsXrayInstantaneousPushBehaviorDidBecomeActiveNotification = @"DXRDynamicsXrayInstantaneousPushBehaviorDidBecomeActiveNotification";


@implementation UIPushBehavior (DynamicXrayIntrospection)

+ (void)load
{
    //DLog(@"Swizzling UIPushBehavior method -setActive:");

    NSError *error = nil;
    if ([UIPushBehavior jr_swizzleMethod:NSSelectorFromString(@"setActive:")
                              withMethod:NSSelectorFromString(@"_xraySetActive:")
                                   error:&error] == NO) {
        DLog(@"Swizzle error: %@", error);
    }
}


- (void)_xraySetActive:(BOOL)active
{
    if (active && self.mode == UIPushBehaviorModeInstantaneous) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DXRDynamicsXrayInstantaneousPushBehaviorDidBecomeActiveNotification object:self userInfo:nil];
    }

    // Pass to original method
    [self _xraySetActive:active];
}

@end
