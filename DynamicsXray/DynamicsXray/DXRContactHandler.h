//
//  DXRContactHandler.h
//  DynamicsXray
//
//  Created by Chris Miles on 10/01/2014.
//  Copyright (c) 2014 Chris Miles. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DXRPhysicsKitPrivate.h"

extern NSString * const DXRDynamicsXrayContactDidBeginNotification;
extern NSString * const DXRDynamicsXrayContactDidEndNotification;


@interface DXRContactHandler : NSObject

+ (void)handleBeginContactWithPhysicsContact:(PKPhysicsContact *)physicsContact;

+ (void)handleEndContactWithPhysicsContact:(PKPhysicsContact *)physicsContact;

@end
