//
//  UIDynamicAnimator+DynamicsXrayContactIntrospection.m
//  DynamicsXray
//
//  Created by Chris Miles on 9/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import "UIDynamicAnimator+DynamicsXrayContactIntrospection.h"

#import "DXRContactHandler.h"
#import "JRSwizzle.h"



@implementation UIDynamicAnimator (DynamicsXrayContactIntrospection)

+ (void)load
{
    DLog(@"Swizzling UIDynamicAnimator methods -didBeginContact: and didEndContact:");

    NSError *error = nil;
    if ([UIDynamicAnimator jr_swizzleMethod:NSSelectorFromString(@"didBeginContact:")
                                 withMethod:NSSelectorFromString(@"_xrayDidBeginContact:")
                                      error:&error] == NO) {
        DLog(@"Swizzle error: %@", error);
    }
    if ([UIDynamicAnimator jr_swizzleMethod:NSSelectorFromString(@"didEndContact:")
                                 withMethod:NSSelectorFromString(@"_xrayDidEndContact:")
                                      error:&error] == NO) {
        DLog(@"Swizzle error: %@", error);
    }
}


- (void)_xrayDidBeginContact:(PKPhysicsContact *)physicsContact
{
    NSString *contactClassName = [[physicsContact class] description];
    if ([contactClassName isEqualToString:@"PKPhysicsContact"]) {
        [DXRContactHandler handleBeginContactWithPhysicsContact:physicsContact];
    }

    // Pass to original method
    [self _xrayDidBeginContact:physicsContact];
}

- (void)_xrayDidEndContact:(PKPhysicsContact *)physicsContact
{
    NSString *contactClassName = [[physicsContact class] description];
    if ([contactClassName isEqualToString:@"PKPhysicsContact"]) {
        [DXRContactHandler handleEndContactWithPhysicsContact:physicsContact];
    }

    // Pass to original method
    [self _xrayDidEndContact:physicsContact];
}

@end
